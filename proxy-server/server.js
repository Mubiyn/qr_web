const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// Enable CORS for all origins
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
  credentials: false
}));

// Proxy configuration
const proxyOptions = {
  target: 'https://goldfish-app-3lf7u.ondigitalocean.app',
  changeOrigin: true,
  pathRewrite: {
    '^/api': '/api', // Keep the API path
  },
  onProxyReq: (proxyReq, req, res) => {
    // Log the request for debugging
    console.log(`Proxying: ${req.method} ${req.url}`);
    
    // Ensure proper headers
    proxyReq.setHeader('Accept', 'application/json');
    proxyReq.setHeader('Content-Type', 'application/json');
    
    // Forward authorization header if present
    if (req.headers.authorization) {
      proxyReq.setHeader('Authorization', req.headers.authorization);
    }
  },
  onError: (err, req, res) => {
    console.error('Proxy error:', err);
    res.status(500).json({ error: 'Proxy error', details: err.message });
  }
};

// Create proxy middleware
const apiProxy = createProxyMiddleware('/api', proxyOptions);

// Use the proxy middleware
app.use('/api', apiProxy);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Start server
app.listen(PORT, () => {
  console.log(`CORS Proxy Server running on port ${PORT}`);
  console.log(`Proxying requests to: https://goldfish-app-3lf7u.ondigitalocean.app`);
});
