const enter = require("../../lib/enter");
const { getInputLines } = require("../../lib/loader");
const { getCorruptedLines } = require("./nav-system");

module.exports = async function main(inputStream) {
  testText = `[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]`;

  const inputLines = await getInputLines(false, inputStream, testText);
  console.log(
    getCorruptedLines(inputLines)
      .map((res) => res.score)
      .reduce((sum, score) => sum + score, 0)
  );
};
