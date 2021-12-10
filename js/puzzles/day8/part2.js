const enter = require("../../lib/enter");
const readline = require("readline");

const ALL_SEGMENT_KEYS = [0, 1, 2, 3, 4, 5, 6];

let debug = false;

module.exports = async function main(inputStream) {
  //   const inputLines =
  //     `be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
  // edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
  // fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
  // fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
  // aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
  // fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
  // dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
  // bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
  // egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
  // gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
  // `
  //       .split(/\n/)
  //       .filter((line) => line.trim());

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

  return inputLines.reduce((sum, line) => {
    const [signalPatterns, output] = parseLine(line);
    const allInfo = signalPatterns;
    const conclusions = drawConclusions(allInfo);
    return sum + conclusions.decode(output);
  }, 0);
};

function drawConclusions(allInfo) {
  const conclusions = new Conclusions();
  while (true) {
    let changed = false;
    for (const word of allInfo) {
      switch (drawConclusionsFromWord(conclusions, word)) {
        case SOLVED:
          return conclusions;
        case CHANGED:
          changed = true;
      }
    }
    if (!changed) {
      console.log(conclusions.toJSON());
      throw new Error(
        "We went through everything we knew and didn't draw any new conclusions"
      );
    }
  }
}

const CHANGED = Symbol("changed");
const UNCHANGED = Symbol("unchanged");
const SOLVED = Symbol("solved");

function segmentKeysToValue(segmentKeys) {
  return segmentKeys
    .map((seg) => Math.pow(2, seg))
    .reduce((sum, value) => sum + value, 0);
}

function sevenSegmentDecoder(litSegments) {
  const found = {
    [segmentKeysToValue([0, 1, 2, 4, 5, 6])]: 0,
    [segmentKeysToValue([2, 5])]: 1,
    [segmentKeysToValue([0, 2, 3, 4, 6])]: 2,
    [segmentKeysToValue([0, 2, 3, 5, 6])]: 3,
    [segmentKeysToValue([1, 2, 3, 5])]: 4,
    [segmentKeysToValue([0, 1, 3, 5, 6])]: 5,
    [segmentKeysToValue([0, 1, 3, 4, 5, 6])]: 6,
    [segmentKeysToValue([0, 2, 5])]: 7,
    [segmentKeysToValue([0, 1, 2, 3, 4, 5, 6])]: 8,
    [segmentKeysToValue([0, 1, 2, 3, 5, 6])]: 9,
  }[segmentKeysToValue(litSegments)];
  if (typeof found === "undefined") {
    throw new Error(
      `Couldn't decode seven seg value: ${litSegments.join(", ")}`
    );
  }
  return found;
}

class Conclusions {
  constructor() {
    // Keyed by segment key, a set of all possible segments that could light it.
    this._possibleSignalsForEachSegment = ALL_SEGMENT_KEYS.reduce(
      (map, segmentNumber) => {
        map.set(segmentNumber, new Set(["a", "b", "c", "d", "e", "f", "g"]));
        return map;
      },
      new Map()
    );
    // Keyed by the signal characters, the segment key for the segment it's known to light.
    this._knownSegmentDrivers = new Map();
    // Keyed by the segment key, the signal character that is known to light it.
    this._knownSignals = new Map();
  }

  decode(words) {
    return words
      .map((word) => {
        const litSegments = [...word].map((signal) =>
          this._knownSegmentDrivers.get(signal)
        );
        return sevenSegmentDecoder(litSegments);
      })
      .reduce((sum, digit) => {
        return sum * 10 + digit;
      }, 0);
  }

  toJSON() {
    return Object.fromEntries(this._possibleSignalsForEachSegment.entries());
  }

  getKnownSegmentDrivers() {
    return Object.fromEntries(this._knownSegmentDrivers.entries());
  }

  isSegmentKnownToBeOff(segmentKey, whenDriversAreOn) {
    const allPossibleDrivers =
      this._possibleSignalsForEachSegment.get(segmentKey);
    return [...allPossibleDrivers].every(
      (possibleDriver) => !whenDriversAreOn.has(possibleDriver)
    );
  }

  isSegmentKnownToBeLit(segmentKey, whenDriversAreOn) {
    const allPossibleDrivers =
      this._possibleSignalsForEachSegment.get(segmentKey);
    return [...allPossibleDrivers].every((possibleDriver) =>
      whenDriversAreOn.has(possibleDriver)
    );
  }

