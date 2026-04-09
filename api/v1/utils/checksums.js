/**
 * Verhoeff Algorithm for Aadhaar
 */
const d = [
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [1, 2, 3, 4, 0, 6, 7, 8, 9, 5], [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
  [3, 4, 0, 1, 2, 8, 9, 5, 6, 7], [4, 0, 1, 2, 3, 9, 5, 6, 7, 8], [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
  [6, 5, 9, 8, 7, 1, 0, 4, 3, 2], [7, 6, 5, 9, 8, 2, 1, 0, 4, 3], [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
  [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
];
const p = [
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [1, 5, 7, 6, 2, 8, 3, 0, 9, 4], [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
  [8, 9, 1, 6, 0, 4, 3, 5, 2, 7], [9, 4, 5, 3, 1, 2, 6, 8, 7, 0], [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
  [2, 7, 9, 3, 8, 0, 6, 4, 1, 5], [7, 0, 4, 6, 9, 1, 3, 2, 5, 8]
];
const inv = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9];

module.exports.verhoeff = {
  calculateCheckDigit: (array) => {
    let c = 0;
    const invertedArray = array.toString().split('').map(Number).reverse();
    for (let i = 0; i < invertedArray.length; i++) {
      c = d[c][p[(i + 1) % 8][invertedArray[i]]];
    }
    return inv[c];
  }
};

/**
 * Luhn Algorithm for Credit Cards
 */
module.exports.luhn = {
  calculateCheckDigit: (number) => {
    let sum = 0;
    const digits = number.toString().split('').map(Number).reverse();
    for (let i = 0; i < digits.length; i++) {
      let digit = digits[i];
      if (i % 2 === 0) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
    }
    return (10 - (sum % 10)) % 10;
  }
};

/**
 * Seeded Random Utility
 */
module.exports.createRandom = (seed) => {
  let s = seed ? parseInt(seed) : Math.floor(Math.random() * 1000000);
  return () => {
    s = (s * 9301 + 49297) % 233280;
    return s / 233280;
  };
};
