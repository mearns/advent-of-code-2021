const { getInput } = require("./input");
const { parse } = require("./parser");
const BitBuffer = require("./bit-buffer");
const util = require("util");

module.exports = async function main(inputStream, useSample) {
  const input = await getInput(useSample, inputStream);
  const buffer = new BitBuffer(input);
  const packet = parse(buffer);
  console.log(util.inspect(packet, false, Infinity, true));
  console.log(buffer);
  return packet.value;
};
