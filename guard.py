#!/usr/bin/env python3
import subprocess
import time
import glob
import os
import sys

ENV_PATH = os.path.expanduser("~/Projects/usb-guard/usb.env")
CHECK_INTERVAL = 1  # seconds

def load_env():
    data = {}
    with open(ENV_PATH) as f:
        for line in f:
            if "=" in line:
                k, v = line.strip().split("=", 1)
                data[k] = v
    return data

def get_usb_devices():
    return glob.glob("/dev/bus/usb/*/*")

def usb_present(cfg):
    for dev in get_usb_devices():
        try:
            out = subprocess.check_output(
                ["udevadm", "info", "--query=property", f"--name={dev}"],
                text=True,
                stderr=subprocess.DEVNULL
            )
            if (
                f"ID_VENDOR_ID={cfg['USB_VID']}" in out and
                f"ID_MODEL_ID={cfg['USB_PID']}" in out and
                f"ID_SERIAL_SHORT={cfg['USB_SERIAL']}" in out
            ):
                return True
        except Exception:
            pass
    return False

def ensure_locked():
    subprocess.Popen(
        ["hyprlock"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )

def main():
    if not os.path.exists(ENV_PATH):
        print("usb.env not found. Run setup.sh first.")
        sys.exit(1)

    cfg = load_env()

    while True:
        if not usb_present(cfg):
            ensure_locked()
        time.sleep(CHECK_INTERVAL)

if __name__ == "__main__":
    main()

