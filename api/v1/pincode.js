module.exports = async (req, res) => {
  const { count = 1, format = 'json', state } = req.query;
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

  if (format === 'csv') {
    res.setHeader('Content-Type', 'text/csv');
    return res.send('pincode,state\n' + results.map(r => `${r.pincode},${r.state}`).join('\n'));
  }

  if (format === 'sql') {
    res.setHeader('Content-Type', 'text/plain');
    return res.send(`INSERT INTO pincodes (pincode, state) VALUES\n${results.map(r => `('${r.pincode}', '${r.state}')`).join(',\n')};`);
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
