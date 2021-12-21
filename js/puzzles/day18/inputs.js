async function getInput(inputStream, useSample) {
  if (useSample) {
    return [[[6, [5, [4, [3, 2]]]], 1]];
  } else {
    throw new Error("Not implemented");
  }
}

module.exports = {
  getInput,
};
