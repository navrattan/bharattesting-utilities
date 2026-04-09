module.exports = async (req, res) => {
  const { count = 1, state = 'Delhi' } = req.query;
  const numCount = Math.min(parseInt(count), 50);
  
  const firstNames = ['Priya', 'Arjun', 'Anjali', 'Rahul', 'Sonal', 'Vikram', 'Deepa', 'Amit', 'Neha', 'Sanjay'];
  const lastNames = ['Sharma', 'Verma', 'Gupta', 'Soni', 'Patel', 'Reddy', 'Singh', 'Kumar', 'Iyer', 'Khan'];
  const states = ['Maharashtra', 'Delhi', 'Karnataka', 'Tamil Nadu', 'Gujarat'];
  const cities = {
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur'],
    'Delhi': ['New Delhi', 'Rohini', 'Dwarka'],
    'Karnataka': ['Bengaluru', 'Mysuru', 'Hubli'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara']
  };

  const generateProfile = () => {
    const fn = firstNames[Math.floor(Math.random() * firstNames.length)];
    const ln = lastNames[Math.floor(Math.random() * lastNames.length)];
    const s = state || states[Math.floor(Math.random() * states.length)];
    const cityList = cities[s] || ['City Center'];
    const c = cityList[Math.floor(Math.random() * cityList.length)];
    
    return {
      name: {
        first: fn,
        last: ln,
        full: `${fn} ${ln}`
      },
      phone: `+91-${Math.floor(Math.random() * 3000000000 + 7000000000)}`,
      email: `${fn.toLowerCase()}.${ln.toLowerCase()}${Math.floor(Math.random() * 99)}@example.com`,
      address: {
        line1: `${Math.floor(Math.random() * 500 + 1)}, Sector ${Math.floor(Math.random() * 20 + 1)}`,
        city: c,
        state: s,
        pincode: (Math.floor(Math.random() * 800000) + 110000).toString()
      }
    };
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateProfile());
  }

  res.status(200).json({
    data: results,
    meta: { count: numCount, generated_at: new Date().toISOString() }
  });
};
