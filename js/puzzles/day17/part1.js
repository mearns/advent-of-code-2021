const { getInput } = require("./inputs");
const { getSuccessfulInitialVelocties } = require("./helpers");

module.exports = async function main(inputStream, sample) {
  const bounds = await getInput(inputStream, sample);
  const hits = getSuccessfulInitialVelocties(bounds);

  return Math.max(...hits.map((s) => Math.max(...s.yvalues)));
};
