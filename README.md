# USB Guard — Physical Presence Lock for Linux (Hyprland)

USB Guard is a small Linux utility that **enforces desktop locking based on the physical presence of a specific USB device**.

If the trusted USB is **not present**, the desktop is **locked immediately**, even after a manual password unlock.  
This turns a USB device into a **mandatory physical key** for your session.

Designed for:
- Wayland
- Hyprland
- `hyprlock`
- systemd user services

---

## 🚨 What This Is (and Is Not)

**This IS**
- A continuous presence enforcement guard
- A physical “dead-man switch” for your desktop
- Wayland-native (no key injection, no PAM hacks)
- Deterministic and reversible

**This is NOT**
- Disk encryption
- Protection against root compromise
- A replacement for your login password

If the USB is missing, the desktop **will not stay unlocked**.

---

## ⚙️ How It Works

1. A setup script lets you choose a USB device to trust
2. The USB’s VID, PID, and SERIAL are stored locally
3. A Python guard daemon runs in your user session
4. Every second it checks:
   - Is the trusted USB present?
5. If **not present** → `hyprlock` is triggered immediately
6. Unlocking with a password does nothing unless the USB is present

The lock is **continuously enforced**, not one-shot.

---

## 📁 Project Structure

```

usb-guard/
├── guard.py              # Presence enforcement daemon
├── setup.sh              # Interactive USB selector
├── install_service.sh    # systemd user service installer
├── usb.env               # Local USB identity (ignored by git)
├── .gitignore
└── README.md

````

---

## 🧩 Requirements

- Linux (Wayland)
- Hyprland
- `hyprlock`
- Python 3
- systemd (user services)

---

## 🚀 Setup

### 1️⃣ Clone or copy the project

```bash
git clone https://github.com/dev0root6/USB-Guard
cd USB-Guard
````

---

### 2️⃣ Select the trusted USB

Plug in the USB you want to use as the key, then run:

```bash
./setup.sh
```

You’ll be shown a numbered list of USB devices.
Choose the one you want to trust.

This creates a local file:

```
usb.env
```

(Contains VID / PID / SERIAL. Never commit this.)

---

### 3️⃣ Test manually (recommended)

```bash
./guard.py
```

* Remove USB → desktop locks
* Unlock with password → locks again
* Insert USB → unlock stays unlocked

Exit with `Ctrl+C` once confirmed.

---

### 4️⃣ Install as a systemd user service

```bash
./install_service.sh
```

This:

* Creates a systemd **user** service
* Enables it on login
* Starts it immediately

---

## 🔍 Service Control

```bash
systemctl --user status usb-guard
systemctl --user stop usb-guard
systemctl --user start usb-guard
systemctl --user disable usb-guard
```

---

## 🛑 Emergency Disable

If you ever need to bypass it:

```bash
systemctl --user stop usb-guard
```

Or remove the service entirely:

```bash
rm ~/.config/systemd/user/usb-guard.service
systemctl --user daemon-reload
```

---

## 🔐 Security Notes

* This is **possession-based security**
* USB identifiers can be cloned with effort
* Best used for:

  * Desk security
  * Shared spaces
  * Shoulder-surf protection
* Not designed to defeat root attackers

For higher assurance, combine with:

* phone-based biometric approval
* time delays
* multiple keys

---

## 🧠 Design Philosophy

* Presence, not proximity
* Enforcement, not convenience unlock
* Fail-closed behavior
* Wayland-safe abstractions

If the guard crashes, **nothing unlocks**.

---

## 🧪 Known Limitations

* Requires an active Hyprland session
* USB must expose a stable serial number
* Repeated `hyprlock` calls are intentional

---

## 📜 License

MIT — do whatever you want, but don’t pretend this is magic.

---

## 🧭 Future Ideas

* Grace delay before lock
* Multiple trusted USBs
* Tray indicator
* Phone + USB combo auth
* Audit logging

---

**Physical presence matters.**

```
