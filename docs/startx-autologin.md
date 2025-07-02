# Autologin on TTY1 with startx

lightXDM provides a display-manager-free autologin experience by:
- Logging in to TTY1 (via systemd or getty autologin)
- Using `.bash_profile` to auto-launch `startx` only on TTY1

## How it works
- If you log in on TTY1, `.bash_profile` runs `startx` automatically.
- No graphical login screen, no display manager needed.
- You get a full KDE Plasma session with minimal RAM and boot time.

## Setup
- The installer copies `.bash_profile` and `.xinitrc` to your home.
- To enable TTY1 autologin, set up a systemd override for `agetty` on tty1 for your user:

### Example: Enable Autologin on TTY1 (systemd)

1. Create an override directory:
   ```sh
   sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
   ```
2. Create the override file:
   ```sh
   sudo nano /etc/systemd/system/getty@tty1.service.d/override.conf
   ```
   Paste the following content (replace `YOURUSER` with your username):
   ```ini
   [Service]
   ExecStart=
   ExecStart=-/usr/bin/agetty --autologin YOURUSER --noclear %I $TERM
   ```
3. Reload systemd and restart the service:
   ```sh
   sudo systemctl daemon-reload
   sudo systemctl restart getty@tty1
   ```

**To disable autologin:**
Remove the override file and restart the service:
```sh
sudo rm /etc/systemd/system/getty@tty1.service.d/override.conf
sudo systemctl daemon-reload
sudo systemctl restart getty@tty1
```

### Optional: Helper Script
You can use the provided `enable-autologin.sh` script to automate this setup. Run:
```sh
sudo bash enable-autologin.sh YOURUSER
```
This will create the override for you. To remove autologin, run:
```sh
sudo bash enable-autologin.sh --disable
```
