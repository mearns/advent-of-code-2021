const enter = require("../../lib/enter");
const getInput = require("./input");

module.exports = async function main(inputStream) {
  return await getInput(true, inputStream);
};
