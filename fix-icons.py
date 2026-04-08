#!/usr/bin/env python3
"""
Simple script to create basic PNG icons for the web app
"""
from PIL import Image, ImageDraw, ImageFont
import os

def create_icon(size, filename):
    """Create a BT logo icon of specified size"""
    # Create image with transparent background
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Calculate dimensions
    radius = max(8, size // 5)  # Rounded corners
    margin = size // 20

    # Create gradient-like background (simplified to solid color)
    bg_color = (88, 166, 255, 255)  # #58A6FF

    # Draw rounded rectangle background
    draw.rounded_rectangle(
        [margin, margin, size-margin, size-margin],
        radius=radius,
        fill=bg_color
    )

    # Draw "BT" text
    font_size = max(12, size // 2)
    try:
        # Try to use a system font
        font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", font_size)
    except:
        try:
            font = ImageFont.truetype("arial.ttf", font_size)
        except:
            font = ImageFont.load_default()

    text = "BT"
    text_bbox = draw.textbbox((0, 0), text, font=font)
    text_width = text_bbox[2] - text_bbox[0]
    text_height = text_bbox[3] - text_bbox[1]

    text_x = (size - text_width) // 2
    text_y = (size - text_height) // 2 - text_bbox[1]

    draw.text((text_x, text_y), text, fill=(255, 255, 255, 255), font=font)

    # Save the image
    img.save(filename, 'PNG')
    print(f"Created {filename} ({size}x{size})")

def main():
    # Define the icons we need to create
    icons = [
        (16, 'app/web/favicon-16x16.png'),
        (32, 'app/web/favicon-32x32.png'),
        (96, 'app/web/favicon-96x96.png'),
        (180, 'app/web/apple-touch-icon.png'),
        (192, 'app/web/android-chrome-192x192.png'),
        (512, 'app/web/android-chrome-512x512.png'),
    ]

    for size, filename in icons:
        create_icon(size, filename)

    print("All icons created successfully!")

if __name__ == "__main__":
    main()