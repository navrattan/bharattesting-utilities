module.exports = async (req, res) => {
  const { count = 1, format = 'json', state } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  const indianAddressData = [
    { state: 'Maharashtra', city: 'Mumbai', pincode: '400001', localities: ['Fort', 'Colaba', 'Nariman Point'] },
    { state: 'Karnataka', city: 'Bengaluru', pincode: '560001', localities: ['MG Road', 'Indiranagar', 'Koramangala'] },
    { state: 'Delhi', city: 'New Delhi', pincode: '110001', localities: ['Connaught Place', 'Janpath', 'Chanakyapuri'] },
    { state: 'Tamil Nadu', city: 'Chennai', pincode: '600001', localities: ['George Town', 'Parrys', 'Sowcarpet'] },
    { state: 'West Bengal', city: 'Kolkata', pincode: '700001', localities: ['Dalhousie Square', 'Fairley Place', 'BBD Bagh'] },
    { state: 'Telangana', city: 'Hyderabad', pincode: '500001', localities: ['Afzal Gunj', 'Begum Bazar', 'Moazzam Jahi Market'] },
    { state: 'Gujarat', city: 'Ahmedabad', pincode: '380001', localities: ['Bhadra', 'Ratanpole', 'Kalupur'] },
    { state: 'Rajasthan', city: 'Jaipur', pincode: '302001', localities: ['Pink City', 'Johari Bazar', 'Tripolia Bazar'] }
  ];

  const generateAddress = () => {
    let data;
    if (state) {
      const filtered = indianAddressData.filter(d => d.state.toLowerCase() === state.toLowerCase());
      data = filtered.length > 0 ? filtered[Math.floor(Math.random() * filtered.length)] : indianAddressData[Math.floor(Math.random() * indianAddressData.length)];
    } else {
      data = indianAddressData[Math.floor(Math.random() * indianAddressData.length)];
    }

    const houseNum = Math.floor(Math.random() * 500) + 1;
    const locality = data.localities[Math.floor(Math.random() * data.localities.length)];
    
    return {
      line1: `${houseNum}, ${locality}`,
      line2: 'Near Main Market',
      city: data.city,
      state: data.state,
      pincode: data.pincode,
      country: 'India',
      formatted: `${houseNum}, ${locality}, ${data.city}, ${data.state} - ${data.pincode}, India`
    };
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generateAddress());
  }

  if (format === 'csv') {
    res.setHeader('Content-Type', 'text/csv');
    const header = 'line1,city,state,pincode,country\n';
    const rows = results.map(a => `"${a.line1}","${a.city}","${a.state}","${a.pincode}","India"`).join('\n');
    return res.send(header + rows);
  }

  if (format === 'sql') {
    res.setHeader('Content-Type', 'text/plain');
    return res.send(`INSERT INTO addresses (line1, city, state, pincode, country) VALUES\n${results.map(a => `('${a.line1}', '${a.city}', '${a.state}', '${a.pincode}', 'India')`).join(',\n')};`);
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
