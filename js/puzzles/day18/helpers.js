const util = require("util");

const LEFT = Symbol("LEFT");
const RIGHT = Symbol("RIGHT");

function side(which) {
  if (which === LEFT) {
    return {
      get: (node) => node.left,
      set: (node, value) => {
        node.left = value;
      },
      switch: () => side(RIGHT),
      side: LEFT,
    };
  }
  if (which === RIGHT) {
    return {
      get: (node) => node.right,
      set: (node, value) => {
        node.right = value;
      },
      switch: () => side(LEFT),
      side: RIGHT,
    };
  }
}
class TreeNode {
  constructor(parent = null, side = null) {
    this.parent = parent;
    this.depth = parent === null ? 0 : parent.depth + 1;
    this.left = null;
    this.right = null;
    this.side = side;
  }

  magnitude() {
    const leftMag =
      typeof this.left === "number" ? this.left : this.left.magnitude();
    const rightMag =
      typeof this.right === "number" ? this.right : this.right.magnitude();
    return 3 * leftMag + 2 * rightMag;
  }

  attachAsLeft(parent) {
    return this._attachTo(side(LEFT), parent);
  }

  attachAsRight(parent) {
    return this._attachTo(side(RIGHT), parent);
  }

  _attachTo(picker, parent) {
    if (this.parent) {
      throw new Error("Cannot detach a node from an existing parent");
    }
    if (parent.parent) {
      throw new Error(
        "I thought we were only attaching to a root, but it already has a parent"
      );
    }
    this.parent = parent;
    this.side = picker.side;
    picker.set(this.parent, this);
    function increaseDepth(node, by) {
      node.depth += by;
      if (typeof node.left === "object") {
        increaseDepth(node.left, by);
      }
      if (typeof node.right === "object") {
        increaseDepth(node.right, by);
      }
    }
    increaseDepth(this, this.parent.depth + 1);
  }

  reduceCompletely() {
    if (this.parent !== null) {
      throw Object.assign(
        new Error(`You should only completely reduce from the root: ${this}.`),
        this
      );
    }
    while (true) {
      const changed = this.reduce();
      if (!changed) {
        return this;
      }
    }
  }

  reduce() {
    if (this.reduceExplode()) {
      return true;
    }
    return this.reduceSplit();
  }

  reduceExplode() {
    // Left most, first
    if (this.left && typeof this.left === "object") {
      if (this.left.reduceExplode()) {
        return true; // CHANGED
      }
    }

    // Stipulated: if depth is 4 or more, will only contain regular numbers, no more deeply nested.
    if (this.depth >= 4) {
      this.explode();
      return true;
    }

    // Lastly, right
    if (this.right && typeof this.right === "object") {
      if (this.right.reduceExplode()) {
        return true; // CHANGED
      }
    }

    return false;
  }

  reduceSplit() {
    if (typeof this.left === "number") {
      if (this.left >= 10) {
        this.split(LEFT);
        return true;
      }
    } else if (this.left) {
      if (this.left.reduceSplit()) {
        return true;
      }
    }

    if (typeof this.right === "number") {
      if (this.right >= 10) {
        this.split(RIGHT);
        return true;
      }
    } else if (this.right) {
      if (this.right.reduceSplit()) {
        return true;
      }
    }

    return false;
  }

  toJSON() {
    return [nodeToJSON(this.left), nodeToJSON(this.right)];
  }

  [util.inspect.custom](depth, opts) {
    return util.inspect(this.toJSON(), depth, opts);
  }

  flatten() {
    return [flatten(this.left), flatten(this.right)];
  }

  toString() {
    return `[${String(this.left)},${String(this.right)}]`;
  }

  addToLeftMostLeaf(value) {
    return this._addToSideMostLeaf(side(LEFT), value);
  }

  addToRightMostLeaf(value) {
    return this._addToSideMostLeaf(side(RIGHT), value);
  }

  _addToSideMostLeaf(picker, value) {
    const sideValue = picker.get(this);
    if (typeof sideValue === "number") {
      picker.set(this, sideValue + value);
      return;
    }
    return sideValue._addToSideMostLeaf(picker, value);
  }

  addToLeftAdjacent(value) {
    return this._addToAdjacent(side(LEFT), value);
  }
  addToRightAdjacent(value) {
    return this._addToAdjacent(side(RIGHT), value);
  }

  _addToAdjacent(picker, value) {
    if (this.side === null) {
      // bail out if you make it to the root, it means there's nothing adjacent to you on that side.
      return null;
    }
    // Keep going up while we're on the same side, that means we're on the outer-most
    // branch of a subtree.
    if (this.side === picker.side) {
      return this.parent._addToAdjacent(picker, value);
    }
    // Otherwise, we're on the other side of a pair. If the target side is a regular number,
    // then it's the adjacent we're looking for, so just add to it.
    if (typeof picker.get(this.parent) === "number") {
      picker.set(this.parent, picker.get(this.parent) + value);
      return;
    }

    // Otherwise, we've reached the root of the subtree where we weer walking up the outer most branch.
    // So now we need to bounce over to our sibling, and add to it's inner-most leaf on the opposite side.
    return picker.get(this.parent)._addToSideMostLeaf(picker.switch(), value);
  }

  split(side) {
    const [get, set] =
      side === LEFT
        ? [
            () => this.left,
            (x) => {
              this.left = x;
            },
          ]
        : [
            () => this.right,
            (x) => {
              this.right = x;
            },
          ];
    const value = get();
    const left = Math.floor(value / 2);
    const right = value - left;
    const node = new TreeNode(this, side);
    node.left = left;
    node.right = right;
    set(node);
  }

  explode() {
    if (typeof this.left !== "number" || typeof this.right !== "number") {
      throw new Error(
        `Cannot explode a node that contains other nodes: ${this}`
      );
    }
    this.addToLeftAdjacent(this.left);
    this.addToRightAdjacent(this.right);
    if (this.side === LEFT) {
      this.parent.left = 0;
    } else if (this.side === RIGHT) {
      this.parent.right = 0;
    }
  }
}

function nodeToJSON(node) {
  if (node === null || typeof node === "number") {
    return node;
  }
  return node.toJSON();
}

function flatten(node) {
  if (typeof node === "number") {
    return node;
  }
  return node.flatten();
}

function parse(val, parent = null, side = null) {
  if (typeof val === "number") {
    return val;
  }
  const [left, right] = val;
  const node = new TreeNode(parent, side);
  node.left = parse(left, node, LEFT);
  node.right = parse(right, node, RIGHT);
  return node;
}

function add(left, right) {
  if (left.parent !== null || right.parent !== null) {
    throw Object.assign(new Error("Can only add together two root nodes"), {
      left,
      right,
    });
  }
  const node = new TreeNode();
  left.attachAsLeft(node);
  right.attachAsRight(node);

  return node;
}

module.exports = { parse, flatten, add };
