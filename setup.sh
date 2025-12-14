#!/bin/bash

ENV_FILE="$HOME/Projects/usb-guard/usb.env"

echo "Scanning USB devices..."
echo

lsusb | nl -w2 -s'. '

echo
read -p "Choose USB number to trust: " CHOICE

LINE=$(lsusb | sed -n "${CHOICE}p")

if [ -z "$LINE" ]; then
    echo "Invalid choice"
    exit 1
fi

VID=$(echo "$LINE" | awk '{print $6}' | cut -d: -f1)
PID=$(echo "$LINE" | awk '{print $6}' | cut -d: -f2)

BUS=$(lsusb | sed -n "${CHOICE}p" | awk '{print $2}')
DEV=$(lsusb | sed -n "${CHOICE}p" | awk '{print $4}' | tr -d ':')

SERIAL=$(udevadm info --query=property --name=/dev/bus/usb/$BUS/$DEV | \
         grep ID_SERIAL_SHORT | cut -d= -f2)

if [ -z "$SERIAL" ]; then
    echo "⚠️  This USB has no serial number. Not recommended."
    exit 1
fi

cat > "$ENV_FILE" <<EOF
USB_VID=$VID
USB_PID=$PID
USB_SERIAL=$SERIAL
EOF

echo
echo "✅ USB registered:"
echo "VID=$VID"
echo "PID=$PID"
echo "SERIAL=$SERIAL"
echo
echo "Config saved to $ENV_FILE"

