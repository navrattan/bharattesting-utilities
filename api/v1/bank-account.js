module.exports = async (req, res) => {
  const { count = 1, format = 'json', bank } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  const bankRules = {
    'SBI': { length: 11, prefix: '3' },
    'HDFC': { length: 14, prefix: '5' },
    'ICICI': { length: 12, prefix: '0' },
    'Axis': { length: 15, prefix: '9' },
    'PNB': { length: 16, prefix: '0' }
  };

  const bankNames = Object.keys(bankRules);
  
  const generateAccount = () => {
    let selectedBank;
    if (bank && bankRules[bank]) {
      selectedBank = bank;
    } else {
      selectedBank = bankNames[Math.floor(Math.random() * bankNames.length)];
    }

    const rules = bankRules[selectedBank];
    let account = rules.prefix;
    for (let i = 0; i < rules.length - rules.prefix.length; i++) {
      account += Math.floor(Math.random() * 10).toString();
    }
    
    return {
      bank: selectedBank,
      account_number: account,
      type: Math.random() > 0.5 ? 'Savings' : 'Current'
    };
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateAccount());
  }

  if (format === 'csv') {
    res.setHeader('Content-Type', 'text/csv');
    const header = 'bank,account_number,type\n';
    const rows = results.map(r => `"${r.bank}","${r.account_number}","${r.type}"`).join('\n');
    return res.send(header + rows);
  }

  if (format === 'sql') {
    res.setHeader('Content-Type', 'text/plain');
    return res.send(`INSERT INTO bank_accounts (bank, account_number, type) VALUES\n${results.map(r => `('${r.bank}', '${r.account_number}', '${r.type}')`).join(',\n')};`);
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
