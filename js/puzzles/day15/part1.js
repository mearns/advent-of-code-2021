const { getInput } = require("./input");
const { findCostOfShortestPath } = require("./shortest-path");

module.exports = async function main(inputStream) {
  const grid = await getInput(false, inputStream);
  return findCostOfShortestPath(grid);
};
