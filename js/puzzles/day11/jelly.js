const { Grid } = require("../../lib/grids");

function parseLines(lines) {
  return new Grid(
    lines.map((line) =>
      line
        .split("")
        .map((c) => ({ alreadyFlashed: false, energy: parseInt(c, 10) }))
    )
  );
}

function runStep(grid) {
  let flashCount = 0;
  grid.updateAll((value) => {
    return {
      ...value,
      alreadyFlashed: false,
      energy: value.energy + 1,
    };
  });
  let changed = true;
  while (changed) {
    changed = false;
    grid.updateAll((value, location) => {
      if (!value.alreadyFlashed && value.energy > 9) {
        changed = true;
        flashCount++;
        const newValue = { ...value, alreadyFlashed: true };
        grid.set(location, newValue);
        grid.updateEightNeighbors(location, (value) => ({
          ...value,
          energy: value.energy + 1,
        }));
        return newValue;
      }
      return value;
    });
  }
  grid.updateAll((value) => {
    if (value.alreadyFlashed) {
      return {
        ...value,
        alreadyFlashed: false,
        energy: 0,
      };
    }
    return value;
  });
  return flashCount;
}

module.exports = {
  parseLines,
  runStep,
};
