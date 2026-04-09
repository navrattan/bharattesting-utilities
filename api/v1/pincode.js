const formatResponse = require('./utils/formatter');

module.exports = async (req, res) => {
  const { count = 1, state } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  const statePincodes = {
    'Delhi': ['110'],
    'Maharashtra': ['400', '411', '440'],
    'Karnataka': ['560', '570', '580'],
    'Tamil Nadu': ['600', '641', '625'],
    'Uttar Pradesh': ['201', '226', '208'],
    'West Bengal': ['700', '713', '734']
  };

  const states = Object.keys(statePincodes);
  
  const generatePincode = () => {
    let prefix;
    let selectedState;
    if (state && statePincodes[state]) {
      selectedState = state;
      prefix = statePincodes[state][Math.floor(Math.random() * statePincodes[state].length)];
    } else {
      selectedState = states[Math.floor(Math.random() * states.length)];
      prefix = statePincodes[selectedState][Math.floor(Math.random() * statePincodes[selectedState].length)];
    }

    let suffix = '';
    for (let i = 0; i < 3; i++) {
      suffix += Math.floor(Math.random() * 10).toString();
    }
    
    return {
      pincode: prefix + suffix,
      state: selectedState
    };
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generatePincode());
  }

  return formatResponse(req, res, results, 'pincode_records');
};
