# CORS Proxy Server

The CORS proxy server has been moved to the `cors-proxy-server/` folder for separate deployment.

## Quick Setup:

1. **Deploy the proxy server** from the `cors-proxy-server/` folder to Railway/Heroku
2. **Get the deployed URL** (e.g., `https://your-app.railway.app`)
3. **Update Flutter app** in `lib/constants/app_constants.dart`:
   ```dart
   static const String _proxyUrl = 'https://your-deployed-proxy-url.railway.app';
   ```
4. **Redeploy Flutter app** to GitHub Pages

## Files in cors-proxy-server/:
- `api_proxy_server.py` - Main Python server
- `README.md` - Complete documentation
- `DEPLOYMENT.md` - Deployment instructions
- `requirements.txt`, `Procfile`, `railway.toml` - Deployment configs

## Current Flutter App Status:
- ✅ Smart environment detection (local/GitHub Pages/other)
- ✅ Automatic proxy usage based on environment
- ✅ Ready for proxy deployment
- ⏳ Waiting for proxy URL update in constants
