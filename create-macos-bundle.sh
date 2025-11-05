#!/bin/bash
set -e

APP_NAME="Random Passwords"
BUNDLE_NAME="Random Passwords.app"
VERSION="0.1.0"
BINARY_NAME="random-passwords"
IDENTIFIER="dev.deimoshall.random-passwords"

# Clean up any existing bundle
rm -rf "$BUNDLE_NAME"
rm -rf target/release/dist
mkdir -p target/release/dist

# Create app bundle structure
mkdir -p "$BUNDLE_NAME/Contents/MacOS"
mkdir -p "$BUNDLE_NAME/Contents/Resources"

# Copy the binary
cp "target/release/$BINARY_NAME" "$BUNDLE_NAME/Contents/MacOS/$BINARY_NAME"
chmod +x "$BUNDLE_NAME/Contents/MacOS/$BINARY_NAME"

# Convert PNG icon to ICNS (if available)
if [ -f "assets/icon-original.png" ]; then
    # Create iconset directory
    mkdir -p "$BUNDLE_NAME/Contents/Resources/icon.iconset"
    
    # Generate different icon sizes (use sips, which is built into macOS)
    sips -z 16 16     assets/icon-original.png --out "$BUNDLE_NAME/Contents/Resources/icon.iconset/icon_16x16.png" >/dev/null 2>&1
    sips -z 32 32     assets/icon-original.png --out "$BUNDLE_NAME/Contents/Resources/icon.iconset/icon_16x16@2x.png" >/dev/null 2>&1
    sips -z 32 32     assets/icon-original.png --out "$BUNDLE_NAME/Contents/Resources/icon.iconset/icon_32x32.png" >/dev/null 2>&1
    sips -z 64 64     assets/icon-original.png --out "$BUNDLE_NAME/Contents/Resources/icon.iconset/icon_32x32@2x.png" >/dev/null 2>&1
    sips -z 128 128   assets/icon-original.png --out "$BUNDLE_NAME/Contents/Resources/icon.iconset/icon_128x128.png" >/dev/null 2>&1
    sips -z 256 256   assets/icon-original.png --out "$BUNDLE_NAME/Contents/Resources/icon.iconset/icon_128x128@2x.png" >/dev/null 2>&1
    sips -z 256 256   assets/icon-original.png --out "$BUNDLE_NAME/Contents/Resources/icon.iconset/icon_256x256.png" >/dev/null 2>&1
    sips -z 512 512   assets/icon-original.png --out "$BUNDLE_NAME/Contents/Resources/icon.iconset/icon_256x256@2x.png" >/dev/null 2>&1
    sips -z 512 512   assets/icon-original.png --out "$BUNDLE_NAME/Contents/Resources/icon.iconset/icon_512x512.png" >/dev/null 2>&1
    sips -z 1024 1024 assets/icon-original.png --out "$BUNDLE_NAME/Contents/Resources/icon.iconset/icon_512x512@2x.png" >/dev/null 2>&1
    
    # Convert iconset to icns
    iconutil -c icns "$BUNDLE_NAME/Contents/Resources/icon.iconset" -o "$BUNDLE_NAME/Contents/Resources/icon.icns"
    rm -rf "$BUNDLE_NAME/Contents/Resources/icon.iconset"
fi

# Create Info.plist
cat > "$BUNDLE_NAME/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>$BINARY_NAME</string>
    <key>CFBundleIconFile</key>
    <string>icon.icns</string>
    <key>CFBundleIdentifier</key>
    <string>$IDENTIFIER</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundleVersion</key>
    <string>$VERSION</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.13</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2024 DeimosHall. Licensed under GPL-3.0.</string>
</dict>
</plist>
EOF

# Move app bundle to release folder
mv "$BUNDLE_NAME" target/release/dist/

echo "✅ App bundle created at: target/release/dist/$BUNDLE_NAME"
