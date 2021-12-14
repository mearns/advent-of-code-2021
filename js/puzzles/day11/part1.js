const enter = require("../../lib/enter");
const { getInputLines } = require("../../lib/loader");
const { runStep, parseLines } = require("./jelly");

module.exports = async function main(inputStream) {
  testText = `5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526`;

  const count = runSteps(
    100,
    parseLines(await getInputLines(false, inputStream, testText))
  );
  return count;
};

function runSteps(stepCount, grid) {
  let totalFlashes = 0;
  for (let i = 0; i < stepCount; i++) {
    totalFlashes += runStep(grid);
  }
  return totalFlashes;
}
