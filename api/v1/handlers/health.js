module.exports = async (req, res) => {
  res.status(200).json({
    status: 'ok',
    version: '1.2.0',
    uptime: process.uptime(),
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'production',
    region: process.env.VERCEL_REGION || 'unknown'
  });
};
