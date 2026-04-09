module.exports = async (req, res) => {
  const { count = 1, format = 'json', operator } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  // Real Indian Mobile Number Prefixes
  const prefixes = {
    'Jio': ['600','700','800','901','911','921','931','941','951','961','971','981','991','701','702'],
    'Airtel': ['706','707','708','709','801','802','803','804','902','903','904','912','913','914','922','923','924'],
    'Vi': ['620','621','622','623','720','721','722','723','820','821','822','823','932','933','934'],
    'BSNL': ['940','941','942','943','944','945','946','947','948','949']
  };

  const allPrefixes = Object.values(prefixes).flat();
  
  const generatePhone = () => {
    let prefix;
    if (operator && prefixes[operator]) {
      prefix = prefixes[operator][Math.floor(Math.random() * prefixes[operator].length)];
    } else {
      prefix = allPrefixes[Math.floor(Math.random() * allPrefixes.length)];
    }
    
    let suffix = '';
    for (let i = 0; i < 7; i++) {
      suffix += Math.floor(Math.random() * 10).toString();
    }
    return `+91-${prefix}-${suffix}`;
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generatePhone());
  }

  if (format === 'csv') {
    res.setHeader('Content-Type', 'text/csv');
    return res.send('phone\n' + results.join('\n'));
  }

  if (format === 'xml') {
    res.setHeader('Content-Type', 'application/xml');
    return res.send(`<?xml version="1.0" encoding="UTF-8"?>\n<results>\n${results.map(r => `  <phone>${r}</phone>`).join('\n')}\n</results>`);
  }

  if (format === 'sql') {
    res.setHeader('Content-Type', 'text/plain');
    return res.send(`INSERT INTO phone_numbers (phone) VALUES\n${results.map(r => `('${r}')`).join(',\n')};`);
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
