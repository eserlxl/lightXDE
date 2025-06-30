#!/usr/bin/env bash
# lightXDE install script for Arch/Artix Linux
# Installs minimal Plasma, configures auto-login, KWallet, Polkit, and PAM
set -e

# --- Configuration ---
readonly PKGS=(
  plasma-desktop xorg-server xorg-xinit udisks2 polkit gvfs
  gvfs-mtp gvfs-gphoto2 gvfs-afc patch
)
readonly DM_LIST=(sddm lightdm gdm lxdm)
readonly LOGIN_FILE="/etc/pam.d/login"
readonly POLKIT_RULE_SRC="polkit/49-nopasswd.rules"
readonly POLKIT_RULE_DEST="/etc/polkit-1/rules.d/49-nopasswd.rules"
readonly PAM_PATCH_FILE="pam/login-pam-kwallet.patch"

# --- Functions ---

# Log a message to the console
log() {
  echo "=> $1"
}

# Check for root privileges
check_root() {
  if [[ $EUID -ne 0 ]]; then
    log "Please run as root (sudo $0)"
    exit 1
  fi
  if [[ -z "$SUDO_USER" ]]; then
    log "SUDO_USER not detected. Please run using sudo from your normal user account."
    exit 1
  fi
}

# Install required packages
install_packages() {
  log "Installing required packages..."
  pacman -Sy --needed --noconfirm "${PKGS[@]}"
}

# Copy dotfiles to the user's home directory
copy_dotfiles() {
  local user_home
  user_home=$(eval echo ~"${SUDO_USER}")
  log "Copying dotfiles to $user_home..."
  install -Dm644 "dotfiles/.xinitrc" "$user_home/.xinitrc"
  install -Dm644 "dotfiles/.bash_profile" "$user_home/.bash_profile"
  chown "$SUDO_USER:$SUDO_USER" "$user_home/.xinitrc" "$user_home/.bash_profile"
}

# Configure PAM for KWallet auto-unlock
configure_pam() {
  log "Configuring PAM for KWallet auto-unlock..."
  if ! grep -q "pam_kwallet5.so" "$LOGIN_FILE"; then
    log "Patching $LOGIN_FILE..."
    patch --backup "$LOGIN_FILE" < "$PAM_PATCH_FILE"
  else
    log "PAM configuration for KWallet already exists. Skipping."
  fi
}

# Install Polkit rule for passwordless actions
install_polkit_rule() {
  log "Installing Polkit rule for passwordless actions..."
  if [[ ! -f "$POLKIT_RULE_DEST" ]]; then
    install -Dm644 "$POLKIT_RULE_SRC" "$POLKIT_RULE_DEST"
  else
    log "Polkit rule already exists. Skipping."
  fi
}

# Disable any installed display managers
disable_display_managers() {
  log "Disabling any installed display managers..."
  local disabled_dms=()
  for dm in "${DM_LIST[@]}"; do
    if systemctl list-unit-files | grep -q "${dm}.service"; then
      if systemctl is-enabled --quiet "${dm}.service"; then
        systemctl disable "${dm}.service"
        disabled_dms+=("$dm")
      fi
    fi
  done
  if [[ ${#disabled_dms[@]} -gt 0 ]]; then
    log "Disabled display manager(s): ${disabled_dms[*]}"
    log "Your current session will not be interrupted."
  else
    log "No enabled display managers found."
  fi
}

# --- Main ---

main() {
  check_root
  install_packages
  copy_dotfiles
  configure_pam
  install_polkit_rule
  disable_display_managers

  cat <<EOF

lightXDE install complete!
- Plasma will auto-start on TTY1 for $SUDO_USER
- KWallet auto-unlock and Polkit rules are set
- Reboot or log out to test

On next boot, after logging in, lightXDE (Plasma desktop) will start automatically on TTY1. No need to run 'startx'.
EOF
}

main "$@"