const enter = require("../../lib/enter");
const { getInputLines } = require("../../lib/loader");
const { getIncompleteLines } = require("./nav-system");

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
  const scores = getIncompleteLines(inputLines)
    .map(autocomplete)
    .sort((a, b) => b - a);
  return scores[(scores.length - 1) / 2];
};

const AUTOCOMPLETE_SCORES = {
  ")": 1,
  "]": 2,
  "}": 3,
  ">": 4,
};

function autocomplete(line) {
  return line.missing
    .map((c) => AUTOCOMPLETE_SCORES[c])
    .reduce((sum, score) => sum * 5 + score, 0);
}
