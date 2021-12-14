function getCorruptedLines(inputLines) {
  return inputLines
    .map((line) => {
      return { ...parseLine(line), line };
    })
    .filter((res) => res.corrupted);
}

function getIncompleteLines(inputLines) {
  return inputLines
    .map((line) => {
      return { ...parseLine(line), line };
    })
    .filter((res) => res.incomplete);
}

const CLOSING_CHAR_MAP = {
  "(": ")",
  "[": "]",
  "{": "}",
  "<": ">",
};

const SYNTAX_ERROR_SCORES = {
  ")": 3,
  "]": 57,
  "}": 1197,
  ">": 25137,
};

function parseLine(line) {
  const stack = [];
  for (let i = 0; i < line.length; i++) {
    const c = line.charAt(i);
    const closingChar = CLOSING_CHAR_MAP[c];
    if (closingChar) {
      // c is an opening char, this is the one we're looking for.
      stack.push(closingChar);
    } else if (stack[stack.length - 1] == c) {
      // This closes the chunk at the top of the stack, great.
      stack.pop();
    } else {
      return {
        corrupted: true,
        message: `Expected ${
          stack[stack.length - 1]
        } to close the current chunk, or an opening character to start a new chunk. Found ${c} at index ${i}`,
        score: SYNTAX_ERROR_SCORES[c],
      };
    }
  }
  if (stack.length) {
    const missing = [...stack].reverse();
    return {
      incomplete: true,
      missing,
      message: `Reached end of line while still expecting the find the following closing chars: ${missing.join(
        ", "
      )}`,
    };
  }
  return { success: true };
}

module.exports = {
  getCorruptedLines,
  getIncompleteLines,
};
