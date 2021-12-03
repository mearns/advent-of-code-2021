const enter = require("../../lib/enter");
const readline = require("readline");

module.exports = async function main(inputStream) {
  const rl = readline.createInterface({
    input: inputStream,
  });

  let prev = null;
  let increaseCount = 0;
  for await (const line of rl) {
    const value = parseInt(line, 10);
    if (prev === null) {
      prev = value;
    } else {
      if (value > prev) {
        increaseCount++;
      }
      prev = value;
    }
  }
  return increaseCount;
};
