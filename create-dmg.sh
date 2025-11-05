#!/bin/bash
set -e

APP_NAME="Random Passwords"
BUNDLE_NAME="Random Passwords.app"
DMG_NAME="RandomPasswords-0.1.0-macOS.dmg"
VOLUME_NAME="Random Passwords"

# First, create the app bundle
echo "Creating app bundle..."
bash create-macos-bundle.sh

# Check if app bundle exists
if [ ! -d "target/release/dist/$BUNDLE_NAME" ]; then
    echo "❌ Error: App bundle not found at target/release/dist/$BUNDLE_NAME"
    exit 1
fi

# Create a temporary directory for DMG contents
TMP_DMG_DIR=$(mktemp -d)
echo "Preparing DMG contents in: $TMP_DMG_DIR"

# Copy app bundle to temp directory
cp -R "target/release/dist/$BUNDLE_NAME" "$TMP_DMG_DIR/"

# Create a symbolic link to /Applications
ln -s /Applications "$TMP_DMG_DIR/Applications"

# Create the DMG
echo "Creating DMG..."
hdiutil create -volname "$VOLUME_NAME" \
    -srcfolder "$TMP_DMG_DIR" \
    -ov -format UDZO \
    "target/release/dist/$DMG_NAME"

# Clean up
rm -rf "$TMP_DMG_DIR"

echo "✅ DMG created at: target/release/dist/$DMG_NAME"
echo ""
echo "To test the DMG:"
echo "  1. Open target/release/dist/$DMG_NAME"
echo "  2. Drag '$APP_NAME.app' to Applications"
echo "  3. Launch from Applications or Spotlight"
