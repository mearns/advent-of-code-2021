const { Caves } = require("./caves");
const { getInputLines } = require("../../lib/loader");

module.exports = async function getInput(useSample, inputStream) {
  testText = `start-A
start-b
A-c
A-b
b-d
A-end
b-end`;
  return new Caves(
    parseLines(await getInputLines(useSample, inputStream, testText))
  );
};

function parseLines(lines) {
  return lines.map(parseLine);
}

function parseLine(line) {
  const [, a, b] = /^\s*([a-z]+)-([a-z]+)\s*$/i.exec(line);
  return [a, b];
}
