function fromBinary(bits) {
  return bits.reduce((value, b) => (value << 1) + b, 0);
}

module.exports = {
  fromBinary,
};
