const enter = require("./lib/enter");
const { getInputStream, closeInputStream } = require("./lib/get-input-file");

async function main() {
  const [, , day, part, ...args] = process.argv;
  let inputStream = null;
  try {
    inputStream = await getInputStream(day);
    const puzzle = (await import(`./puzzles/day${day}/part${part}.js`)).default;
    console.log(await puzzle(inputStream, ...args));
  } finally {
    await closeInputStream(inputStream);
  }
}

enter(main);
