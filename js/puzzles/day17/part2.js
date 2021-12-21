const { getInput } = require("./inputs");
const { getSuccessfulInitialVelocties } = require("./helpers");

module.exports = async function main(inputStream, sample) {
  const bounds = await getInput(inputStream, sample);
  const hits = getSuccessfulInitialVelocties(bounds);

  // hits.map(({ x, y }) => `${x},${y}`).forEach((s) => console.log(s));
  return hits.length;
};
