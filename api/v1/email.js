module.exports = async (req, res) => {
  const { count = 1, format = 'json', domain_type = 'personal' } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  const firstNames = ['Arjun', 'Priya', 'Rahul', 'Ananya', 'Amit', 'Neha', 'Sanjay', 'Kiran'];
  const lastNames = ['Sharma', 'Verma', 'Singh', 'Patel', 'Das', 'Iyer', 'Reddy', 'Nair'];
  
  const domains = {
    'personal': ['gmail.com', 'yahoo.co.in', 'outlook.com', 'rediffmail.com'],
    'company': ['bharattesting.com', 'tcs.com', 'infosys.com', 'wipro.com', 'hcl.com'],
    'gov': ['nic.in', 'gov.in', 'digitalindia.gov.in']
  };

  const generateEmail = () => {
    const fn = firstNames[Math.floor(Math.random() * firstNames.length)].toLowerCase();
    const ln = lastNames[Math.floor(Math.random() * lastNames.length)].toLowerCase();
    const domainList = domains[domain_type] || domains.personal;
    const domain = domainList[Math.floor(Math.random() * domainList.length)];
    
    const patterns = [
      `${fn}.${ln}`,
      `${fn}${Math.floor(Math.random() * 100)}`,
      `${fn}_${ln}`,
      `${ln}${fn.charAt(0)}`
    ];
    
    return `${patterns[Math.floor(Math.random() * patterns.length)]}@${domain}`;
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateEmail());
  }

  if (req.query.format === "csv") {
    res.setHeader('Content-Type', 'text/csv');
    return res.send('email\n' + results.join('\n'));
  }

  if (format === 'sql') {
    res.setHeader('Content-Type', 'text/plain');
    return res.send(`INSERT INTO emails (email) VALUES\n${results.map(r => `('${r}')`).join(',\n')};`);
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
