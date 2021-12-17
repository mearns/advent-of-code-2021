const PQueue = require("./priority-queue");

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
    cost: 0,
    visited: false,
    tentativeDist: 0,
  });

  const sorted = grid
    .map((value, [i, j]) => [addressToKey([i, j]), value.tentativeDist])
    .sort((a, b) => b[1] - a[1]);

  const unvisited = new PQueue(sorted);
  let currentAddress = keyToAddress(unvisited.popCheapest());
  const startTime = new Date();
  const startSize = unvisited.size;
  while (true) {
    const currentValue = grid.get(currentAddress);
    const currentDist = currentValue.tentativeDist;
    grid.updateFourNeighbors(currentAddress, (value, addr) => {
      if (value.visited) {
        return value;
      }
      const newDist = Math.min(value.tentativeDist, currentDist + value.cost);
      unvisited.costDecreased(addressToKey(addr), newDist);
      return {
        ...value,
        tentativeDist: newDist,
      };
    });
    grid.set(currentAddress, {
      ...currentValue,
      visited: true,
    });
    if (currentAddress[0] === dx && currentAddress[1] === dy) {
      break;
    }
    currentAddress = keyToAddress(unvisited.popCheapest());
    const remaining = unvisited.size;
    if (remaining % 50 === 0) {
      const completeCount = startSize - remaining;
      const elapsedTime = (new Date() - startTime) / 1000 / 60;
      const rate = completeCount / elapsedTime;
      const eta = remaining / rate;
      console.log(
        `Down to ${
          unvisited.size
        } unvisited nodes. Smallest tentative dist is ${
          grid.get(currentAddress).tentativeDist
        }. Rate is ${Math.round(rate)} per minute, eta is ${Math.round(
          eta
        )} minutes, at ${new Date(new Date().getTime() + eta * 60 * 1000)}`
      );
    }
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
