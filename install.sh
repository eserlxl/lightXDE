#!/usr/bin/env bash
# lightXDE install script for Arch Linux
# Installs a minimal DE, configures auto-login, KWallet, Polkit, and PAM
set -e

# --- Configuration ---
readonly DM_LIST=(sddm lightdm gdm lxdm)
readonly LOGIN_FILE="/etc/pam.d/login"
readonly POLKIT_RULE_SRC="polkit/49-nopasswd.rules"
readonly POLKIT_RULE_DEST="/etc/polkit-1/rules.d/49-nopasswd.rules"
readonly PAM_KWALLET_PATCH_FILE="pam/login-pam-kwallet.patch"
readonly PAM_GNOME_KEYRING_PATCH_FILE="pam/login-pam-gnome-keyring.patch"

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

# Detect the installed desktop environment
detect_de() {
  if pacman -Qs plasma-desktop >/dev/null; then
    echo "plasma"
  elif pacman -Qs gnome-shell >/dev/null; then
    echo "gnome"
  elif pacman -Qs xfce4-session >/dev/null; then
    echo "xfce"
  elif pacman -Qs lxqt-session >/dev/null; then
    echo "lxqt"
  elif pacman -Qs lxde-session >/dev/null; then
    echo "lxde"
  elif pacman -Qs mate-session-manager >/dev/null; then
    echo "mate"
  elif pacman -Qs cinnamon >/dev/null; then
    echo "cinnamon"
  elif pacman -Qs budgie-desktop >/dev/null; then
    echo "budgie"
  elif pacman -Qs i3-wm >/dev/null; then
    echo "i3"
  elif pacman -Qs sway >/dev/null; then
    echo "sway"
  else
    echo "unknown"
  fi
}

# Prompt user to select a DE
prompt_de_selection() {
  log "No supported desktop environment detected."
  PS3="Please select a desktop environment to install: "
  options=("KDE Plasma" "GNOME" "XFCE" "LXQt" "LXDE" "MATE" "Cinnamon" "Budgie" "i3" "Sway" "Quit")
  select opt in "${options[@]}"; do
    case $opt in
      "KDE Plasma")
        echo "plasma"
        break
        ;;
      "GNOME")
        echo "gnome"
        break
        ;;
      "XFCE")
        echo "xfce"
        break
        ;;
      "LXQt")
        echo "lxqt"
        break
        ;;
      "LXDE")
        echo "lxde"
        break
        ;;
      "MATE")
        echo "mate"
        break
        ;;
      "Cinnamon")
        echo "cinnamon"
        break
        ;;
      "Budgie")
        echo "budgie"
        break
        ;;
      "i3")
        echo "i3"
        break
        ;;
      "Sway")
        echo "sway"
        break
        ;;
      "Quit")
        exit 0
        ;;
      *)
        log "Invalid option $REPLY"
        ;;
    esac
  done
}

# Install required packages
install_packages() {
  local de
  de=$1
  local pkgs=()
  local base_pkgs=(xorg-server xorg-xinit udisks2 polkit gvfs gvfs-mtp gvfs-gphoto2 gvfs-afc patch)

  case "$de" in
    plasma)
      pkgs=(plasma-desktop konsole dolphin kwallet-pam)
      ;;
    gnome)
      pkgs=(gnome gnome-terminal gnome-keyring)
      ;;
    xfce)
      pkgs=(xfce4 xfce4-session xfce4-terminal gnome-keyring)
      ;;
    lxqt)
      pkgs=(lxqt xdg-utils lxterminal gnome-keyring)
      ;;
    lxde)
      pkgs=(lxde gnome-keyring)
      ;;
    mate)
      pkgs=(mate mate-terminal gnome-keyring)
      ;;
    cinnamon)
      pkgs=(cinnamon gnome-terminal gnome-keyring)
      ;;
    budgie)
      pkgs=(budgie-desktop gnome-terminal gnome-keyring)
      ;;
    i3)
      pkgs=(i3 xterm gnome-keyring)
      ;;
    sway)
      pkgs=(sway foot gnome-keyring)
      ;;
    *)
      log "Unsupported desktop environment: $de"
      exit 1
      ;;
  esac

  log "Installing required packages for $de..."
  echo "$SUDO_PASSWORD" | sudo -S pacman -Sy --needed --noconfirm "${base_pkgs[@]}" "${pkgs[@]}"
}

# Copy dotfiles to the user's home directory
copy_dotfiles() {
  local de
  de=$1
  local user_home
  user_home=$(eval echo ~"${SUDO_USER}")

  log "Copying dotfiles to $user_home..."
  install -Dm644 "dotfiles/.bash_profile" "$user_home/.bash_profile"
  chown "$SUDO_USER:$SUDO_USER" "$user_home/.bash_profile"

  if [[ "$de" == "plasma" ]]; then
    install -Dm744 "dotfiles/.gpg-agent-kwallet" "$user_home/.gpg-agent-kwallet"
    chown "$SUDO_USER:$SUDO_USER" "$user_home/.gpg-agent-kwallet"
  else
    install -Dm744 "dotfiles/.gpg-agent-gnome" "$user_home/.gpg-agent-gnome"
    chown "$SUDO_USER:$SUDO_USER" "$user_home/.gpg-agent-gnome"
  fi

  local xinitrc_template="dotfiles/.xinitrc-$de"
  if [[ -f "$xinitrc_template" ]]; then
    install -Dm644 "$xinitrc_template" "$user_home/.xinitrc"
    chown "$SUDO_USER:$SUDO_USER" "$user_home/.xinitrc"
  else
    log "No .xinitrc template for $de. Please create $xinitrc_template for proper session startup."
  fi
}

# Configure PAM for KWallet/GNOME Keyring auto-unlock
configure_pam() {
  local de
  de=$1

  log "Configuring PAM for $de..."
  if [[ "$de" == "plasma" ]]; then
    if ! grep -q "pam_kwallet5.so" "$LOGIN_FILE"; then
      log "Applying KWallet PAM configuration to $LOGIN_FILE..."
      cat "$PAM_KWALLET_PATCH_FILE" | sudo tee "$LOGIN_FILE" > /dev/null
    else
      log "PAM configuration for KWallet already exists. Skipping."
    fi
  elif [[ "$de" == "gnome" ]]; then
    if ! grep -q "pam_gnome_keyring.so" "$LOGIN_FILE"; then
      log "Applying GNOME Keyring PAM configuration to $LOGIN_FILE..."
      cat "$PAM_GNOME_KEYRING_PATCH_FILE" | sudo tee "$LOGIN_FILE" > /dev/null
    else
      log "PAM configuration for GNOME Keyring already exists. Skipping."
    fi
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
  local de
  de=$(detect_de)

  if [[ "$de" == "unknown" ]]; then
    de=$(prompt_de_selection)
  else
    log "Detected desktop environment: $de"
  fi

  install_packages "$de"
  copy_dotfiles "$de"
  configure_pam "$de"
  install_polkit_rule
  disable_display_managers

  cat <<EOF

lightXDE install complete!
- $de will auto-start on TTY1 for $SUDO_USER
- Auto-unlock and Polkit rules are set
- Reboot or log out to test

On next boot, after logging in, your desktop environment will start automatically on TTY1. No need to run 'startx'.
EOF
}

main "$@"
