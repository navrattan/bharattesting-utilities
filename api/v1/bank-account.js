const formatResponse = require('./utils/formatter');

module.exports = async (req, res) => {
  const { count = 1, bank } = req.query;
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

  return formatResponse(req, res, results, 'bank_records');
};
