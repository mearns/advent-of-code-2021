module.exports = { getSuccessfulInitialVelocties };

function getSuccessfulInitialVelocties(bounds) {
  const [minvx, maxvx] = findInitialXVelocityRange(bounds.x[0], bounds.x[1]);
  const [minvy, maxvy] = findInitialYVelocityRange(bounds.y[0], bounds.y[1]);
  const hits = [];
  for (let x = minvx; x <= maxvx; x++) {
    for (let y = minvy; y <= maxvy; y++) {
      let i = 0,
        j = 0;
      let vx = x,
        vy = y;
      const yvalues = [j];
      const positions = [];
      for (let t = 0; i <= bounds.x[1] && j >= bounds.y[0]; t++) {
        i += vx;
        j += vy;
        yvalues.push(j);
        positions.push([i, j]);
        if (
          i >= bounds.x[0] &&
          i <= bounds.x[1] &&
          j >= bounds.y[0] &&
          j <= bounds.y[1]
        ) {
          hits.push({ x, y, i, j, vx, vy, t, yvalues });
          break;
        }
        vx = Math.max(0, vx - 1);
        vy = vy - 1;
      }
      if (x == 6 && y == 0) {
        console.log(positions);
      }
    }
  }
  return hits;
}

function findInitialYVelocityRange(miny, maxy) {
  if (miny > 0) {
    throw new Error(`Expected miny to be no more than 0: ${miny}`);
  }
  if (miny >= maxy) {
    throw new Error(
      `Expected maxy to be greater than miny but ${maxy} < ${miny}`
    );
  }
  return [miny - 1, -miny + 1];
}

function findInitialXVelocityRange(minx, maxx) {
  if (minx < 0) {
    throw new Error(`Expected minx to be non-negative: ${minx}`);
  }
  if (minx >= maxx) {
    throw new Error(
      `Expected maxx to be greater than minx but ${maxx} < ${minx}`
    );
  }
  const [minv, maxv] = [
    ...quadraticEquation(1, 1, -2 * minx),
    ...quadraticEquation(1, 1, -2 * maxx),
  ].filter((v) => v >= 0);

  if (minv > maxv) {
    throw new Error(
      `Expected minv to be no greater than maxv but ${minv} > ${maxv}`
    );
  }

  return [Math.floor(minv), maxx];
}

function xDistTraveled(initialXVelocity) {
  let total = 0;
  let velocity = initialXVelocity;
  while (velocity > 0) {
    total += velocity;
    velocity -= 1;
  }
  return total;
}

function quadraticEquation(a, b, c) {
  const determ = b * b - 4 * a * c;
  if (determ < 0) {
    return [];
  } else if (determ === 0) {
    return -b / 2 / a;
  }
  return [(-b + Math.sqrt(determ)) / 2 / a, (-b - Math.sqrt(determ)) / 2 / a];
}
