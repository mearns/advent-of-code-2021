const fs = require("fs");
const path = require("path");
const http = require("https");
const session = require("./_session");

async function closeInputStream(inputStream) {
  if (inputStream) {
    return new Promise((resolve) => {
      inputStream.close(() => resolve());
    });
  }
  return Promise.resolve();
}

async function ensureInputExists(day) {
  const inputPath = path.resolve(
    __dirname,
    "..",
    "..",
    "data",
    `input-${day}.txt`
  );
  if (!(await fileExists(inputPath))) {
    await downloadInputFile(inputPath, day);
  }
  return inputPath;
}

async function getInputStream(day) {
  const inputPath = await ensureInputExists(day);
  return fs.createReadStream(inputPath, "utf8");
}

async function fileExists(filePath) {
  try {
    await fs.promises.stat(filePath);
    return true;
  } catch (error) {
    if (error.code === "ENOENT") {
      return false;
    }
    throw error;
  }
}

async function downloadInputFile(filePath, day) {
  const url = `https://adventofcode.com/2021/day/${day}/input`;
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(filePath);
    http
      .get(url, { headers: { Cookie: `session=${session}` } }, (response) => {
        response.pipe(file);
        file.on("finish", () => {
          file.close(() => resolve());
        });
      })
      .on("error", (err) => {
        fs.unlink(filePath);
        reject(err);
      });
  });
}

module.exports = {
  closeInputStream,
  ensureInputExists,
  getInputStream,
};
