function parseInput(inputLines) {
  return inputLines
    .filter((l) => l.trim())
    .reduce(
      ({ currentScanner, scanners }, line, lineNum) => {
        const mobj = /--- scanner ([0-9]+) ---/.exec(line);
        if (mobj) {
          currentScanner = mobj[1];
          if (scanners[currentScanner]) {
            throw new Error(
              `Found duplicate scanner ${currentScanner} on line ${lineNum + 1}`
            );
          }
          scanners[currentScanner] = [];
        } else {
          scanners[currentScanner].push(
            line
              .trim()
              .split(",")
              .map((s) => parseInt(s, 10))
          );
        }
        return { currentScanner, scanners };
      },
      { scanners: {}, currentScanner: null }
    );
}

module.exports = parseInput;
