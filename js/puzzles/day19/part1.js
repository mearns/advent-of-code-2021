const getInput = require("./input");
const parseInput = require("./parser");

module.exports = async function main(inputStream, sample) {
  const report = parseInput(await getInput(inputStream, sample));
  const scannerReports = Object.values(report.scanners);
  const mapOfScannersByTriangles = findTrianglesInCommon(scannerReports);

  const scannerPairsThatShareAShape = new Set();
  const mapOfSharedShapesByScannerPair = new Map();
  for (const [k, v] of mapOfScannersByTriangles.entries()) {
    if (v.length > 1) {
      const beacons = v.map((e) => e.beaconIdx);
      beacons.sort((a, b) => a - b);
      for (let i = 0; i < beacons.length; i++) {
        for (let j = i + 1; j < beacons.length; j++) {
          const key = `${i},${j}`;
          scannerPairsThatShareAShape.add(key);
          if (!mapOfSharedShapesByScannerPair.has(key)) {
            mapOfSharedShapesByScannerPair.set(key, []);
          }
          mapOfSharedShapesByScannerPair.get(key).push(k);
        }
      }
    }
  }

  for (const key of scannerPairsThatShareAShape.values()) {
    const [scanner1, scanner2] = key
      .split(",")
      .map((s) => parseInt(s))
      .map((id) => scannerReports[id]);

    for (let i = 0; i < scanner1.length; i++) {
      const pt1 = scanner1[i];
      for (let j = 0; j < scanner2.length; j++) {}
    }
  }
};

function* getAllRotations() {
  for (let i = 0; i < 3; i++) {
    for (let j = 0; j < 3; j++) {
      if (i !== j) {
        for (let k = 0; k < 3; k++) {
          if (k !== i && k !== j) {
            const rotate = (coords) => [coords[i], coords[j], coords[k]];
            // FIXME: FUCK THE FUCK GODDAM FUCK
          }
        }
      }
    }
  }
}

function findTrianglesInCommon(beaconReports) {
  const mapOfBeaconsByTriangles = new Map();
  beaconReports.forEach((scannerCoords, beaconIdx) => {
    const scannerCount = scannerCoords.length;
    for (let i = 0; i < scannerCount; i++) {
      for (let j = 0; j < scannerCount; j++) {
        if (j !== i) {
          for (let k = 0; k < scannerCount; k++) {
            if (k !== i && k !== j) {
              const coordSet = [i, j, k].map((idx) => scannerCoords[idx]);
              const [d1, d2, d3] = getTriangle(coordSet);
              if (d1 >= d2 && d2 >= d3) {
                const tri = [d1, d2, d3].map((d) => String(d)).join(",");
                if (!mapOfBeaconsByTriangles.has(tri)) {
                  mapOfBeaconsByTriangles.set(tri, []);
                }
                mapOfBeaconsByTriangles
                  .get(tri)
                  .push({ beaconIdx, idx: [i, j, k] });
              }
            }
          }
        }
      }
    }
  });
  return mapOfBeaconsByTriangles;
}

function getTriangle([pt1, pt2, pt3]) {
  return [
    [pt1, pt2],
    [pt2, pt3],
    [pt3, pt1],
  ]
    .map(([a, b]) => getDistance(a, b))
    .map((d) => Math.round(d * 1000) / 1000);
}

function getDistance(pt1, pt2) {
  const d = Math.sqrt(
    [0, 1, 2]
      .map((idx) => pt1[idx] - pt2[idx])
      .map((delta) => delta * delta)
      .reduce((sum, d) => sum + d, 0)
  );
  return d;
}
