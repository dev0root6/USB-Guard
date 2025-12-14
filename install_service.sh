#!/bin/bash

set -e

SERVICE_NAME="usb-guard"
SERVICE_DIR="$HOME/.config/systemd/user"
SERVICE_FILE="$SERVICE_DIR/$SERVICE_NAME.service"
PROJECT_DIR="$HOME/Projects/usb-guard"
GUARD_SCRIPT="$PROJECT_DIR/guard.py"

echo "[*] Installing USB Guard systemd user service"

# Sanity checks
if [ ! -f "$GUARD_SCRIPT" ]; then
    echo "[!] guard.py not found at $GUARD_SCRIPT"
    exit 1
fi

if ! command -v hyprlock >/dev/null; then
    echo "[!] hyprlock not found in PATH"
    exit 1
fi

mkdir -p "$SERVICE_DIR"

cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=USB Presence Lock Guard
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=simple
ExecStart=$GUARD_SCRIPT
Restart=always
RestartSec=1
Environment=WAYLAND_DISPLAY=%E{WAYLAND_DISPLAY}
Environment=XDG_RUNTIME_DIR=%E{XDG_RUNTIME_DIR}

[Install]
WantedBy=default.target
EOF

echo "[*] Reloading systemd user daemon"
systemctl --user daemon-reexec
systemctl --user daemon-reload

echo "[*] Enabling service"
systemctl --user enable $SERVICE_NAME.service

echo "[*] Starting service"
systemctl --user start $SERVICE_NAME.service

echo
echo "✅ USB Guard service installed and running"
echo
echo "Useful commands:"
echo "  systemctl --user status $SERVICE_NAME"
echo "  systemctl --user stop   $SERVICE_NAME"
echo "  systemctl --user start  $SERVICE_NAME"
echo "  systemctl --user disable $SERVICE_NAME"

