const { getInput } = require("./input");
const { parse } = require("./parser");
const BitBuffer = require("./bit-buffer");

module.exports = async function main(inputStream, useSample) {
  const input = await getInput(useSample, inputStream);
  const packet = parse(new BitBuffer(input));
  return sumVersionNumbers(packet);
};

function sumVersionNumbers(packet) {
  return (
    packet.packetVersion +
    (packet.packets || [])
      .map(sumVersionNumbers)
      .reduce((sum, value) => sum + value, 0)
  );
}
