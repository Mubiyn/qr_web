#!/usr/bin/env python3
"""
QR Code Generator for Power Bank Station Testing
Generates QR codes that link to the Flutter web app with station IDs
"""

import qrcode
import socket
import argparse
from qrcode.image.styledpil import StyledPilImage
from qrcode.image.styles.moduledrawers.pil import RoundedModuleDrawer
from qrcode.image.styles.colorfills import RadialGradiantColorFill

def get_local_ip():
    """Get the local IP address of this machine"""
    try:
        # Connect to a remote address to determine local IP
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except:
        return "localhost"

def create_qr_code(station_id, base_url="http://localhost:8080", output_file=None):
    """Create a QR code for a power bank station"""
    
    # Create the URL that users will be redirected to
    payment_url = f"{base_url}/payment/{station_id}"
    
    print(f"🏷️  Station ID: {station_id}")
    print(f"🌐 Payment URL: {payment_url}")
    
    # Create QR code instance
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_M,
        box_size=10,
        border=4,
    )
    
    # Add data
    qr.add_data(payment_url)
    qr.make(fit=True)
    
    # Create styled QR code image
    img = qr.make_image(
        image_factory=StyledPilImage,
        module_drawer=RoundedModuleDrawer(),
        color_mask=RadialGradiantColorFill(
            center_color=(30, 136, 229),  # Blue center
            edge_color=(0, 0, 0)          # Black edges
        )
    )
    
    # Save the QR code
    if output_file is None:
        output_file = f"qr_code_station_{station_id}.png"
    
    img.save(output_file)
    print(f"💾 QR Code saved as: {output_file}")
    
    return output_file, payment_url

def create_test_qr_codes():
    """Create QR codes for testing with different station IDs"""
    
    local_ip = get_local_ip()
    base_url_local = f"http://{local_ip}:8080"
    base_url_localhost = "http://localhost:8080"
    
    print("🔧 Creating QR codes for Power Bank Station Testing")
    print("=" * 60)
    
    # Test station IDs
    station_ids = [
        "RECH082203000350",  # From requirements
        "RECH082203000351",  # Additional test stations
        "RECH082203000352",
        "TEST123456789"      # Simple test ID
    ]
    
    qr_codes_info = []
    
    for i, station_id in enumerate(station_ids):
        print(f"\n📱 Creating QR Code {i+1}/{len(station_ids)}")
        
        # Create QR code with local IP (for mobile testing)
        output_file = f"qr_station_{station_id}_mobile.png"
        file_mobile, url_mobile = create_qr_code(station_id, base_url_local, output_file)
        
        # Create QR code with localhost (for desktop testing)
        output_file = f"qr_station_{station_id}_desktop.png"
        file_desktop, url_desktop = create_qr_code(station_id, base_url_localhost, output_file)
        
        qr_codes_info.append({
            'station_id': station_id,
            'mobile_file': file_mobile,
            'mobile_url': url_mobile,
            'desktop_file': file_desktop,
            'desktop_url': url_desktop
        })
    
    # Create summary
    print("\n" + "=" * 60)
    print("📋 QR CODES GENERATED - TESTING SUMMARY")
    print("=" * 60)
    
    for info in qr_codes_info:
        print(f"\n🏷️  Station: {info['station_id']}")
        print(f"   📱 Mobile QR:  {info['mobile_file']}")
        print(f"      URL: {info['mobile_url']}")
        print(f"   💻 Desktop QR: {info['desktop_file']}")
        print(f"      URL: {info['desktop_url']}")
    
    print(f"\n💡 Instructions:")
    print(f"   1. Start your Python server: python3 api_proxy_server.py --dir build/web --port 8080")
    print(f"   2. Scan mobile QR codes with your phone")
    print(f"   3. Or scan desktop QR codes and open on computer")
    print(f"   4. Test the complete payment flow!")
    
    return qr_codes_info

def main():
    parser = argparse.ArgumentParser(description='Generate QR codes for Power Bank Station testing')
    parser.add_argument('--station-id', '-s', type=str, help='Single station ID to create QR code for')
    parser.add_argument('--url', '-u', type=str, help='Base URL for the web app (default: auto-detect)')
    parser.add_argument('--output', '-o', type=str, help='Output file name')
    parser.add_argument('--create-test-set', action='store_true', help='Create a full set of test QR codes')
    
    args = parser.parse_args()
    
    try:
        if args.create_test_set or not args.station_id:
            # Create full test set
            create_test_qr_codes()
        else:
            # Create single QR code
            base_url = args.url or f"http://{get_local_ip()}:8080"
            create_qr_code(args.station_id, base_url, args.output)
            
    except ImportError as e:
        if "qrcode" in str(e):
            print("❌ Error: qrcode library not installed")
            print("📦 Install with: pip3 install qrcode[pil]")
        else:
            print(f"❌ Import Error: {e}")
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    main()
