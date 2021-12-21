const { getInput } = require("./inputs");
const { parse, add } = require("./helpers");

module.exports = async function main(inputStream, sample) {
  const lines = (await getInput(inputStream, sample)).map((line) =>
    parse(line)
  );
  const sum = lines.reduce((sum, line) => add(sum, line).reduceCompletely());
  return sum;
};
