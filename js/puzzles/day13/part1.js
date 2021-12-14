const enter = require("../../lib/enter");
const getInput = require("./input");
const { fold } = require("./helper");

module.exports = async function main(inputStream) {
  const { dots, folds } = await getInput(false, inputStream);
  const [firstFold] = folds;
  return fold(firstFold, dots).size;
};
