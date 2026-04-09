module.exports = async (req, res) => {
  const { count = 1, format = 'json', type = 'new' } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  const generatePassport = () => {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const firstLetter = letters.charAt(Math.floor(Math.random() * letters.length));
    
    let passport;
    if (type === 'old') {
      // Old format: 1 Letter + 7 Digits
      let digits = '';
      for (let i = 0; i < 7; i++) {
        digits += Math.floor(Math.random() * 10).toString();
      }
      passport = firstLetter + digits;
    } else {
      // New format: 1 Letter + 1 Digit + 6 Digits
      let digits = '';
      for (let i = 0; i < 7; i++) {
        digits += Math.floor(Math.random() * 10).toString();
      }
      passport = firstLetter + digits; // Actually both follow a similar pattern, but new ones are strictly structured
    }
    
    return {
      number: passport,
      type: type === 'old' ? 'Old Format' : 'New Format'
    };
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generatePassport());
  }

  if (req.query.format === "csv") {
    res.setHeader('Content-Type', 'text/csv');
    return res.send('passport_number,type\n' + results.map(r => `${r.number},${r.type}`).join('\n'));
  }

  if (format === 'sql') {
    res.setHeader('Content-Type', 'text/plain');
    return res.send(`INSERT INTO passports (number, type) VALUES\n${results.map(r => `('${r.number}', '${r.type}')`).join(',\n')};`);
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
