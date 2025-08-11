# Post-Deployment Configuration

## After deploying the Python proxy to Railway/Heroku:

1. **Get your deployed proxy URL** (e.g., `https://your-app-name.railway.app`)

2. **Update the proxy URL** in `lib/constants/app_constants.dart`:
   ```dart
   static const String _proxyUrl = 'https://your-actual-railway-url.railway.app';
   ```

3. **Rebuild and deploy** the Flutter app:
   ```bash
   flutter build web
   git add .
   git commit -m "Update proxy URL for production deployment"
   git push origin main
   ```

## Verification:

- **Local development**: Uses `http://localhost:8081`
- **GitHub Pages**: Uses deployed Railway proxy
- **Other environments**: Uses direct API

## Debug Information:

The app now logs which method it's using:
- `🔄 Attempting account generation via proxy`
- `🔄 Attempting account generation via direct API`

Watch the browser console to see which path is being used.
