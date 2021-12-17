function findCostOfShortestPath(grid) {
  const dx = grid.width() - 1;
  const dy = grid.height() - 1;
  grid.updateAll((value) => ({
    cost: value,
    visited: false,
    tentativeDist: Infinity,
  }));
  const initial = [0, 0];
  grid.set(initial, {
    visited: false,
    tentativeDist: 0,
  });

  const unvisited = new Set();
  for (let i = 0; i <= dx; i++) {
    for (let j = 0; j <= dy; j++) {
      unvisited.add(addressToKey([i, j]));
    }
  }
  let currentAddress = initial;
  const startTime = new Date();
  const startSize = unvisited.size;
  while (true) {
    const currentValue = grid.get(currentAddress);
    const currentDist = currentValue.tentativeDist;
    grid.updateFourNeighbors(currentAddress, (value) => {
      return {
        ...value,
        tentativeDist: Math.min(value.tentativeDist, currentDist + value.cost),
      };
    });
    grid.set(currentAddress, {
      ...currentValue,
      visited: true,
    });
    unvisited.delete(addressToKey(currentAddress));
    if (currentAddress[0] === dx && currentAddress[1] === dy) {
      break;
    }
    let smallestTenativeDistance = Infinity;
    let smallestAt = null;
    for (const key of unvisited.values()) {
      const addr = keyToAddress(key);
      const node = grid.get(addr);
      if (node.tentativeDist < smallestTenativeDistance) {
        smallestTenativeDistance = node.tentativeDist;
        smallestAt = addr;
      }
    }
    const remaining = unvisited.size;
    if (remaining % 20 === 0) {
      const completeCount = startSize - remaining;
      const elapsedTime = (new Date() - startTime) / 1000 / 60;
      const rate = completeCount / elapsedTime;
      const eta = remaining / rate;
      console.log(
        `Down to ${
          unvisited.size
        } unvisited nodes. Smallest tentative dist is ${smallestTenativeDistance}. Rate is ${Math.round(
          rate
        )} per minute, eta is ${Math.round(eta)} minutes, at ${new Date(
          new Date().getTime() + eta * 60 * 1000
        )}`
      );
    }
    if (smallestAt === null) {
      throw new Error(
        `Couldn't find next node, all are Infinity, or there are none: (there are ${unvisited.size})`
      );
    }
    currentAddress = smallestAt;
  }
  console.log(
    `Terminated at (${currentAddress[0]}, ${currentAddress[1]})`,
    grid.get(currentAddress)
  );
}

function keyToAddress(key) {
  return key.split(",").map((c) => parseInt(c, 10));
}

function addressToKey([i, j]) {
  return `${i},${j}`;
}

module.exports = {
  findCostOfShortestPath,
};
