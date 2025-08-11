#!/usr/bin/env python3
"""
QR Code Generator for Power Bank Rental Station
Generates QR codes that link directly to the payment screen
"""

import qrcode
from qrcode.image.styledpil import StyledPilImage
from qrcode.image.styles.moduledrawers import RoundedModuleDrawer
from qrcode.image.styles.colormasks import SolidFillColorMask

def generate_station_qr(station_id, port=8081, host="localhost"):
    """Generate QR code for a power bank station"""
    
    # URL that opens directly to the payment screen
    url = f"http://{host}:{port}/payment/{station_id}"
    
    print(f"🏠 Generating QR code for Station: {station_id}")
    print(f"🔗 URL: {url}")
    
    # Create QR code instance
    qr = qrcode.QRCode(
        version=1,  # Controls the size of the QR Code
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    
    # Add data
    qr.add_data(url)
    qr.make(fit=True)
    
    # Create image with styling
    img = qr.make_image(
        image_factory=StyledPilImage,
        module_drawer=RoundedModuleDrawer(),
        color_mask=SolidFillColorMask(back_color=(255, 255, 255), front_color=(0, 0, 0))
    )
    
    # Save the image
    filename = f"qr_station_{station_id}_{host.replace('.', '_')}_port{port}.png"
    img.save(filename)
    
    print(f"✅ QR code saved as: {filename}")
    print(f"📱 Scan with your mobile device to test the flow!")
    print()
    print("📋 Testing Flow:")
    print("1. Scan QR code with your phone")
    print("2. Should open payment screen in mobile browser")
    print("3. Select payment method (Apple Pay or Card)")
    print("4. Complete payment process")
    print("5. See success screen")
    
    return filename

if __name__ == "__main__":
    # Generate QR code for the test station
    station_id = "RECH082203000350"
    ip_address = "192.168.0.102"  # Your local IP
    generate_station_qr(station_id, 8081, ip_address)
