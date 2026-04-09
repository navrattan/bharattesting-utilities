const { verhoeff } = require('./utils/checksums');
const formatResponse = require('./utils/formatter');

module.exports = async (req, res) => {
  const { count = 1 } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  const generateAadhaar = () => {
    let number = (Math.floor(Math.random() * 8) + 2).toString();
    for (let i = 0; i < 10; i++) {
      number += Math.floor(Math.random() * 10).toString();
    }
    const checkDigit = verhoeff.calculateCheckDigit(number);
    return {
      number: number + checkDigit,
      formatted: (number + checkDigit).match(/.{1,4}/g).join(' ')
    };
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateAadhaar());
  }

  return formatResponse(req, res, results, 'aadhaar_records');
};
