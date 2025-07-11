# lightXDM

A lightweight, display-manager-free desktop environment for minimalists, Arch Linux users, and those who prefer `startx` over SDDM/LightDM.

## Purpose & Target Users
- **Minimal RAM/boot time**: No display manager, no bloat, just your DE.
- **Auto-login & Keyring auto-unlock**: Seamless session start and secrets management for KDE Plasma, GNOME, and XFCE, LXQt, LXDE, MATE, Cinnamon, Budgie, and i3.
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
# Clone and run the installer
cd ~
git clone https://github.com/eserlxl/lightXDM.git
cd lightXDM
bash install.sh
```

> **Important:**
> - **Do NOT run `install.sh` as root or with `sudo`.** Run it as your regular user. The script will use `sudo` internally when needed.
> - Your user **must be in the `wheel` group** and have working `sudo` privileges. If not, see the error messages for instructions on how to add your user to the `wheel` group and configure `sudo`.
> - If you run `sudo bash install.sh` or run as root, the script will exit with an error.

- **Detects your installed DE** (Plasma, GNOME, XFCE, LXQt, LXDE, MATE, Cinnamon, Budgie, or i3).
- If no DE is found, it **prompts you to choose one** to install.
- Installs the minimal required packages for your chosen DE, including the correct polkit agent:
  - polkit-kde-agent for KDE Plasma
  - lxqt-policykit for LXQt
  - polkit-gnome for all other supported DEs.
- Copies dotfiles to your home, including the correct `.xinitrc-<de>` for your DE.
- Configures PAM for KWallet (Plasma) or GNOME Keyring (GNOME) auto-unlock.
- Configures Polkit for passwordless USB/power actions.
- Your DE will start automatically on TTY1 after login—no need to run 'startx'.

## Features

lightXDM has recently expanded to support many desktop environments and improved its installation workflow:

### Multi-Desktop Environment Support
- **Automatic Detection:** The installer detects if KDE Plasma, GNOME, XFCE, LXQt, LXDE, MATE, Cinnamon, Budgie, or i3 is already installed.
- **User Choice:** If no supported DE is found, the installer prompts you to select and install one (KDE Plasma, GNOME, XFCE, LXQt, LXDE, MATE, Cinnamon, Budgie, or i3).
- **Minimal Install:** Only the essential packages for your chosen DE are installed, including the correct polkit agent (polkit-kde-agent for Plasma, lxqt-policykit for LXQt, polkit-gnome for all others), keeping the system lightweight.
- **Dotfiles:** The correct `.xinitrc-<de>` and `.bash_profile` are copied for your DE, ensuring seamless auto-login and session start.

### Display Manager Independence
- **No Display Manager Needed:** The script disables any installed display managers (SDDM, LightDM, GDM, LXDM) to ensure a pure TTY+startx workflow.
- **Auto-Start on TTY1:** After login on TTY1, your desktop environment starts automatically—no need to run `startx` manually.

### System Integration
- **Polkit & PAM:** The installer configures Polkit rules for passwordless actions (for `wheel` group) and patches PAM for KWallet (Plasma) or GNOME Keyring (GNOME) auto-unlock.
- **GPG Agent Integration**: Seamlessly integrates `gpg-agent` with KWallet (for Plasma) or GNOME Keyring (for other DEs) for secure, passwordless GPG and SSH operations.
- **Documentation:** See the `docs/` directory for technical details on KWallet auto-unlock, Polkit integration, and autologin setup.

### Feature Overview

| Feature                        | Status                                      |
|--------------------------------|-----------------------------------------------------------|
| KDE Plasma support             | auto-detect/install, KWallet, polkit-kde-agent, dotfiles      |
| GNOME support                  | auto-detect/install, GNOME Keyring, polkit-gnome, dotfiles    |
| XFCE support                   | auto-detect/install, polkit-gnome, dotfiles                 |
| LXQt support                   | auto-detect/install, lxqt-policykit, dotfiles                |
| LXDE support                   | auto-detect/install, polkit-gnome, dotfiles                 |
| MATE support                   | auto-detect/install, polkit-gnome, dotfiles                 |
| Cinnamon support               | auto-detect/install, polkit-gnome, dotfiles                 |
| Budgie support                 | auto-detect/install, polkit-gnome, dotfiles                 |
| i3 support                     | auto-detect/install, polkit-gnome, dotfiles                 |
| No DE installed                | Prompts user, installs selected DE                                |
| Display manager free           | disables SDDM, LightDM, GDM, LXDM                           |
| Auto-login/startx on TTY1      | via `.bash_profile` and `.xinitrc-*`                        |
| Polkit integration             | secure rules for wheel group, correct agent for each DE     |
| PAM integration                | patches for KWallet/GNOME Keyring                           |
| GPG Agent Integration          | via `~/.gpg-agent-kwallet` for Plasma or `~/.gpg-agent-gnome` for other DEs |
| Documentation                  | `README.md`, `docs/`                                        |

---
See `docs/` for technical details and customization tips.

## Project Structure
```
lightXDM/
├── README.md
├── install.sh
├── dotfiles/
│   ├── .gpg-agent-gnome
│   ├── .gpg-agent-kwallet
│   ├── .xinitrc-plasma
│   ├── .xinitrc-gnome
│   ├── .xinitrc-xfce
│   ├── .xinitrc-lxqt
│   ├── .xinitrc-lxde
│   ├── .xinitrc-mate
│   ├── .xinitrc-cinnamon
│   ├── .xinitrc-budgie
│   ├── .xinitrc-i3
│   └── .bash_profile
├── pam/
│   ├── login-pam-kwallet.patch
│   └── login-pam-gnome-keyring.patch
├── polkit/
│   └── 49-nopasswd.rules
├── docs/
│   ├── gpg-agent.md
│   ├── kwallet-autounlock.md
│   ├── polkit-support.md
│   └── startx-autologin.md
└── LICENSE
```
