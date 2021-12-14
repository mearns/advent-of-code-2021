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
  constructor(grid) {
    this.grid = grid;
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

module.exports = {
  Grid,
};
