const { luhnMod36 } = require('./utils/checksums');

module.exports = async (req, res) => {
  const { count = 1, format = 'json', stateCode = '27' } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  const generateGSTIN = (sc) => {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const nums = '0123456789';
    const alphanum = chars + nums;
    
    // 1-2: State code
    let gstin = sc.toString().padStart(2, '0');
    
    // 3-12: PAN (simplified random)
    for (let i = 0; i < 5; i++) gstin += chars[Math.floor(Math.random() * 26)];
    for (let i = 0; i < 4; i++) gstin += nums[Math.floor(Math.random() * 10)];
    gstin += chars[Math.floor(Math.random() * 26)];
    
    // 13: Entity code (usually 1)
    gstin += (Math.floor(Math.random() * 9) + 1).toString();
    
    // 14: Default char 'Z'
    gstin += 'Z';
    
    // 15: Check digit
    const checkDigit = luhnMod36.calculateCheckDigit(gstin);
    return gstin + checkDigit;
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateGSTIN(stateCode));
  }

  if (format === 'csv') {
    res.setHeader('Content-Type', 'text/csv');
    return res.send('gstin\n' + results.join('\n'));
  }

  res.status(200).json({
    data: results,
    meta: { count: numCount, format: 'json', generated_at: new Date().toISOString() }
  });
};
