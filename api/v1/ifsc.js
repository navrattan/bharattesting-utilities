module.exports = async (req, res) => {
  const { count = 1, format = 'json', bank } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  const banks = {
    'SBI': 'SBIN',
    'HDFC': 'HDFC',
    'ICICI': 'ICIC',
    'Axis': 'UTIB',
    'PNB': 'PUNB',
    'BOB': 'BARB',
    'Canara': 'CNRB',
    'Yes': 'YESB'
  };

  const allBankCodes = Object.values(banks);
  
  const generateIFSC = () => {
    let code;
    if (bank && banks[bank]) {
      code = banks[bank];
    } else {
      code = allBankCodes[Math.floor(Math.random() * allBankCodes.length)];
    }
    
    // IFSC format: 4 chars (bank) + 0 (fixed) + 6 chars (branch)
    let branch = '';
    for (let i = 0; i < 6; i++) {
      // Branch can be alphanumeric
      const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      branch += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    
    return `${code}0${branch}`;
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateIFSC());
  }

  if (format === 'csv') {
    res.setHeader('Content-Type', 'text/csv');
    return res.send('ifsc_code\n' + results.join('\n'));
  }

  if (format === 'xml') {
    res.setHeader('Content-Type', 'application/xml');
    return res.send(`<?xml version="1.0" encoding="UTF-8"?>\n<results>\n${results.map(r => `  <ifsc>${r}</ifsc>`).join('\n')}\n</results>`);
  }

  if (format === 'sql') {
    res.setHeader('Content-Type', 'text/plain');
    return res.send(`INSERT INTO ifsc_codes (ifsc) VALUES\n${results.map(r => `('${r}')`).join(',\n')};`);
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
