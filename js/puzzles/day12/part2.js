const enter = require("../../lib/enter");
const getInput = require("./input");

module.exports = async function main(inputStream) {
  const caves = await getInput(false, inputStream);
  return caves.findAllPaths2().size;
};
