const { luhn, createRandom } = require('./utils/checksums');
const formatResponse = require('./utils/formatter');

module.exports = async (req, res) => {
  const { count = 1, type = 'RuPay', seed } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  const random = createRandom(seed);
  
  const bins = {
    'RuPay': ['60', '65', '81', '82'],
    'Visa': ['41', '42', '45'],
    'MasterCard': ['51', '52', '55']
  };

  const selectedType = bins[type] ? type : 'RuPay';
  const prefix = bins[selectedType][Math.floor(random() * bins[selectedType].length)];
  
  const generateCard = () => {
    let card = prefix;
    // Generate 15 digits (including prefix)
    while (card.length < 15) {
      card += Math.floor(random() * 10).toString();
    }
    const checkDigit = luhn.calculateCheckDigit(card);
    const fullCard = card + checkDigit;
    
    return {
      card_number: fullCard,
      formatted: fullCard.match(/.{1,4}/g).join(' '),
      network: selectedType,
      cvv: Math.floor(random() * 900) + 100,
      expiry: `${Math.floor(random() * 12) + 1}/${new Date().getFullYear() + Math.floor(random() * 5) + 1}`
    };
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateCard());
  }

  return formatResponse(req, res, results, 'card_records');
};
