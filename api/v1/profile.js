const formatResponse = require('./utils/formatter');
const { verhoeff } = require('./utils/checksums');

module.exports = async (req, res) => {
  const { count = 1, state = 'Maharashtra', include = 'all' } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  const stateData = {
    'Maharashtra': { city: 'Mumbai', pincode: '400001', names: ['Rahul', 'Amit', 'Sneha', 'Priya'], lastNames: ['Kulkarni', 'Deshpande', 'Patil'] },
    'Karnataka': { city: 'Bengaluru', pincode: '560001', names: ['Arjun', 'Vijay', 'Lakshmi', 'Deepa'], lastNames: ['Gowda', 'Hegde', 'Rao'] },
    'Delhi': { city: 'New Delhi', pincode: '110001', names: ['Sanjay', 'Vikram', 'Neha', 'Pooja'], lastNames: ['Sharma', 'Gupta', 'Malhotra'] }
  };

  const selectedState = stateData[state] ? state : 'Maharashtra';
  const data = stateData[selectedState];

  const generateProfile = () => {
    const fn = data.names[Math.floor(Math.random() * data.names.length)];
    const ln = data.lastNames[Math.floor(Math.random() * data.lastNames.length)];
    
    // Aadhaar
    let aadhaarBase = (Math.floor(Math.random() * 8) + 2).toString();
    for (let i = 0; i < 10; i++) aadhaarBase += Math.floor(Math.random() * 10).toString();
    const aadhaar = aadhaarBase + verhoeff.calculateCheckDigit(aadhaarBase);

    // PAN (Individual)
    let pan = 'ABCDE'[Math.floor(Math.random() * 5)] + 'FGHIJ'[Math.floor(Math.random() * 5)] + 'KLMNO'[Math.floor(Math.random() * 5)] + 'P' + ln.charAt(0).toUpperCase();
    for (let i = 0; i < 4; i++) pan += Math.floor(Math.random() * 10).toString();
    pan += String.fromCharCode(65 + Math.floor(Math.random() * 26));

    return {
      name: { first: fn, last: ln, full: `${fn} ${ln}` },
      aadhaar,
      pan,
      phone: `+91-9${Math.floor(Math.random() * 900000000 + 100000000)}`,
      email: `${fn.toLowerCase()}.${ln.toLowerCase()}@example.com`,
      address: {
        line1: `${Math.floor(Math.random() * 500) + 1}, Main Road`,
        city: data.city,
        state: selectedState,
        pincode: data.pincode
      }
    };
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateProfile());
  }

  return formatResponse(req, res, results, 'user_profiles');
};
