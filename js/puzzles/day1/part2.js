const enter = require("../../lib/enter");
const readline = require("readline");

module.exports = async function main(inputStream) {
  const rl = readline.createInterface({
    input: inputStream,
  });

  let slidingWindow = [];
  let increaseCount = 0;
  for await (const line of rl) {
    const value = parseInt(line, 10);
    if (slidingWindow.length < 3) {
      slidingWindow.push(value);
    } else {
      const prevSum = slidingWindow.reduce(
        (partialSum, v) => partialSum + v,
        0
      );
      const oldest = slidingWindow.shift();
      slidingWindow.push(value);
      const newSum = prevSum - oldest + value;
      if (newSum > prevSum) {
        increaseCount++;
      }
    }
  }
  return increaseCount;
};
