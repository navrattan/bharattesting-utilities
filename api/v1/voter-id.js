const formatResponse = require('./utils/formatter');

module.exports = async (req, res) => {
  const { count = 1, state = 'KA' } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  // PDF P.9: State prefix mapping
  const statePrefixes = {
    'KA': 'ABC',
    'MH': 'DEF',
    'DL': 'GHI',
    'TN': 'JKL',
    'TS': 'MNO',
    'WB': 'PQR',
    'UP': 'STU',
    'GJ': 'VWX'
  };

  const selectedState = state.toUpperCase();
  const prefix = statePrefixes[selectedState] || 'XYZ';
  
  const generateEPIC = () => {
    let epic = prefix;
    for (let i = 0; i < 7; i++) {
      epic += Math.floor(Math.random() * 10).toString();
    }
    return {
      voter_id: epic,
      state: selectedState
    };
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateEPIC());
  }

  return formatResponse(req, res, results, 'voter_id_records');
};
