const { getInputLines } = require("../../lib/loader");
const sampleInput = require("./sample1");

async function getInput(inputStream, useSample) {
  return await getInputLines(useSample, inputStream, sampleInput, true);
}

module.exports = getInput;
