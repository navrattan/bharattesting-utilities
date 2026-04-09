module.exports = async (req, res) => {
  const { count = 1, format = 'json', provider } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  const providers = {
    'gpay': ['okaxis', 'okhdfcbank', 'okicici', 'oksbi'],
    'phonepe': ['ybl', 'ibl'],
    'paytm': ['paytm'],
    'amazon': ['apl'],
    'whatsapp': ['wa']
  };

  const allProviders = Object.values(providers).flat();
  const prefixes = ['kumar', 'sharma', 'singh', 'test', 'user', 'demo', 'india', 'bharat'];
  
  const generateUPI = () => {
    const prefix = prefixes[Math.floor(Math.random() * prefixes.length)];
    const randomNum = Math.floor(Math.random() * 9999);
    
    let handle;
    if (provider && providers[provider]) {
      handle = providers[provider][Math.floor(Math.random() * providers[provider].length)];
    } else {
      handle = allProviders[Math.floor(Math.random() * allProviders.length)];
    }
    
    return `${prefix}${randomNum}@${handle}`;
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateUPI());
  }

  if (format === 'csv') {
    res.setHeader('Content-Type', 'text/csv');
    return res.send('upi_id\n' + results.join('\n'));
  }

  if (format === 'xml') {
    res.setHeader('Content-Type', 'application/xml');
    return res.send(`<?xml version="1.0" encoding="UTF-8"?>\n<results>\n${results.map(r => `  <upi>${r}</upi>`).join('\n')}\n</results>`);
  }

  if (format === 'sql') {
    res.setHeader('Content-Type', 'text/plain');
    return res.send(`INSERT INTO upi_ids (upi_id) VALUES\n${results.map(r => `('${r}')`).join(',\n')};`);
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
