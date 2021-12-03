module.exports = async function enter(func) {
  try {
    await func();
  } catch (exception) {
    console.error(exception);
    process.exitCode = 1;
  }
};
