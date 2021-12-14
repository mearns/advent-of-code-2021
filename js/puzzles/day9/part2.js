const enter = require("../../lib/enter");
const { getInputLines } = require("../../lib/loader");

module.exports = async function main(inputStream) {
  testText = `2199943210
3987894921
9856789892
8767896789
9899965678`;

  const inputLines = await getInputLines(false, inputStream, testText);

  const matrix = inputLines.map(parseLine);
  const lowPoints = findLowPoints(matrix);
  const [a, b, c] = findBasinSizes(lowPoints, matrix).sort((a, b) => b - a);
  return a * b * c;
};

function findBasinSizes(lowPoints, matrix) {
  return lowPoints.map(([i, j]) => {
    basin = new Set();
    floodFill(basin, [i, j], matrix);
    return basin.size;
  });
}

function floodFill(basin, [i, j], matrix) {
  const key = `${i}x${j}`;
  if (basin.has(key) || matrix[j][i] == 9) {
    return;
  }
  basin.add(key);
  [
    [0, -1],
    [-1, 0],
    [1, 0],
    [0, 1],
  ]
    .map(([di, dj]) => [i + di, j + dj])
    .filter(
      ([x, y]) => x >= 0 && y >= 0 && y < matrix.length && x < matrix[y].length
    )
    .forEach(([x, y]) => floodFill(basin, [x, y], matrix));
}

function findLowPoints(matrix) {
  const allLowPoints = [];
  for (let j = 0; j < matrix.length; j++) {
    const row = matrix[j];
    for (let i = 0; i < row.length; i++) {
      const cell = row[i];
      const neighbors = [
        [-1, -1],
        [0, -1],
        [1, -1],
        [-1, 0] /* 0,0 */,
        ,
        [1, 0],
        [-1, 1],
        [0, 1],
        [1, 1],
      ]
        .map(([di, dj]) => [i + di, j + dj])
        .filter(
          ([x, y]) => x >= 0 && y >= 0 && x < row.length && y < matrix.length
        )
        .map(([x, y]) => matrix[y][x]);

      const isLowPoint = neighbors.every((neighbor) => cell < neighbor);
      if (isLowPoint) {
        allLowPoints.push([i, j]);
      }
    }
  }
  return allLowPoints;
}

function parseLine(inputText) {
  return inputText.split("").map((digit) => parseInt(digit, 10));
}
