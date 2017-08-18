#!/bin/bash

set -e

THIS_DIR=$(cd -- $(dirname "$BASH_SOURCE"); pwd)
TARGET_USER="$1"
DOCK_PLIST_FILE="$2"
OLD_FILE=$(mktemp -t uninstall-logout-others-$TARGET_USER-dock-old)
NEW_FILE=$(mktemp -t uninstall-logout-others-$TARGET_USER-dock-new)

echo "=== Reading old Dock configuration to $OLD_FILE"
plutil -convert xml1 -o "$OLD_FILE" "$DOCK_PLIST_FILE"

echo "=== Writing new Dock configuration to $NEW_FILE"
"$THIS_DIR/remove-from-dock-xml.py" < "$OLD_FILE" > "$NEW_FILE"

echo "=== Updating Dock with new configuration"
sudo -u "$TARGET_USER" plutil -convert binary1 -o "$DOCK_PLIST_FILE" - < "$NEW_FILE"

rm -f "$OLD_FILE" "$NEW_FILE"

