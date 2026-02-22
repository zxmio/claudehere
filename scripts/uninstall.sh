#!/bin/bash
# ============================================
# claudehere uninstaller
# ============================================

APP_PATH="/Applications/Claude Here.app"

echo ""
echo "  🗑  Uninstalling Claude Here..."
echo ""

if [ -d "${APP_PATH}" ]; then
    rm -rf "${APP_PATH}"
    echo "  ✅ Claude Here has been removed from /Applications"
    echo ""
    echo "  💡 Don't forget to remove it from your Finder toolbar:"
    echo "     Right-click toolbar → \"Customize Toolbar...\" → drag it out"
else
    echo "  ⚠️  Claude Here not found in /Applications"
fi

echo ""
