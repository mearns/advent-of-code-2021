const { getInput } = require("./inputs");
const { parse } = require("./helpers");

module.exports = async function main(inputStream, sample) {
  const lines = (await getInput(inputStream, sample)).map((line) =>
    parse(line)
  );
  const [line] = lines;
  line.left.right.right.right.explode();
  return line;
};