  _updatePossibleSignalsForSegment(segmentKey, updater) {
    const existingPossibleDrivers =
      this._possibleSignalsForEachSegment.get(segmentKey);
    const possibleDrivers = updater(existingPossibleDrivers);
    if (possibleDrivers.size < existingPossibleDrivers.size) {
      this._possibleSignalsForEachSegment.set(segmentKey, possibleDrivers);
      if (possibleDrivers.size === 1) {
        const [knownDriverSignal] = [...possibleDrivers];
        this._knownSegmentDrivers.set(knownDriverSignal, segmentKey);
        this._knownSignals.set(segmentKey, knownDriverSignal);
        if (this._knownSignals.size === ALL_SEGMENT_KEYS.length) {
          return SOLVED;
        }
      }
      return CHANGED;
    }
    return UNCHANGED;
  }

  segmentMustBeLitByOneOf(segmentKey, possibleDrivers) {
    return this._updatePossibleSignalsForSegment(
      segmentKey,
      (existingPossibleDrivers) =>
        intersect(existingPossibleDrivers, possibleDrivers)
    );
  }

  segmentCannotBeLitBy(segmentKey, impossibleDrivers) {
    return this._updatePossibleSignalsForSegment(
      segmentKey,
      (existingPossibleDrivers) =>
        remove(existingPossibleDrivers, impossibleDrivers)
    );
  }
}

function drawConclusionsFromWord(conclusions, word) {
  switch (word.size) {
    case 2:
      // This is a one
      return drawConclusionsFromDefinitePattern(
        conclusions,
        new Set([2, 5]),
        word
      );
    case 3:
      // This is a seven
      return drawConclusionsFromDefinitePattern(
        conclusions,
        new Set([0, 2, 5]),
        word
      );
    case 4:
      // This is a four
      return drawConclusionsFromDefinitePattern(
        conclusions,
        new Set([1, 2, 3, 5]),
        word
      );
    case 5:
      // This could be a 2, 3, or 5
      return mustBeTwoThreeOrFive(conclusions, word);
    case 6:
      // This could be a 0, 6, or 9
      return mustBeZeroSixOrNine(conclusions, word);

    case 7:
      // This is an 8, which doesn't help.
      return UNCHANGED;

    default:
      throw new Error(
        `Couldn't figure out word with ${word.size} signals on: ${[
          ...word,
        ].join("")}`
      );
  }
  return map;
}

function mustBeZeroSixOrNine(conclusions, word) {
  return coalesceConclusionResult(
    drawConclusionsFromPatterns(
      conclusions,
      new Set([0, 1, 6]),
      new Set(),
      word
    ),
    () => {
      if (
        conclusions.isSegmentKnownToBeOff(3, word) ||
        (conclusions.isSegmentKnownToBeLit(2, word) &&
          conclusions.isSegmentKnownToBeLit(4, word))
      ) {
        return mustBeZero(conclusions, word);
      } else if (
        conclusions.isSegmentKnownToBeOff(2, word) ||
        conclusions.isSegmentKnownToBeLit(3, word)
      ) {
        return mustBeSixOrNine(conclusions, word);
      } else if (conclusions.isSegmentKnownToBeLit(4, word)) {
        return mustBeZeroOrSix(conclusions, word);
      } else if (conclusions.isSegmentKnownToBeLit(2, word)) {
        return mustBeZeroOrNine(conclusions, word);
      }
      return UNCHANGED;
    }
  );
}

function mustBeZeroOrNine(conclusions, word) {
  return coalesceConclusionResult(
    drawConclusionsFromPatterns(
      conclusions,
      new Set([0, 1, 2, 5, 6]),
      new Set(),
      word
    ),
    () => {
      if (
        conclusions.isSegmentKnownToBeLit(3, word) ||
        conclusions.isSegmentKnownToBeOff(4, word)
      ) {
        return mustBeNine(conclusions, word);
      } else if (
        conclusions.isSegmentKnownToBeLit(4, word) ||
        conclusions.isSegmentKnownToBeOff(3, word)
      ) {
        return mustBeZero(conclusions, word);
      }
      return UNCHANGED;
    }
  );
}

function mustBeZeroOrSix(conclusions, word) {
  return coalesceConclusionResult(
    drawConclusionsFromPatterns(
      conclusions,
      new Set([0, 1, 4, 5, 6]),
      new Set(),
      word
    ),
    () => {
      if (
        conclusions.isSegmentKnownToBeLit(3, word) ||
        conclusions.isSegmentKnownToBeOff(2, word)
      ) {
        return mustBeSix(conclusions, word);
      } else if (
        conclusions.isSegmentKnownToBeLit(2, word) ||
        conclusions.isSegmentKnownToBeOff(3, word)
      ) {
        return mustBeZero(conclusions, word);
      }
      return UNCHANGED;
    }
  );
}

function mustBeSixOrNine(conclusions, word) {
  return coalesceConclusionResult(
    drawConclusionsFromPatterns(
      conclusions,
      new Set([0, 1, 3, 5, 6]),
      new Set(),
      word
    ),
    () => {
      if (
        conclusions.isSegmentKnownToBeLit(4, word) ||
        conclusions.isSegmentKnownToBeOff(2, word)
      ) {
        return mustBeSix(conclusions, word);
      } else if (
        conclusions.isSegmentKnownToBeLit(2, word) ||
        conclusions.isSegmentKnownToBeOff(4, word)
      ) {
        return mustBeNine(conclusions, word);
      }
      return UNCHANGED;
    }
  );
}

