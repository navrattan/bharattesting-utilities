/**
 * Verhoeff checksum algorithm implementation
 */
const verhoeff = {
  multiplicationTable: [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
    [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
    [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
    [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
    [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
    [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
    [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
    [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
    [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
  ],
  permutationTable: [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
    [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
    [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
    [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
    [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
    [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
    [7, 0, 4, 6, 9, 1, 3, 2, 5, 8]
  ],
  inverseTable: [0, 4, 3, 2, 1, 5, 6, 7, 8, 9],

  calculateCheckDigit: function(number) {
    let check = 0;
    const digits = number.split('').map(Number);
    for (let i = 0; i < digits.length; i++) {
      const digit = digits[digits.length - 1 - i];
      check = this.multiplicationTable[check][this.permutationTable[(i + 1) % 8][digit]];
    }
    return this.inverseTable[check];
  },

  validate: function(number) {
    let check = 0;
    const digits = number.split('').map(Number);
    for (let i = 0; i < digits.length; i++) {
      const digit = digits[digits.length - 1 - i];
      check = this.multiplicationTable[check][this.permutationTable[i % 8][digit]];
    }
    return check === 0;
  }
};

/**
 * Luhn Mod-36 checksum implementation
 */
const luhnMod36 = {
  chars: '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',

  calculateCheckDigit: function(input) {
    let sum = 0;
    for (let i = 0; i < input.length; i++) {
      const char = input[input.length - 1 - i].toUpperCase();
      const value = this.chars.indexOf(char);
      const weight = (i % 2 === 0) ? 2 : 1;
      const product = value * weight;
      sum += Math.floor(product / 36) + (product % 36);
    }
    const checkValue = (36 - (sum % 36)) % 36;
    return this.chars[checkValue];
  }
};

module.exports = { verhoeff, luhnMod36 };
