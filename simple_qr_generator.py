#!/usr/bin/env python3
"""
Simple QR Code Generator for Power Bank Station Testing
"""

import qrcode
import socket
import argparse

def get_local_ip():
    """Get the local IP address of this machine"""
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except:
        return "localhost"

def create_qr_code(station_id, base_url="http://localhost:8080", output_file=None):
    """Create a QR code for a power bank station"""
    
    payment_url = f"{base_url}/payment/{station_id}"
    
    print(f"🏷️  Station ID: {station_id}")
    print(f"🌐 Payment URL: {payment_url}")
    
    # Create QR code
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_M,
        box_size=10,
        border=4,
    )
    
    qr.add_data(payment_url)
    qr.make(fit=True)
    
    # Create image
    img = qr.make_image(fill_color="black", back_color="white")
    
    # Save the QR code
    if output_file is None:
        output_file = f"qr_station_{station_id}.png"
    
    img.save(output_file)
    print(f"💾 QR Code saved as: {output_file}")
    
    return output_file, payment_url

def create_test_qr_codes():
    """Create QR codes for testing"""
    
    local_ip = get_local_ip()
    
    print("🔧 Creating QR codes for Power Bank Station Testing")
    print("=" * 60)
    print(f"🖥️  Local IP: {local_ip}")
    print(f"📱 Mobile URL: http://{local_ip}:8080")
    print("=" * 60)
    
    # Test station from requirements
    station_id = "RECH082203000350"
    
    # Create QR code with local IP (for mobile testing)
    mobile_file, mobile_url = create_qr_code(
        station_id, 
        f"http://{local_ip}:8080", 
        f"qr_station_{station_id}_mobile.png"
    )
    
    print("\n📱 MOBILE QR CODE CREATED!")
    print(f"   File: {mobile_file}")
    print(f"   URL:  {mobile_url}")
    
    print(f"\n💡 HOW TO TEST:")
    print(f"   1. Start server: python3 api_proxy_server.py --dir build/web --port 8080")
    print(f"   2. Open {mobile_file} on your computer")
    print(f"   3. Scan the QR code with your phone camera")
    print(f"   4. Your phone will open: {mobile_url}")
    print(f"   5. Test the payment flow!")
    
    return mobile_file, mobile_url

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate QR code for Power Bank Station testing')
    parser.add_argument('--station-id', '-s', type=str, default="RECH082203000350", help='Station ID')
    
    args = parser.parse_args()
    
    try:
        create_test_qr_codes()
    except Exception as e:
        print(f"❌ Error: {e}")
