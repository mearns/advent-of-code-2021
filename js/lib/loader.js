const readline = require("readline");

async function getInputLines(useTest, inputStream, testText) {
  if (useTest) {
    return testText.split(/\n/);
  } else {
    const rl = readline.createInterface({
      input: inputStream,
    });
    const inputLines = [];
    for await (const line of rl) {
      const trimmed = line.trim();
      if (trimmed) {
        inputLines.push(trimmed);
      }
    }
    return inputLines;
  }
}

module.exports = {
  getInputLines,
};
