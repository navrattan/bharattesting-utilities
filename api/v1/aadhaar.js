const { verhoeff } = require('./utils/checksums');

module.exports = async (req, res) => {
  const { count = 1, format = 'json', seed } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  const generateAadhaar = () => {
    // Aadhaar starts with 2-9
    let number = (Math.floor(Math.random() * 8) + 2).toString();
    for (let i = 0; i < 10; i++) {
      number += Math.floor(Math.random() * 10).toString();
    }
    const checkDigit = verhoeff.calculateCheckDigit(number);
    return number + checkDigit;
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateAadhaar());
  }

  if (format === 'csv') {
    res.setHeader('Content-Type', 'text/csv');
    return res.send('aadhaar\n' + results.join('\n'));
  }

  if (format === 'xml') {
    res.setHeader('Content-Type', 'application/xml');
    return res.send(`<?xml version="1.0" encoding="UTF-8"?>\n<results>\n${results.map(r => `  <aadhaar>${r}</aadhaar>`).join('\n')}\n</results>`);
  }

  res.status(200).json({
    data: results,
    meta: {
      count: numCount,
      format: 'json',
      generated_at: new Date().toISOString()
    }
  });
};
