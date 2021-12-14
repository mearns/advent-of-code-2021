class Caves {
  constructor(pairs) {
    this.nodes = new Map();
    pairs.forEach((pair) => this.addPair(pair));
  }

  addPair([a, b]) {
    this.addDirectedPath(a, b);
    this.addDirectedPath(b, a);
  }

  addDirectedPath(a, b) {
    if (this.nodes.has(a)) {
      this.nodes.get(a).push(b);
    } else {
      this.nodes.set(a, [b]);
    }
  }

  findAllPaths() {
    return this.findAllPathsRecursive(new Set(), "start", new Trail());
  }

  findAllPaths2() {
    return this.findAllPaths2Recursive(new Set(), "start", new Trail());
  }

  findAllPathsRecursive(fullPaths, nextKey, trail) {
    if (nextKey === "end") {
      fullPaths.add(trail.toString());
      return fullPaths;
    }
    if (isSmallCave(nextKey) && trail.has(nextKey)) {
      return fullPaths;
    } else {
      const fork = trail.fork(nextKey);
      this.nodes.get(nextKey).forEach((childKey) => {
        this.findAllPathsRecursive(fullPaths, childKey, fork);
      });
      return fullPaths;
    }
  }

  findAllPaths2Recursive(fullPaths, nextKey, trail) {
    if (nextKey === "end") {
      fullPaths.add(trail.toString());
      return fullPaths;
    }
    if (
      isSmallCave(nextKey) &&
      trail.has(nextKey) &&
      (!trail.canRevisitASmallCave() ||
        nextKey === "start" ||
        nextKey === "end")
    ) {
      return fullPaths;
    } else {
      const fork = trail.fork(nextKey);
      this.nodes.get(nextKey).forEach((childKey) => {
        this.findAllPaths2Recursive(fullPaths, childKey, fork);
      });
      return fullPaths;
    }
  }
}

const lowerCase = /^[a-z]+$/;

function isSmallCave(key) {
  return lowerCase.test(key);
}

class Trail {
  constructor() {
    this.path = [];
    this.visitCounts = new Map();
  }

  canRevisitASmallCave() {
    return (
      [...this.visitCounts.entries()].filter(
        ([k, v]) => isSmallCave(k) && v > 1
      ).length === 0
    );
  }

  fork(to) {
    const trail = new Trail();
    trail.path = [...this.path, to];
    trail.visitCounts = new Map(this.visitCounts);
    if (trail.visitCounts.has(to)) {
      trail.visitCounts.set(to, trail.visitCounts.get(to) + 1);
    } else {
      trail.visitCounts.set(to, 1);
    }
    return trail;
  }

  has(key) {
    return this.visitCounts.has(key) && this.visitCounts.get(key) > 0;
  }

  toString() {
    return this.path.join("->");
  }
}

module.exports = {
  Caves,
};
