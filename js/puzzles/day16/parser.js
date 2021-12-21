const { fromBinary } = require("./binary");

const LITERAL_VALUE = 4;

function parse(buffer) {
  const packetVersion = buffer.consumeValue(3);
  const packetType = buffer.consumeValue(3);
  switch (packetType) {
    case LITERAL_VALUE:
      return {
        packetVersion,
        packetType,
        value: parseLiteralValuePacket(buffer),
      };

    default:
      const packet = {
        packetVersion,
        packetType,
        packets: parseOperatorPacket(buffer),
      };
      const value = evaluate(packet);
      packet.value = value;
      return packet;
  }
}

function parseOperatorPacket(buffer) {
  const lengthTypeId = buffer.consumeValue(1);
  const length = buffer.consumeValue(lengthTypeId === 0 ? 15 : 11);
  if (lengthTypeId === 0) {
    return parseFixedLengthSubpackets(length, buffer);
  }
  return parseFixedNumberOfSubpackets(length, buffer);
}

function parseFixedNumberOfSubpackets(count, buffer) {
  const packets = [];
  while (packets.length < count) {
    packets.push(parse(buffer));
  }
  return packets;
}

function parseFixedLengthSubpackets(length, buffer) {
  const subpacketBuffer = buffer.sliceOff(length);
  const packets = [];
  while (!subpacketBuffer.isEmpty()) {
    packets.push(parse(subpacketBuffer));
  }
  return packets;
}

function parseLiteralValuePacket(buffer) {
  let value = 0n;
  const bits = [];
  const digits = [];
  while (true) {
    const flag = buffer.consumeValue(1);
    const chunk = buffer.consume(4);
    bits.push(...chunk);
    digits.push(fromBinary(chunk));
    value = value * 16n + BigInt(fromBinary(chunk));
    if (flag === 0) {
      console.log("IMMEDIATE", value, digits);
      return value;
    }
  }
}

function evaluate(packet) {
  const children = (packet.packets || []).map(evaluate);
  switch (packet.packetType) {
    case 4:
      // Immediate:
      return packet.value;
    case 0:
      // Sum
      return children.reduce((sum, value) => sum + value);
    case 1:
      // Product
      return children.reduce((prod, value) => prod * value);
    case 2:
      // Min
      return children.reduce((min, value) => (value < min ? value : min));
    case 3:
      // Max
      return children.reduce((min, value) => (value > min ? value : min));
    case 5:
      // GT
      return gt(children);
    case 6:
      // LT
      return lt(children);
    case 7:
      // EQ
      return eq(children);

    default:
      throw Object.assign(
        new Error(`Unknown packet type ${packet.packetType}`),
        {
          packet,
        }
      );
  }
}

function gt([a, b, ...other]) {
  assertEmpty(other);
  return a > b ? 1n : 0n;
}
function lt([a, b, ...other]) {
  assertEmpty(other);
  return a < b ? 1n : 0n;
}
function eq([a, b, ...other]) {
  assertEmpty(other);
  return a === b ? 1n : 0n;
}

function assertEmpty(list) {
  if (list.length !== 0) {
    throw Object.assign(new Error("Expected list to be empty"), { list });
  }
}

module.exports = {
  parse,
};
