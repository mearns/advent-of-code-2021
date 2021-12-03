module.exports = async function enter(func) {
  try {
    await func();
  } catch (exception) {
    if (exception.quiet === true) {
      console.error(exception.message);
    } else {
      console.error(exception);
    }
    process.exitCode = 1;
  }
};
