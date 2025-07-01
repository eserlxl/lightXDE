#!/usr/bin/env bash
# enable-autologin.sh: Enable or disable TTY1 autologin for a user using systemd override
set -e

OVERRIDE_DIR="/etc/systemd/system/getty@tty1.service.d"
OVERRIDE_FILE="$OVERRIDE_DIR/override.conf"

usage() {
  echo "Usage: sudo bash $0 <username> | --disable"
  exit 1
}

if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (with sudo)."
  exit 1
fi

if [[ "$1" == "--disable" ]]; then
  echo "Disabling TTY1 autologin..."
  rm -f "$OVERRIDE_FILE"
  systemctl daemon-reload
  systemctl restart getty@tty1
  echo "Autologin disabled."
  exit 0
fi

if [[ -z "$1" ]]; then
  usage
fi

USER="$1"

# Validate that the user exists
if ! id "$USER" >/dev/null 2>&1; then
  echo "User '$USER' does not exist."
  exit 1
fi

mkdir -p "$OVERRIDE_DIR"
echo "[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $USER --noclear %I $TERM" > "$OVERRIDE_FILE"
systemctl daemon-reload
systemctl restart getty@tty1

echo "Autologin enabled for user $USER on tty1." 
