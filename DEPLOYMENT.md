# CORS Proxy Deployment Guide

## Problem:
- Flutter web app deployed to GitHub Pages: https://mubiyn.github.io/qr_web/
- Cannot directly call goldfish API due to CORS restrictions
- Need a proxy server to handle API calls with proper CORS headers

## Solution:
Deploy the existing Python proxy server (`api_proxy_server.py`) to a public service, then update Flutter app to use proxy URL.

## Step 1: Deploy Python Proxy to Railway

1. **Go to [Railway](https://railway.app)**
2. **Connect GitHub account**
3. **Deploy from GitHub repo**:
   - Select your `qr_web` repository 
   - Railway will detect Python and use `api_proxy_server.py`
   - It will automatically use the `Procfile` and `requirements.txt`
4. **Get the public URL** (something like `https://qr-web-production-abcd.railway.app`)

## Step 2: Update Flutter App Configuration

Once you have the Railway URL, update `lib/constants/app_constants.dart`:

```dart
class ApiConstants {
  // Use the Railway proxy URL instead of direct API
  static const String baseUrl = 'https://your-railway-app.railway.app'; // Replace with actual URL
  
  // Remove GitHub Pages detection since proxy handles CORS
  static bool get isGitHubPages => false; // Always use real API through proxy
  
  // ... rest of the file stays the same
}
```

## Step 3: Remove Mock Data Fallbacks

Update `lib/services/api_service.dart` to remove the GitHub Pages bypass logic and mock fallbacks, since the proxy will handle CORS properly.

## Step 4: Deploy Updated Flutter App

```bash
flutter build web
git add .
git commit -m "Use Railway proxy for CORS handling"
git push origin main
```

GitHub Actions will automatically deploy the updated app.

## How It Works:

```
GitHub Pages (https://mubiyn.github.io/qr_web/)
                    ↓
Railway Proxy (https://your-app.railway.app/api/...)
                    ↓  
Goldfish API (https://goldfish-app-3lf7u.ondigitalocean.app/api/...)
```

1. **Flutter app** makes API calls to Railway proxy URL
2. **Railway proxy** receives requests with CORS headers
3. **Proxy forwards** requests to goldfish API
4. **Proxy returns** responses with CORS headers enabled
5. **Flutter app** receives data without CORS errors

## Alternative Deployment Options:

### Heroku:
```bash
heroku create your-app-name
git push heroku main
```

### Vercel:
1. Connect GitHub repo to Vercel
2. Set build command: `echo "No build needed"`
3. Set start command: `python api_proxy_server.py --port $PORT`

## Testing:

After deployment, test the proxy:
- Health check: `https://your-railway-app.railway.app/health`  
- API test: `https://your-railway-app.railway.app/api/v1/payments/generate-and-save-braintree-client-token`

Then test the Flutter app at: `https://mubiyn.github.io/qr_web/`
