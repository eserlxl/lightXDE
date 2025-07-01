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

## Feature Overview and Recent Improvements

lightXDE has recently expanded to support multiple desktop environments and improved its installation workflow:

### Multi-Desktop Environment Support
- **Automatic Detection:** The installer detects if KDE Plasma, GNOME, or XFCE is already installed.
- **User Choice:** If no supported DE is found, the installer prompts you to select and install one (KDE Plasma, GNOME, or XFCE).
- **Minimal Install:** Only the essential packages for your chosen DE are installed, keeping the system lightweight.
- **Dotfiles:** The correct `.xinitrc` and `.bash_profile` are copied for your DE, ensuring seamless auto-login and session start.

### Display Manager Independence
- **No Display Manager Needed:** The script disables any installed display managers (SDDM, LightDM, GDM, LXDM) to ensure a pure TTY+startx workflow.
- **Auto-Start on TTY1:** After login on TTY1, your desktop environment starts automatically—no need to run `startx` manually.

### System Integration
- **Polkit & PAM:** The installer configures Polkit rules for passwordless actions (for `wheel` group) and patches PAM for KWallet (Plasma) or GNOME Keyring (GNOME) auto-unlock.
- **Documentation:** See the `docs/` directory for technical details on KWallet auto-unlock, Polkit integration, and autologin setup.

### Summary Table

| Feature                        | Status/Implementation                                      |
|--------------------------------|-----------------------------------------------------------|
| KDE Plasma support             | Yes (auto-detect/install, KWallet, polkit, dotfiles)      |
| GNOME support                  | Yes (auto-detect/install, GNOME Keyring, polkit, dotfiles)|
| XFCE support                   | Yes (auto-detect/install, polkit, dotfiles)               |
| No DE installed                | Prompts user, installs selected DE                        |
| Display manager free           | Yes (disables SDDM, LightDM, GDM, LXDM)                   |
| Auto-login/startx on TTY1      | Yes (via `.bash_profile` and `.xinitrc-*`)                |
| Polkit integration             | Yes (secure rules for wheel group)                        |
| PAM integration                | Yes (patches for KWallet/GNOME Keyring)                   |
| Documentation                  | Yes (`README.md`, `docs/`)                                |

---
See `docs/` for technical details and customization tips.