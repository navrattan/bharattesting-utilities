const formatResponse = require('./utils/formatter');

// Import all generators
const aadhaar = require('./handlers/aadhaar');
const pan = require('./handlers/pan');
const gstin = require('./handlers/gstin');
const phone = require('./handlers/phone');
const upi = require('./handlers/upi');
const ifsc = require('./handlers/ifsc');
const address = require('./handlers/address');
const vehicle = require('./handlers/vehicle');
const bankAccount = require('./handlers/bank-account');
const pincode = require('./handlers/pincode');
const company = require('./handlers/company');
const passport = require('./handlers/passport');
const email = require('./handlers/email');
const profile = require('./handlers/profile');
const card = require('./handlers/card');
const changelog = require('./handlers/changelog');
const health = require('./handlers/health');

const routes = {
  'aadhaar': aadhaar,
  'pan': pan,
  'gstin': gstin,
  'phone': phone,
  'upi': upi,
  'ifsc': ifsc,
  'address': address,
  'vehicle': vehicle,
  'bank-account': bankAccount,
  'pincode': pincode,
  'company': company,
  'passport': passport,
  'email': email,
  'profile': profile,
  'card': card,
  'changelog': changelog,
  'health': health
};

module.exports = async (req, res) => {
  // Extract path from Vercel URL
  // URL format: /api/v1/aadhaar
  const pathParts = req.url.split('?')[0].split('/');
  const endpoint = pathParts[pathParts.length - 1];

  if (routes[endpoint]) {
    try {
      return await routes[endpoint](req, res);
    } catch (error) {
      console.error(`Error in ${endpoint}:`, error);
      return formatResponse.error(res, 'INTERNAL_ERROR', 'An internal error occurred');
    }
  }

  return formatResponse.error(res, 'NOT_FOUND', `Endpoint /${endpoint} not found`);
};
