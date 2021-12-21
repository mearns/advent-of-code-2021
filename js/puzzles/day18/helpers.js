const util = require("util");

const LEFT = Symbol("LEFT");
const RIGHT = Symbol("RIGHT");

class TreeNode {
  constructor(parent = null, side = null) {
    this.parent = parent;
    this.depth = parent === null ? 0 : parent.depth + 1;
    this.left = null;
    this.right = null;
    this.side = side;
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

  addToLeftCousin(value) {
    if (this.side === null) {
      // root
      return null;
    }
    if (this.side === LEFT) {
      return this.parent.addToLeftCousin(value);
    }
    if (this.parent.left === null) {
      return;
    } else if (typeof this.parent.left === "number") {
      return (this.parent.left += value);
    }
    return this.parent.left.addToLeftCousin(value);
  }

  addToRightCousin(value) {
    if (this.side === null) {
      // root
      return null;
    }
    if (this.side === RIGHT) {
      return this.parent.addToRightCousin(value);
    }
    if (this.parent.right === null) {
      return;
    } else if (typeof this.parent.right === "number") {
      return (this.parent.right += value);
    }
    return this.parent.right.addToRightCousin(value);
  }

  explode() {
    if (typeof this.left !== "number" || typeof this.right !== "number") {
      throw new Error(
        `Cannot explode a node that contains other nodes: ${this}`
      );
    }
    this.addToLeftCousin(this.left);
    this.addToRightCousin(this.right);
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

module.exports = { parse, flatten };
