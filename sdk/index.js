const axios = require('axios');

class BharatTesting {
  constructor(apiKey = null) {
    this.baseURL = 'https://api.bharattesting.com/v1';
    this.client = axios.create({
      baseURL: this.baseURL,
      headers: apiKey ? { 'Authorization': `Bearer ${apiKey}` } : {}
    });
  }

  async generateAadhaar(count = 1) {
    const response = await this.client.get('/aadhaar', { params: { count } });
    return response.data.data;
  }

  async generatePAN(count = 1, type = 'P') {
    const response = await this.client.get('/pan', { params: { count, type } });
    return response.data.data;
  }

  async generateGSTIN(count = 1, stateCode = '27') {
    const response = await this.client.get('/gstin', { params: { count, stateCode } });
    return response.data.data;
  }

  async generateProfile(count = 1, state = 'Maharashtra') {
    const response = await this.client.get('/profile', { params: { count, state } });
    return response.data.data;
  }
}

module.exports = BharatTesting;
