const { getInputLines } = require("../../lib/loader");
const { Grid } = require("../../lib/grids");

async function getInput(useSample, inputStream) {
  const test1Text = "D2FE28";
  const test2Text = "38006F45291200";
  const test3Text = "EE00D40C823060";
  const test4Text = "9C0141080250320F1802104A08";
  const test5Text = "04005AC33890";
  return (await getInputLines(useSample, inputStream, test5Text, true))
    .join("")
    .trim()
    .split("")
    .map((c) => parseHex(c))
    .join("")
    .split("")
    .map((b) => parseInt(b, 10));
}

const HEX_MAP = {
  0: "0000",
  1: "0001",
  2: "0010",
  3: "0011",
  4: "0100",
  5: "0101",
  6: "0110",
  7: "0111",
  8: "1000",
  9: "1001",
  A: "1010",
  B: "1011",
  C: "1100",
  D: "1101",
  E: "1110",
  F: "1111",
};

function parseHex(c) {
  return HEX_MAP[c];
}

module.exports = {
  getInput,
};
