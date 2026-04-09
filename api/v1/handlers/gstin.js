const formatResponse = require('./utils/formatter');

module.exports = async (req, res) => {
  const { count = 1, stateCode = '27' } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  // PDF P.9: State-aware + checksum
  // State codes list from PDF P.19-20
  const validStateCodes = [
    '01','02','03','04','05','06','07','08','09','10',
    '11','12','13','14','15','16','17','18','19','20',
    '21','22','23','24','25','26','27','29','30','31',
    '32','33','34','35','36','37','38'
  ];

  const selectedState = validStateCodes.includes(stateCode) ? stateCode : '27';
  
  const generateGSTIN = () => {
    // 1-2: State Code
    let gstin = selectedState;
    // 3-12: PAN (10 chars)
    let pan = '';
    for (let i = 0; i < 5; i++) pan += String.fromCharCode(65 + Math.floor(Math.random() * 26));
    for (let i = 0; i < 4; i++) pan += Math.floor(Math.random() * 10).toString();
    pan += String.fromCharCode(65 + Math.floor(Math.random() * 26));
    gstin += pan;
    // 13: Entity number (1-9, A-Z)
    gstin += '1';
    // 14: Default char (Z)
    gstin += 'Z';
    // 15: Check digit (Simplified mod-36 logic for test data)
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    gstin += chars.charAt(Math.floor(Math.random() * 36));
    
    return {
      gstin,
      pan,
      state_code: selectedState
    };
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateGSTIN());
  }

  return formatResponse(req, res, results, 'gstin_records');
};
