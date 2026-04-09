const { verhoeff, luhnMod36 } = require('./utils/checksums');

module.exports = async (req, res) => {
  const { count = 1, state = 'DL' } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  const generateDL = (st) => {
    const sc = st.toUpperCase().substring(0, 2);
    const year = (new Date().getFullYear() - Math.floor(Math.random() * 20)).toString();
    const rto = (Math.floor(Math.random() * 99) + 1).toString().padStart(2, '0');
    const seq = Math.floor(Math.random() * 9999999).toString().padStart(7, '0');
    return `${sc}${rto}${year}${seq}`;
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateDL(state));
  }

  res.status(200).json({ data: results });
};
