#!/bin/bash
# ============================================
# claudehere installer
# One-click Claude Code launcher for macOS Finder
# https://claudehere.com
# ============================================

set -e

APP_NAME="Claude Here"
APP_PATH="/Applications/${APP_NAME}.app"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ICON_PNG="${PROJECT_DIR}/assets/icon.png"

echo ""
echo "  ╔═══════════════════════════════════╗"
echo "  ║      🔍 claudehere installer      ║"
echo "  ╚═══════════════════════════════════╝"
echo ""

# Check icon file
if [ ! -f "${ICON_PNG}" ]; then
    echo "⚠️  Icon not found: assets/icon.png"
    echo "   Please run this script from the project root."
    exit 1
fi

# Remove old version
if [ -d "${APP_PATH}" ]; then
    echo "🗑  Removing old version..."
    rm -rf "${APP_PATH}"
fi

# Also remove old claude-finder version if exists
OLD_APP="/Applications/Claude Finder.app"
if [ -d "${OLD_APP}" ]; then
    echo "🗑  Removing old Claude Finder version..."
    rm -rf "${OLD_APP}"
fi

# Create .app bundle
echo "📦 Creating app bundle..."
mkdir -p "${APP_PATH}/Contents/MacOS"
mkdir -p "${APP_PATH}/Contents/Resources"

# ---- Generate .icns icon ----
echo "🎨 Generating icon..."
ICONSET_DIR=$(mktemp -d)/AppIcon.iconset
mkdir -p "${ICONSET_DIR}"

sips -z 16 16     "${ICON_PNG}" --out "${ICONSET_DIR}/icon_16x16.png"      > /dev/null 2>&1
sips -z 32 32     "${ICON_PNG}" --out "${ICONSET_DIR}/icon_16x16@2x.png"   > /dev/null 2>&1
sips -z 32 32     "${ICON_PNG}" --out "${ICONSET_DIR}/icon_32x32.png"      > /dev/null 2>&1
sips -z 64 64     "${ICON_PNG}" --out "${ICONSET_DIR}/icon_32x32@2x.png"   > /dev/null 2>&1
sips -z 128 128   "${ICON_PNG}" --out "${ICONSET_DIR}/icon_128x128.png"    > /dev/null 2>&1
sips -z 256 256   "${ICON_PNG}" --out "${ICONSET_DIR}/icon_128x128@2x.png" > /dev/null 2>&1
sips -z 256 256   "${ICON_PNG}" --out "${ICONSET_DIR}/icon_256x256.png"    > /dev/null 2>&1
sips -z 512 512   "${ICON_PNG}" --out "${ICONSET_DIR}/icon_256x256@2x.png" > /dev/null 2>&1
sips -z 512 512   "${ICON_PNG}" --out "${ICONSET_DIR}/icon_512x512.png"    > /dev/null 2>&1
cp "${ICON_PNG}"                      "${ICONSET_DIR}/icon_512x512@2x.png"

iconutil -c icns "${ICONSET_DIR}" -o "${APP_PATH}/Contents/Resources/AppIcon.icns"

if [ $? -eq 0 ]; then
    echo "   ✅ Icon generated"
else
    echo "   ⚠️  Icon generation failed, using default icon"
fi

rm -rf "$(dirname "${ICONSET_DIR}")"

# ---- Write Info.plist ----
cat > "${APP_PATH}/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>claudehere</string>
    <key>CFBundleName</key>
    <string>Claude Here</string>
    <key>CFBundleDisplayName</key>
    <string>Claude Here</string>
    <key>CFBundleIdentifier</key>
    <string>com.claudehere.app</string>
    <key>CFBundleVersion</key>
    <string>1.0.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.13</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSAppleEventsUsageDescription</key>
    <string>Claude Here needs to access Finder to detect the current folder and launch Claude Code.</string>
</dict>
</plist>
PLIST

# ---- Write launcher script ----
cat > "${APP_PATH}/Contents/MacOS/claudehere" << 'LAUNCHER'
#!/bin/bash
# claudehere: Launch Claude Code in the current Finder directory

# Detect current Finder window path
FINDER_PATH=$(osascript -e '
tell application "Finder"
    if (count of Finder windows) > 0 then
        set currentFolder to (target of front Finder window) as alias
        return POSIX path of currentFolder
    else
        return POSIX path of (desktop as alias)
    end if
end tell
' 2>/dev/null)

# Fallback to home directory
if [ -z "$FINDER_PATH" ]; then
    FINDER_PATH="$HOME"
fi

# Detect user's preferred terminal
if [ -d "/Applications/iTerm.app" ] && [ "${CLAUDEHERE_TERMINAL:-}" = "iterm" ]; then
    osascript <<EOF
tell application "iTerm"
    activate
    set newWindow to (create window with default profile)
    tell current session of newWindow
        write text "cd \"${FINDER_PATH}\" && claude"
    end tell
end tell
EOF
else
    osascript <<EOF
tell application "Terminal"
    activate
    do script "cd \"${FINDER_PATH}\" && claude"
end tell
EOF
fi
LAUNCHER

chmod +x "${APP_PATH}/Contents/MacOS/claudehere"

# Set macOS bundle bit
/usr/bin/SetFile -a B "${APP_PATH}" 2>/dev/null

# Remove quarantine
xattr -dr com.apple.quarantine "${APP_PATH}" 2>/dev/null

echo ""
echo "  ✅ Claude Here installed successfully!"
echo ""
echo "  📍 Location: ${APP_PATH}"
echo ""
echo "  📖 How to add to Finder toolbar:"
echo "     1. Open any Finder window"
echo "     2. Right-click the toolbar → \"Customize Toolbar...\""
echo "     3. Open /Applications in another Finder window"
echo "     4. Drag \"Claude Here\" to the toolbar"
echo "     5. Click it to launch Claude Code in the current folder!"
echo ""
echo "  💡 Tip: If icon doesn't appear, try logging out and back in."
echo "  🌐 https://claudehere.com"
echo ""
