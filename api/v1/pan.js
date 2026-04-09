module.exports = async (req, res) => {
  const { count = 1, format = 'json', type = 'P' } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  const generatePAN = (entityType) => {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const nums = '0123456789';
    
    // 1-3: Random alpha
    let pan = '';
    for (let i = 0; i < 3; i++) pan += chars[Math.floor(Math.random() * 26)];
    
    // 4: Entity type
    pan += entityType.toUpperCase();
    
    // 5: Random alpha (Last name initial)
    pan += chars[Math.floor(Math.random() * 26)];
    
    // 6-9: 4 digits
    for (let i = 0; i < 4; i++) pan += nums[Math.floor(Math.random() * 10)];
    
    // 10: Check digit (alpha)
    pan += chars[Math.floor(Math.random() * 26)];
    
    return pan;
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generatePAN(type));
  }

  if (format === 'csv') {
    res.setHeader('Content-Type', 'text/csv');
    return res.send('pan\n' + results.join('\n'));
  }

  res.status(200).json({
    data: results,
    meta: { count: numCount, format: 'json', generated_at: new Date().toISOString() }
  });
};
