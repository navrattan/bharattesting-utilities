module.exports = async (req, res) => {
  const changelog = [
    {
      version: '1.2.0',
      date: '2026-04-09',
      changes: [
        'Added seeded random generation (?seed=) for reproducibility',
        'Implemented multi-script name support (Devanagari, Tamil)',
        'Added credit/debit card generator with RuPay/Luhn support',
        'Enabled NDJSON streaming for large profile requests',
        'Added X-RateLimit headers for AI agent throttling'
      ]
    },
    {
      version: '1.1.0',
      date: '2026-04-08',
      changes: [
        'Added Phone, UPI, and IFSC generators',
        'Implemented Accept header support for CSV, XML, SQL, YAML',
        'Published OpenAPI 3.1 specification'
      ]
    },
    {
      version: '1.0.0',
      date: '2026-04-01',
      changes: [
        'Initial release with Aadhaar, PAN, and GSTIN generators'
      ]
    }
  ];

  res.status(200).json({
    project: 'BharatTesting API',
    changelog: changelog
  });
};
