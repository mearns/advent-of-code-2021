const enter = require("../../lib/enter");
const getInput = require("./input");

module.exports = async function main(inputStream) {
  const { dots, folds } = await getInput(false, inputStream);
  const [firstFold] = folds;
  return fold(firstFold, dots).size;
};

function fold([axis, coord], dots) {
  if (axis === "y") {
    return foldOverHorizontal(coord, dots);
  }
  return foldOverVertical(coord, dots);
}

function foldOverHorizontal(yCoord, points) {
  const results = new Set();
  points.forEach((key) => {
    const [x, y] = parse(key);
    if (y < yCoord) {
      results.add(key);
    } else {
      results.add(toKey([x, yCoord - (y - yCoord)]));
    }
  });
  return results;
}

function foldOverVertical(xCoord, points) {
  const results = new Set();
  points.forEach((key) => {
    const [x, y] = parse(key);
    if (x < xCoord) {
      results.add(key);
    } else {
      results.add(toKey([xCoord - (x - xCoord), y]));
    }
  });
  return results;
}

function parse(key) {
  return key.split(",").map((s) => parseInt(s, 10));
}

function toKey([x, y]) {
  return `${x},${y}`;
}
