const formatResponse = require('./utils/formatter');

module.exports = async (req, res) => {
  const { count = 1, state } = req.query;
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

  return formatResponse(req, res, results, 'address_records');
};
