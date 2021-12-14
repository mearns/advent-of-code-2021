const enter = require("../../lib/enter");
const getInput = require("./input");
const { fold, parse } = require("./helper");

module.exports = async function main(inputStream) {
  const { dots, folds } = await getInput(false, inputStream);
  const coords = [
    ...folds.reduce((dots, instruction) => fold(instruction, dots), dots),
  ].map(parse);

  const maxY = Math.max(...coords.map(([x, y]) => y));
  const maxX = Math.max(...coords.map(([x, y]) => x));
  const grid = new Array(maxY + 1)
    .fill(null)
    .map(() => new Array(maxX + 1).fill(" "));

  coords.forEach(([x, y]) => {
    grid[y][x] = "#";
  });
  return grid.map((row) => row.join("")).join("\n");
};
