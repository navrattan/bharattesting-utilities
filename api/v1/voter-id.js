module.exports = async (req, res) => {
  const { count = 1, state = 'DL' } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  const generateEPIC = (st) => {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const nums = '0123456789';
    let epic = st.toUpperCase().substring(0, 3);
    if (epic.length < 3) epic = chars[Math.floor(Math.random() * 26)] + epic;
    
    for (let i = 0; i < 7; i++) epic += nums[Math.floor(Math.random() * 10)];
    return epic;
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateEPIC(state));
  }

  res.status(200).json({ data: results });
};
