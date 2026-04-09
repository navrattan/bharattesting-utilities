module.exports = async (req, res) => {
  const { count = 1, bank = 'SBI' } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  const banks = {
    'SBI': { ifsc: 'SBIN', len: 11 },
    'HDFC': { ifsc: 'HDFC', len: 14 },
    'ICICI': { ifsc: 'ICIC', len: 12 },
    'AXIS': { ifsc: 'UTIB', len: 15 }
  };

  const b = banks[bank.toUpperCase()] || banks['SBI'];

  const generateBank = () => {
    const branch = Math.floor(Math.random() * 999999).toString().padStart(6, '0');
    const acc = Math.floor(Math.random() * Math.pow(10, b.len)).toString().padStart(b.len, '0');
    return {
      bank: bank.toUpperCase(),
      ifsc: `${b.ifsc}0${branch}`,
      account_number: acc,
      micr: Math.floor(Math.random() * 999999999).toString().padStart(9, '0')
    };
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateBank());
  }

  res.status(200).json({ data: results });
};
