#!/usr/bin/env bash
# lightXDE install script for Arch/Artix Linux
# Installs minimal Plasma, configures auto-login, KWallet, Polkit, and PAM
set -e

# Required packages
PKGS=(plasma-desktop xorg-server xorg-xinit pam-kwallet5 udisks2 polkit gvfs gvfs-mtp gvfs-gphoto2 gvfs-afc)

# Check for root
if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (sudo $0)"
  exit 1
fi

# 1. Install packages
pacman -Sy --needed "${PKGS[@]}"

# 2. Copy dotfiles to user home
USER_HOME=$(eval echo ~${SUDO_USER})
install -Dm644 dotfiles/.xinitrc "$USER_HOME/.xinitrc"
install -Dm644 dotfiles/.bash_profile "$USER_HOME/.bash_profile"
chown $SUDO_USER:$SUDO_USER "$USER_HOME/.xinitrc" "$USER_HOME/.bash_profile"

# 3. Patch /etc/pam.d/login for pam_kwallet5
if ! grep -q pam_kwallet5.so /etc/pam.d/login; then
  patch /etc/pam.d/login pam/login-pam-kwallet.patch
fi

# 4. Install polkit rule for wheel group
install -Dm644 polkit/49-nopasswd.rules /etc/polkit-1/rules.d/49-nopasswd.rules

# 5. Done
cat <<EOF
lightXDE install complete!
- Plasma will auto-start on TTY1 for $SUDO_USER
- KWallet auto-unlock and Polkit rules are set
- Reboot or log out to test
EOF 