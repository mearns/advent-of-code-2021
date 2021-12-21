const { getInput } = require("./inputs");
const { parse, add } = require("./helpers");

module.exports = async function main(inputStream, sample) {
  const lines = await getInput(inputStream, sample);
  let greatestMag = -Infinity;
  for (let i = 0; i < lines.length; i++) {
    const firstLine = lines[i];
    for (let j = 0; j < lines.length; j++) {
      const secondLine = lines[j];
      const magnitude = add(parse(firstLine), parse(secondLine))
        .reduceCompletely()
        .magnitude();
      if (magnitude > greatestMag) {
        greatestMag = magnitude;
      }
    }
  }
  return greatestMag;
};
