#!/usr/bin/env python3
"""
CORS-enabled HTTP Server for Flutter Web Development
Serves the Flutter web build with proper CORS headers
"""

import http.server
import socketserver
import os
import json
from urllib.parse import urlparse, parse_qs

class CORSHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
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
        # Handle Flutter routing - serve index.html for any route that doesn't exist
        parsed_path = urlparse(self.path)
        file_path = parsed_path.path
        
        # Remove leading slash and handle empty path
        if file_path == '/' or file_path == '':
            file_path = '/index.html'
        
        # Check if it's a Flutter route (like /payment/STATION_ID)
        full_path = self.translate_path(self.path)
        if not os.path.exists(full_path) and not file_path.startswith('/assets/'):
            # Serve index.html for Flutter routes
            self.path = '/index.html'
        
        super().do_GET()

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

def run_server(port=8080, directory=None):
    if directory:
        os.chdir(directory)
    
    with socketserver.TCPServer(("", port), CORSHTTPRequestHandler) as httpd:
        print(f"🚀 Serving Flutter Web App at http://localhost:{port}")
        print(f"📁 Directory: {os.getcwd()}")
        print(f"📱 Mobile access: http://[YOUR_IP]:{port}")
        print("🔧 CORS enabled for API requests")
        print("\n💡 Test URLs:")
        print(f"   • Main app: http://localhost:{port}")
        print(f"   • Payment: http://localhost:{port}/payment/RECH082203000350")
        print(f"   • Success: http://localhost:{port}/success")
        print("\nPress Ctrl+C to stop the server")
        
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n👋 Server stopped")

if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description='CORS-enabled server for Flutter Web')
    parser.add_argument('--port', '-p', type=int, default=8080, help='Port to serve on (default: 8080)')
    parser.add_argument('--dir', '-d', type=str, help='Directory to serve (default: current directory)')
    
    args = parser.parse_args()
    
    run_server(port=args.port, directory=args.dir)
