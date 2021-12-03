const enter = require("./lib/enter");
const { ensureInputExists } = require("./lib/get-input-file");

async function main() {
  const [, , day] = process.argv;
  console.log(await ensureInputExists(day));
}

enter(main);
