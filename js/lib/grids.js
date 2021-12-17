const FOUR_NEIGHBORS_OFFSETS = [
  [0, -1],
  [-1, 0],
  [1, 0],
  [0, 1],
];

const EIGHT_NEIGHBORS_OFFSETS = [
  [-1, -1],
  [0, -1],
  [1, -1],
  [-1, 0],
  [1, 0],
  [-1, 1],
  [0, 1],
  [1, 1],
];

class Grid {
  /**
   * @param grid Is an array of arrays. Outer array contains the rows. So for column X row Y,
   * you access it as grid[Y][X].
   */
  constructor(grid) {
    this.grid = grid;
  }

  height() {
    return this.grid.length;
  }

  width() {
    return this.grid.reduce((width, row) => Math.max(width, row.length), 0);
  }

  size() {
    return this.grid
      .map((row) => row.length)
      .reduce((sum, length) => sum + length, 0);
  }

  inBounds([i, j]) {
    return i >= 0 && j >= 0 && j < this.grid.length && i < this.grid[j].length;
  }

  get([i, j]) {
    return this.grid[j][i];
  }

  set([i, j], value) {
    this.grid[j][i] = value;
  }

  update([i, j], updater) {
    this.grid[j][i] = updater(this.grid[j][i], [i, j], this);
  }

  updateAll(updater) {
    for (let j = 0; j < this.grid.length; j++) {
      const row = this.grid[j];
      for (let i = 0; i < row.length; i++) {
        this.update([i, j], updater);
      }
    }
  }

  getFourNeighborAddresses([i, j]) {
    return FOUR_NEIGHBORS_OFFSETS.map(([dx, dy]) => [i + dx, j + dy]).filter(
      ([i, j]) => this.inBounds([i, j])
    );
  }

  updateFourNeighbors([i, j], updater) {
    this.getFourNeighborAddresses([i, j]).forEach((address) =>
      this.update(address, updater)
    );
  }
  getEightNeighborAddresses([i, j]) {
    return EIGHT_NEIGHBORS_OFFSETS.map(([dx, dy]) => [i + dx, j + dy]).filter(
      ([i, j]) => this.inBounds([i, j])
    );
  }

  updateEightNeighbors([i, j], updater) {
    this.getEightNeighborAddresses([i, j]).forEach((address) =>
      this.update(address, updater)
    );
  }
}

Grid.loadFromDecimalDigits = (lines) => {
  return new Grid(
    lines.map((line) => line.split("").map((c) => parseInt(c, 10)))
  );
};

module.exports = {
  Grid,
};
