async function getInput(inputStream, useSample) {
  if (useSample) {
    return [
      [
        [[[4, 3], 4], 4],
        [7, [[8, 4], 9]],
      ],
      [1, 1],
    ];
  } else {
    throw new Error("Not implemented");
  }
}

module.exports = {
  getInput,
};
