const { getInputLines } = require("../../lib/loader");
const { Grid } = require("../../lib/grids");

async function getRawGrid(useSample, inputStream) {
  const testText = `1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581`;
  return await getInputLines(useSample, inputStream, testText, true);
}

async function getInput(useSample, inputStream) {
  return Grid.loadFromDecimalDigits(await getRawGrid(useSample, inputStream));
}

module.exports = {
  getInput,
};
