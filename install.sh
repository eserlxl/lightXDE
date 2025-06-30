#!/usr/bin/env bash
# lightXDE install script for Arch/Artix Linux
# Installs minimal Plasma, configures auto-login, KWallet, Polkit, and PAM
set -e

# Required packages
PKGS=(plasma-desktop xorg-server xorg-xinit udisks2 polkit gvfs gvfs-mtp gvfs-gphoto2 gvfs-afc)

# Check for root
if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (sudo $0)"
  exit 1
fi

# Guard against missing SUDO_USER
if [[ -z "$SUDO_USER" ]]; then
  echo "SUDO_USER not detected. Please run using sudo from your normal user account."
  exit 1
fi

# 1. Install packages
pacman -Sy --needed "${PKGS[@]}"

# Ensure 'patch' utility is installed
if ! command -v patch >/dev/null 2>&1; then
  pacman -Sy --needed patch
fi

# 2. Copy dotfiles to user home
USER_HOME=$(eval echo ~"${SUDO_USER}")
install -Dm644 "dotfiles/.xinitrc" "$USER_HOME/.xinitrc"
install -Dm644 "dotfiles/.bash_profile" "$USER_HOME/.bash_profile"
chown "$SUDO_USER:$SUDO_USER" "$USER_HOME/.xinitrc" "$USER_HOME/.bash_profile"

# 3. Inject pam_kwallet5 lines if missing
LOGIN_FILE="/etc/pam.d/login"
if ! grep -q pam_kwallet5.so "$LOGIN_FILE"; then
  echo "[+] Injecting pam_kwallet5 into $LOGIN_FILE"
  cp "$LOGIN_FILE" "$LOGIN_FILE.bak"
  sed -i '/^auth.*pam_unix.so/a auth\toptional\tpam_kwallet5.so auto_start force_run' "$LOGIN_FILE"
  sed -i '/^session.*pam_unix.so/a session\toptional\tpam_kwallet5.so auto_start' "$LOGIN_FILE"
fi

# 4. Install polkit rule for wheel group
install -Dm644 "polkit/49-nopasswd.rules" "/etc/polkit-1/rules.d/49-nopasswd.rules"

# 4.5. Detect and disable any installed display manager
DM_LIST=(sddm lightdm gdm lxdm)
DISABLED_DMS=()
for DM in "${DM_LIST[@]}"; do
  if systemctl list-unit-files | grep -q "${DM}.service"; then
    if systemctl is-enabled --quiet "$DM.service"; then
      systemctl disable "$DM.service"
      DISABLED_DMS+=("$DM")
    fi
  fi
done
if [[ ${#DISABLED_DMS[@]} -gt 0 ]]; then
  echo "Disabled display manager(s): ${DISABLED_DMS[*]}"
  echo "Display manager(s) ${DISABLED_DMS[*]} have been disabled and will not start on next boot. Your current session will not be interrupted."
fi

# 5. Done
cat <<EOF
lightXDE install complete!
- Plasma will auto-start on TTY1 for $SUDO_USER
- KWallet auto-unlock and Polkit rules are set
- Reboot or log out to test

On next boot, after logging in, lightXDE (Plasma desktop) will start automatically on TTY1. No need to run 'startx'.
EOF 