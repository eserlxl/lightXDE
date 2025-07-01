# lightXDE

A lightweight, display-manager-free desktop environment for minimalists, Arch Linux users, and those who prefer `startx` over SDDM/LightDM.

## Purpose & Target Users
- **Minimal RAM/boot time**: No display manager, no bloat, just your DE.
- **Auto-login & Keyring auto-unlock**: Seamless session start and secrets management for KDE Plasma, GNOME, and XFCE.
- **Full Polkit & PAM integration**: USB automount, power actions, and secure authentication.
- **Systemd compatible**: Works on Arch Linux and derivatives.

**Target users:**
- Minimalists
- Arch Linux users
- Display manager haters
- Tinkerers who want full control

## Why not SDDM/LightDM?
- No extra daemons or RAM usage
- Faster boot (no DM startup delay)
- Simpler troubleshooting (all config in dotfiles)
- No graphical login: boots to TTY1, and your DE auto-starts after login—no need to run `startx` manually

## Quick Install (Arch Linux)
```sh
# 1. Clone and run the installer (as root)
cd ~
git clone https://github.com/eserlxl/lightXDE.git
cd lightXDE
sudo bash install.sh
# or, if already root:
bash install.sh
```

- **Detects your installed DE** (Plasma, GNOME, or XFCE).
- If no DE is found, it **prompts you to choose one** to install.
- Installs the minimal required packages for your chosen DE.
- Copies dotfiles to your home.
- Configures PAM for KWallet (Plasma) or GNOME Keyring (GNOME) auto-unlock.
- Configures Polkit for passwordless USB/power actions.
- Your DE will start automatically on TTY1 after login—no need to run 'startx'.

## Optional Enhancements
- GPG agent integration for KWallet
- Wayland fallback (coming soon)

## Project Structure
```
lightXDE/
├── README.md
├── install.sh
├── dotfiles/
│   ├── .xinitrc-plasma
│   ├── .xinitrc-gnome
│   ├── .xinitrc-xfce
│   └── .bash_profile
├── pam/
│   ├── login-pam-kwallet.patch
│   └── login-pam-gnome-keyring.patch
├── polkit/
│   └── 49-nopasswd.rules
├── docs/
│   ├── kwallet-autounlock.md
│   ├── polkit-support.md
│   └── startx-autologin.md
└── LICENSE
```

## Goals
- Minimal, reproducible, and robust desktop environment
- No display manager required
- Full desktop experience with automatic DE launch on TTY1 after login (no manual 'startx' needed)

---
See `docs/` for technical details and customization tips.