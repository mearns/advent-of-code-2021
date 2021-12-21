const path = require("path");
const enter = require("./lib/enter");
const { getInputStream, closeInputStream } = require("./lib/get-input-file");

async function main() {
  const [, , day, part, ...args] = process.argv;
  let inputStream = null;
  const puzzle = await getPuzzle(day, part);
  try {
    inputStream = await getInputStream(day);
    const sample = args.includes("--sample");
    console.log(
      await puzzle(
        inputStream,
        sample,
        ...args.filter((str) => str !== "--sample")
      )
    );
  } finally {
    await closeInputStream(inputStream);
  }
}

async function getPuzzle(day, part) {
  const importPath = `./puzzles/day${day}/part${part}.js`;
  try {
    return (await import(`./puzzles/day${day}/part${part}.js`)).default;
  } catch (error) {
    if (
      error.code === "ERR_MODULE_NOT_FOUND" &&
      error.message.includes(
        `Cannot find module '${path.resolve(__dirname, importPath)}'`
      )
    ) {
      throw Object.assign(
        new Error(
          `It looks like a solution for this puzzle hasn't been implemented in JavaScript: No file found at ${importPath}`
        ),
        { quiet: true }
      );
    }
    throw error;
  }
}

enter(main);
