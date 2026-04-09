const formatResponse = require('./utils/formatter');

module.exports = async (req, res) => {
  const { count = 1, state } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  const rtoCodes = {
    'DL': ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13'],
    'KA': ['01', '02', '03', '04', '05', '51', '53'],
    'MH': ['01', '02', '03', '04', '12', '14', '15', '43', '46', '47'],
    'TN': ['01', '02', '03', '04', '05', '06', '07', '09', '10'],
    'UP': ['14', '16', '32', '78', '80'],
    'TS': ['07', '08', '09', '10', '11', '12', '13', '14'],
    'WB': ['01', '02', '03', '04', '05', '06', '07', '08']
  };

  const states = Object.keys(rtoCodes);
  
  const generateVehicleNum = () => {
    let stateCode;
    if (state && rtoCodes[state.toUpperCase()]) {
      stateCode = state.toUpperCase();
    } else {
      stateCode = states[Math.floor(Math.random() * states.length)];
    }

    const rto = rtoCodes[stateCode][Math.floor(Math.random() * rtoCodes[stateCode].length)];
    const series = String.fromCharCode(65 + Math.floor(Math.random() * 26)) + String.fromCharCode(65 + Math.floor(Math.random() * 26));
    const number = Math.floor(Math.random() * 9000) + 1000;
    
    return {
      registration_number: `${stateCode} ${rto} ${series} ${number}`,
      state: stateCode,
      rto_code: rto
    };
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateVehicleNum());
  }

  return formatResponse(req, res, results, 'vehicle_records');
};
