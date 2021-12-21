const { fromBinary } = require("./binary");

class BitBuffer {
  constructor(bits) {
    this._bits = bits;
    this._offset = 0;
  }

  sliceOff(count) {
    const sub = this.consume(count);
    return new BitBuffer(sub);
  }

  consume(count) {
    const ret = this._bits.slice(0, count);
    if (ret.length < count) {
      throw Object.assign(
        new Error(
          `Ran out of bits at offset ${this._offset} Tried to consume ${count}, only found ${ret.length}`
        ),
        {
          bits: this._bits,
        }
      );
    }
    this._offset += count;
    this._bits.splice(0, count);
    return ret;
  }

  consumeValue(count) {
    return fromBinary(this.consume(count));
  }

  length() {
    return this._bits.length;
  }

  isEmpty() {
    return this._bits.length === 0;
  }
}

module.exports = BitBuffer;
