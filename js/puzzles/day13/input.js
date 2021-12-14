const { getInputLines } = require("../../lib/loader");

module.exports = async function getInput(useSample, inputStream) {
  testText = `6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5`;
  return parseLines(await getInputLines(useSample, inputStream, testText));
};

function parseLines(lines) {
  const res = lines.reduce(
    (obj, line) => {
      if (obj.state === 0) {
        if (line.trim().length) {
          obj.dots.add(line);
        } else {
          obj.state = 1;
        }
      } else {
        [, axis, coord] = /^\s*fold along ([xy])=([0-9]+)\s*$/.exec(line);
        obj.folds.push([axis, coord]);
      }
      return obj;
    },
    { state: 0, dots: new Set(), folds: [] }
  );
  return {
    dots: res.dots,
    folds: res.folds,
  };
}
