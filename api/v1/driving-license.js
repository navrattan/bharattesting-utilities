const formatResponse = require('./utils/formatter');

module.exports = async (req, res) => {
  const { count = 1, state = 'KA' } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  // PDF P.9: State-RTO mapping
  const stateRTOs = {
    'KA': '01', // Bengaluru
    'MH': '01', // Mumbai
    'DL': '01', // New Delhi
    'TN': '01', // Chennai
    'TS': '01', // Hyderabad
    'WB': '01', // Kolkata
    'UP': '14', // Noida
    'GJ': '01'  // Ahmedabad
  };

  const selectedState = state.toUpperCase();
  const rto = stateRTOs[selectedState] || '01';
  
  const generateDL = () => {
    const year = Math.floor(Math.random() * 20) + 2005;
    let sequence = '';
    for (let i = 0; i < 7; i++) {
      sequence += Math.floor(Math.random() * 10).toString();
    }
    // Format: KA01 20240000001
    return {
      dl_number: `${selectedState}${rto}${year}${sequence}`,
      state: selectedState,
      issue_year: year
    };
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateDL());
  }

  return formatResponse(req, res, results, 'dl_records');
};
