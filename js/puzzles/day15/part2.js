const { getInput } = require("./input");
const { Grid } = require("../../lib/grids");
const { findCostOfShortestPath } = require("./shortest-path");

module.exports = async function main(inputStream) {
  const grid = new Grid(tileGrid5x((await getInput(false, inputStream)).grid));
  return findCostOfShortestPath(grid);
};

function tileGrid5x(grid) {
  // Extend each row.
  grid.forEach((row) => {
    const len = row.length;
    row.length = 5 * len;
    for (let i = 0; i < len; i++) {
      for (let x = 1; x <= 4; x++) {
        row[x * len + i] = incRisk(row[i], x);
      }
    }
  });

  // Copy each row five times.
  const height = grid.length;
  grid.length = 5 * height;
  for (let j = 0; j < height; j++) {
    for (let x = 1; x <= 4; x++) {
      grid[x * height + j] = grid[j].map((v) => incRisk(v, x));
    }
  }
  return grid;
}

function incRisk(origValue, by) {
  const inc = origValue + by;
  if (inc > 9) {
    return inc - 9;
  }
  return inc;
}
