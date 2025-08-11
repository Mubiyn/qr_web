# CORS Proxy Server Deployment

This proxy server handles CORS issues when the Flutter web app needs to communicate with the goldfish API from GitHub Pages.

## Quick Deploy Options

### Option 1: Railway (Recommended)
1. Go to [Railway](https://railway.app)
2. Click "Deploy from GitHub repo"
3. Connect this repository
4. Select the `proxy-server` folder
5. Railway will automatically deploy using the `railway.toml` config
6. Copy the generated URL (something like `https://your-app.railway.app`)

### Option 2: Vercel
1. Go to [Vercel](https://vercel.com)
2. Import this repository
3. Set the root directory to `proxy-server`
4. Deploy
5. Copy the generated URL

### Option 3: Heroku
1. Install Heroku CLI
2. Navigate to proxy-server folder
3. Run:
   ```bash
   heroku create your-app-name
   git init
   git add .
   git commit -m "Initial commit"
   heroku git:remote -a your-app-name
   git push heroku main
   ```

### Option 4: Local Development
```bash
cd proxy-server
npm install
npm start
```
Server will run on http://localhost:3000

## Usage

Once deployed, update the Flutter app's `ApiConstants.baseUrl` to point to your proxy server URL.

For example, if deployed to Railway at `https://cors-proxy-xyz.railway.app`, then:
```dart
static const String baseUrl = 'https://cors-proxy-xyz.railway.app';
```

## How it works

The proxy server:
1. Receives requests from the Flutter web app
2. Adds proper CORS headers
3. Forwards requests to the goldfish API
4. Returns responses with CORS headers enabled
5. Handles all HTTP methods (GET, POST, PUT, DELETE)
6. Preserves Authorization headers and request bodies
