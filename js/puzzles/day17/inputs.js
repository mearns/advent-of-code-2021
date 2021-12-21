const example_bounds = {
  x: [20, 30],
  y: [-10, -5],
};
const bounds = {
  x: [79, 137],
  y: [-176, -117],
};

async function getInput(inputStream, useSample) {
  if (useSample) {
    return example_bounds;
  } else {
    return bounds;
  }
}

module.exports = {
  getInput,
};
