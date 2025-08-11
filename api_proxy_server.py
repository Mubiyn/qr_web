#!/usr/bin/env python3
"""
Advanced CORS Proxy Server for Flutter Web Development
Serves Flutter web app AND proxies API requests to bypass CORS
"""

import http.server
import socketserver
import os
import json
import urllib.request
import urllib.parse
import ssl
from urllib.error import HTTPError, URLError

# API Configuration
API_BASE_URL = "https://goldfish-app-3lf7u.ondigitalocean.app"
DEFAULT_PORT = int(os.environ.get('PORT', 8081))
WEB_DIRECTORY = os.environ.get('WEB_DIR', 'build/web')
API_ENDPOINTS = {
    "/api/v1/auth/apple/generate-account": "POST",
    "/api/v1/payments/generate-and-save-braintree-client-token": "GET", 
    "/api/v1/payments/add-payment-method": "POST",
    "/api/v1/payments/subscription/create-subscription-transaction-v2": "POST",
    "/api/v1/payments/rent-power-bank": "POST"
}

class CORSProxyHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # Add CORS headers
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With')
        self.send_header('Access-Control-Max-Age', '86400')
        super().end_headers()

    def do_OPTIONS(self):
        # Handle preflight requests
        self.send_response(200)
        self.end_headers()

    def do_GET(self):
        parsed_path = urllib.parse.urlparse(self.path)
        
        # Check if it's an API request
        if parsed_path.path.startswith('/api/'):
            self.proxy_api_request('GET')
            return
        
        # Handle Flutter routing
        file_path = parsed_path.path
        if file_path == '/' or file_path == '':
            file_path = '/index.html'
        
        # Check if it's a Flutter route
        full_path = self.translate_path(self.path)
        if not os.path.exists(full_path) and not file_path.startswith('/assets/'):
            self.path = '/index.html'
        
        super().do_GET()

    def do_POST(self):
        parsed_path = urllib.parse.urlparse(self.path)
        
        # Check if it's an API request
        if parsed_path.path.startswith('/api/'):
            self.proxy_api_request('POST')
            return
        
        # Handle other POST requests normally
        super().do_POST()

    def proxy_api_request(self, method):
        """Proxy API requests to the actual API server"""
        try:
            parsed_path = urllib.parse.urlparse(self.path)
            api_url = f"{API_BASE_URL}{parsed_path.path}"
            
            if parsed_path.query:
                api_url += f"?{parsed_path.query}"
            
            print(f"🔄 Proxying {method} {api_url}")
            
            # Prepare headers
            headers = {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'User-Agent': 'Flutter-Web-Proxy/1.0'
            }
            
            # Add authorization if present
            auth_header = self.headers.get('Authorization')
            if auth_header:
                headers['Authorization'] = auth_header
            
            # Prepare request data
            data = None
            if method == 'POST':
                content_length = int(self.headers.get('Content-Length', 0))
                if content_length > 0:
                    post_data = self.rfile.read(content_length)
                    data = post_data
                    print(f"📦 Request data: {post_data.decode('utf-8')}")
            
            # Make the request with SSL context
            ssl_context = ssl.create_default_context()
            ssl_context.check_hostname = False
            ssl_context.verify_mode = ssl.CERT_NONE
            
            req = urllib.request.Request(api_url, data=data, headers=headers)
            req.get_method = lambda: method
            
            with urllib.request.urlopen(req, timeout=30, context=ssl_context) as response:
                response_data = response.read()
                
                # Send successful response
                self.send_response(response.status)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                self.wfile.write(response_data)
                
                print(f"✅ API request successful: {response.status}")
                
        except HTTPError as e:
            print(f"❌ API HTTP Error: {e.code} - {e.reason}")
            self.send_response(e.code)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            
            error_response = {
                "error": f"API Error: {e.reason}",
                "status": e.code
            }
            self.wfile.write(json.dumps(error_response).encode())
            
        except URLError as e:
            print(f"❌ API URL Error: {e.reason}")
            self.send_response(503)
            self.send_header('Content-Type', 'application/json') 
            self.end_headers()
            
            error_response = {
                "error": f"Service unavailable: {e.reason}",
                "status": 503
            }
            self.wfile.write(json.dumps(error_response).encode())
            
        except Exception as e:
            print(f"❌ Unexpected error: {e}")
            self.send_response(500)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            
            error_response = {
                "error": f"Internal server error: {str(e)}",
                "status": 500
            }
            self.wfile.write(json.dumps(error_response).encode())

    def guess_type(self, path):
        # Add proper MIME types for Flutter web assets
        mimetype = super().guess_type(path)
        if path.endswith('.js'):
            return 'application/javascript'
        elif path.endswith('.wasm'):
            return 'application/wasm'
        elif path.endswith('.json'):
            return 'application/json'
        return mimetype

def run_proxy_server(port=8080, directory=None):
    if directory:
        os.chdir(directory)
    
    # Change to build/web directory to serve Flutter web files
    if os.path.exists('build/web'):
        os.chdir('build/web')
        print(f"📁 Serving from: {os.getcwd()}")
    
    with socketserver.TCPServer(("", port), CORSProxyHTTPRequestHandler) as httpd:
        print(f"🚀 Serving Flutter Web App with API Proxy at http://localhost:{port}")
        print(f"📁 Directory: {os.getcwd()}")
        print(f"🌐 API Proxy: {API_BASE_URL}")
        print(f"📱 Mobile access: http://[YOUR_IP]:{port}")
        print("✅ CORS enabled and API requests will be proxied")
        print("\n💡 Test URLs:")
        print(f"   • Main app: http://localhost:{port}")
        print(f"   • Payment: http://localhost:{port}/payment/RECH082203000350")
        print(f"   • Success: http://localhost:{port}/success")
        print(f"   • API test: http://localhost:{port}/api/v1/payments/generate-and-save-braintree-client-token")
        print("\nPress Ctrl+C to stop the server")
        
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n👋 Server stopped")

if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description='CORS Proxy server for Flutter Web + API')
    parser.add_argument('--port', '-p', type=int, default=8080, help='Port to serve on (default: 8080)')
    parser.add_argument('--dir', '-d', type=str, help='Directory to serve (default: current directory)')
    
    args = parser.parse_args()
    
    run_proxy_server(port=args.port, directory=args.dir)
