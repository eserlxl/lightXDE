# lightXDE

A lightweight, display-manager-free KDE Plasma desktop environment for minimalists, Arch/Artix users, and those who prefer `startx` over SDDM/LightDM. 

## Purpose & Target Users
- **Minimal RAM/boot time**: No display manager, no bloat, just Plasma.
- **Auto-login & KWallet auto-unlock**: Seamless session start and secrets management.
- **Full Polkit & PAM integration**: USB automount, power actions, and secure authentication.
- **Systemd compatible**: Works on Arch, Artix, and derivatives.

**Target users:**
- Minimalists
- Arch/Artix users
- Display manager haters
- Tinkerers who want full control

## Why not SDDM/LightDM?
- No extra daemons or RAM usage
- Faster boot (no DM startup delay)
- Simpler troubleshooting (all config in dotfiles)
- No graphical login: boots to TTY1, and Plasma (lightXDE) auto-starts after login—no need to run `startx` manually

## Quick Install (Arch/Artix)
```sh
# 1. Clone and run the installer
cd ~
git clone https://github.com/eserlxl/lightXDE.git
cd lightXDE
bash install.sh
```

- Installs: plasma-desktop, xorg, udisks2, polkit, gvfs, and more
- Copies dotfiles to your home
- Configures PAM for KWallet auto-unlock (provided by plasma-workspace, which is installed as a dependency of plasma-desktop; no separate pam-kwallet5 package is required)
- Configures Polkit for passwordless USB/power actions
+ Plasma (lightXDE) will start automatically on TTY1 after login—no need to run 'startx'.

## Optional Enhancements
- GPG agent integration for KWallet
- Wayland fallback (coming soon)

## Project Structure
```
lightXDE/
├── README.md
├── install.sh
├── dotfiles/
│   ├── .xinitrc
│   └── .bash_profile
├── pam/
│   └── login-pam-kwallet.patch
├── polkit/
│   └── 49-nopasswd.rules
├── docs/
│   ├── kwallet-autounlock.md
│   ├── polkit-support.md
│   └── startx-autologin.md
└── LICENSE
```

## Goals
- Minimal, reproducible, and robust Plasma desktop
- No display manager required
- Full desktop experience with automatic Plasma launch on TTY1 after login (no manual 'startx' needed)

---
See `docs/` for technical details and customization tips. 
