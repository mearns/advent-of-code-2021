class PQueue {
  constructor(highToLow = []) {
    this.pCheapest = null;
    this.nodeMap = new Map();
    this.size = 0;

    for (const [key, cost] of highToLow) {
      const node = {
        next: this.pCheapest,
        prev: null,
        cost,
        key,
      };
      this.size++;
      this.nodeMap.set(key, node);
      if (this.pCheapest) {
        this.pCheapest.prev = node;
      }
      this.pCheapest = node;
    }
  }

  inspect() {
    return [this.pCheapest, this.pCheapest.next, this.pCheapest.next.next];
  }

  popCheapest() {
    const cheapest = this.pCheapest;
    this.nodeMap.delete(cheapest.key);
    this.pCheapest = cheapest.next;
    if (this.pCheapest) {
      this.pCheapest.prev = null;
    }
    this.size--;
    return cheapest.key;
  }

  costDecreased(key, newCost) {
    if (key === this.pCheapest.key) {
      this.pCheapest.cost = newCost;
      return;
    }

    const node = this.nodeMap.get(key);
    if (node.cost === newCost) {
      return;
    }
    node.cost = newCost;
    const next = node.next;
    const prev = node.prev;
    // Pop the node out right now
    if (next) {
      next.prev = prev;
    }
    prev.next = next;

    // Now go backward till we find a node that's lower than the new cost, that can be the previous.
    let curr = node.prev;
    while (curr.prev !== null) {
      if (curr.cost <= newCost) {
        const cnext = curr.next;
        const cprev = curr.prev;
        curr.next = node;
        node.next = cnext;
        if (cnext) {
          cnext.prev = node;
        }
        node.prev = curr;
        return;
      }
      curr = curr.prev;
    }

    // The first node is more costly than the new node.
    this.pCheapest.prev = node;
    node.next = this.pCheapest;
    this.pCheapest = node;
  }

  add(key, cost) {
    const node = {
      next: null,
      prev: null,
      cost,
      key,
    };
    this.size++;
    this.nodeMap.set(key, node);
    if (this.pCheapest === null) {
      this.pCheapest = node;
    } else if (cost <= this.pCheapest.cost) {
      node.next = this.pCheapest;
      this.pCheapest.prev = node;
      this.pCheapest = node;
    } else {
      let curr = this.pCheapest;
      while (curr.next !== null) {
        if (cost <= curr.cost) {
          node.prev = curr.prev;
          node.next = curr;
          curr.prev.next = node;
          curr.prev = node;
          break;
        }
        curr = curr.next;
      }
      curr.next = node;
      node.prev = curr;
    }
  }
}

module.exports = PQueue;
