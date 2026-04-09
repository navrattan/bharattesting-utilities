const { verhoeff, createRandom } = require('./utils/checksums');
const formatResponse = require('./utils/formatter');

module.exports = async (req, res) => {
  const { count = 1, state = 'Maharashtra', seed, format } = req.query;
  const numCount = Math.min(parseInt(count), 10000); // Higher limit for streaming
  const random = createRandom(seed);
  
  const stateData = {
    'Maharashtra': { 
      city: 'Mumbai', 
      pincode: '400001', 
      names: [
        { latin: 'Rahul', devanagari: 'राहुल' },
        { latin: 'Amit', devanagari: 'अमित' },
        { latin: 'Sneha', devanagari: 'स्नेहा' }
      ], 
      lastNames: [
        { latin: 'Kulkarni', devanagari: 'कुलकर्णी' },
        { latin: 'Deshpande', devanagari: 'देशपांडे' }
      ] 
    },
    'Tamil Nadu': {
      city: 'Chennai',
      pincode: '600001',
      names: [
        { latin: 'Arjun', tamil: 'அர்ஜுன்' },
        { latin: 'Vijay', tamil: 'விஜய்' }
      ],
      lastNames: [
        { latin: 'Iyer', tamil: 'ஐயர்' },
        { latin: 'Reddy', tamil: 'ரெட்டி' }
      ]
    }
  };

  const selectedState = stateData[state] ? state : 'Maharashtra';
  const data = stateData[selectedState];

  const generateProfile = () => {
    const fn = data.names[Math.floor(random() * data.names.length)];
    const ln = data.lastNames[Math.floor(random() * data.lastNames.length)];
    
    let aadhaarBase = (Math.floor(random() * 8) + 2).toString();
    for (let i = 0; i < 10; i++) aadhaarBase += Math.floor(random() * 10).toString();
    const aadhaar = aadhaarBase + verhoeff.calculateCheckDigit(aadhaarBase);

    return {
      name: { 
        first: fn.latin, 
        last: ln.latin, 
        full: `${fn.latin} ${ln.latin}`,
        native: fn.devanagari ? `${fn.devanagari} ${ln.devanagari}` : fn.tamil ? `${fn.tamil} ${ln.tamil}` : null
      },
      aadhaar,
      phone: `+91-9${Math.floor(random() * 900000000 + 100000000)}`,
      address: { city: data.city, state: selectedState, pincode: data.pincode }
    };
  };

  // True Streaming for NDJSON if count is high
  if (format === 'ndjson' && numCount > 100) {
    res.setHeader('Content-Type', 'application/x-ndjson');
    for (let i = 0; i < numCount; i++) {
      res.write(JSON.stringify(generateProfile()) + '\n');
    }
    return res.end();
  }

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateProfile());
  }

  return formatResponse(req, res, results, 'user_profiles');
};
