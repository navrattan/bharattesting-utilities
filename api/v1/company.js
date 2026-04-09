module.exports = async (req, res) => {
  const { count = 1, format = 'json' } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  const companyPrefixes = ['Bharat', 'Indian', 'Apex', 'Global', 'Future', 'Secure', 'Smart', 'Delta'];
  const companySuffixes = ['Technologies', 'Solutions', 'Services', 'Industries', 'Systems', 'Ventures'];
  const states = ['KA', 'MH', 'DL', 'TN', 'TS', 'WB', 'UP', 'GJ'];
  
  const generateCompany = () => {
    const name = `${companyPrefixes[Math.floor(Math.random() * companyPrefixes.length)]} ${companySuffixes[Math.floor(Math.random() * companySuffixes.length)]} Pvt Ltd`;
    const state = states[Math.floor(Math.random() * states.length)];
    const year = Math.floor(Math.random() * 25) + 2000;
    
    // CIN: U + 5 digits + state(2) + year(4) + PTC + 6 digits
    const cin = `U${Math.floor(Math.random() * 90000) + 10000}${state}${year}PTC${Math.floor(Math.random() * 900000) + 100000}`;
    
    // PAN (Company): 3 random + C + 1 random + 4 digits + 1 check
    const panPrefix = 'ABCDE'[Math.floor(Math.random() * 5)] + 'FGHIJ'[Math.floor(Math.random() * 5)] + 'KLMNO'[Math.floor(Math.random() * 5)];
    const pan = `${panPrefix}C${String.fromCharCode(65 + Math.floor(Math.random() * 26))}${Math.floor(Math.random() * 9000) + 1000}${String.fromCharCode(65 + Math.floor(Math.random() * 26))}`;

    return {
      name,
      cin,
      pan,
      gstin: `27${pan}1Z5`, // Simplified GSTIN
      state
    };
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateCompany());
  }

  if (req.query.format === "csv") {
    res.setHeader('Content-Type', 'text/csv');
    const header = 'name,cin,pan,gstin,state\n';
    const rows = results.map(r => `"${r.name}","${r.cin}","${r.pan}","${r.gstin}","${r.state}"`).join('\n');
    return res.send(header + rows);
  }

  if (format === 'sql') {
    res.setHeader('Content-Type', 'text/plain');
    return res.send(`INSERT INTO companies (name, cin, pan, gstin, state) VALUES\n${results.map(r => `('${r.name}', '${r.cin}', '${r.pan}', '${r.gstin}', '${r.state}')`).join(',\n')};`);
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