function mustBeTwoThreeOrFive(conclusions, word) {
  return coalesceConclusionResult(
    drawConclusionsFromPatterns(
      conclusions,
      new Set([0, 3, 6]),
      new Set(),
      word
    ),
    () => {
      if (
        conclusions.isSegmentKnownToBeLit(1, word) ||
        conclusions.isSegmentKnownToBeOff(2, word)
      ) {
        return mustBeFive(conclusions, word);
      } else if (
        conclusions.isSegmentKnownToBeLit(4, word) ||
        conclusions.isSegmentKnownToBeOff(5, word)
      ) {
        return mustBeTwo(conclusions, word);
      } else if (
        (conclusions.isSegmentKnownToBeLit(2, word) &&
          conclusions.isSegmentKnownToBeLit(5, word)) ||
        (conclusions.isSegmentKnownToBeOff(1, word) &&
          conclusions.isSegmentKnownToBeOff(4, word))
      ) {
        return mustBeThree(conclusions, word);
      }
      return UNCHANGED;
    }
  );
}

function mustBeZero(conclusions, word) {
  return drawConclusionsFromDefinitePattern(
    conclusions,
    new Set([0, 1, 2, 4, 5, 6]),
    word
  );
}

function mustBeSix(conclusions, word) {
  return drawConclusionsFromDefinitePattern(
    conclusions,
    new Set([0, 1, 3, 4, 5, 6]),
    word
  );
}

function mustBeNine(conclusions, word) {
  return drawConclusionsFromDefinitePattern(
    conclusions,
    new Set([0, 1, 2, 3, 5, 6]),
    word
  );
}

function mustBeFive(conclusions, word) {
  return drawConclusionsFromDefinitePattern(
    conclusions,
    new Set([0, 1, 3, 5, 6]),
    word
  );
}

function mustBeTwo(conclusions, word) {
  return drawConclusionsFromDefinitePattern(
    conclusions,
    new Set([0, 2, 3, 4, 6]),
    word
  );
}

function mustBeThree(conclusions, word) {
  return drawConclusionsFromDefinitePattern(
    conclusions,
    new Set([0, 2, 3, 5, 6]),
    word
  );
}

function drawConclusionsFromDefinitePattern(
  conclusions,
  onlyLitSegmentKeys,
  onlyOnSignals
) {
  const unlitSegmentKeys = new Set(
    ALL_SEGMENT_KEYS.filter((segmentKey) => !onlyLitSegmentKeys.has(segmentKey))
  );
  return drawConclusionsFromPatterns(
    conclusions,
    onlyLitSegmentKeys,
    unlitSegmentKeys,
    onlyOnSignals
  );
}

function withDebug(func) {
  debug = true;
  try {
    return func();
  } finally {
    debug = false;
  }
}

function drawConclusionsFromPatterns(
  conclusions,
  knownLitSegmentKeys,
  knownUnlitSegmentKeys,
  onlyOnSignals
) {
  return ALL_SEGMENT_KEYS.reduce((res, segmentKey) => {
    if (knownLitSegmentKeys.has(segmentKey)) {
      return withDebug(() =>
        coalesceConclusionResult(
          res,
          conclusions.segmentMustBeLitByOneOf(segmentKey, onlyOnSignals)
        )
      );
    } else if (knownUnlitSegmentKeys.has(segmentKey)) {
      return coalesceConclusionResult(
        res,
        conclusions.segmentCannotBeLitBy(segmentKey, onlyOnSignals)
      );
    }
    return res;
  }, UNCHANGED);
}

function log(...args) {
  if (debug) {
    console.log(...args);
  }
}

function coalesceConclusionResult(priorResult, newResult) {
  if (priorResult === SOLVED) {
    return SOLVED;
  }
  const nr = typeof newResult === "function" ? newResult() : newResult;
  switch (nr) {
    case SOLVED:
      return SOLVED;

    case CHANGED:
      return CHANGED;

    case UNCHANGED:
      return priorResult;

    default:
      throw new Error(`Unknown result: ${nr}`);
  }
}

function intersect(setA, setB) {
  return [...setA].reduce((s, value) => {
    if (setB.has(value)) {
      s.add(value);
    }
    return s;
  }, new Set());
}

function remove(setA, setB) {
  return [...setA].reduce((s, value) => {
    if (!setB.has(value)) {
      s.add(value);
    }
    return s;
  }, new Set());
}

function parseLine(inputText) {
  return inputText
    .split(" | ")
    .map((part) => part.split(" ").map((word) => new Set(word.split(""))));
}
