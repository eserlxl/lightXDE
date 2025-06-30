# Autologin on TTY1 with startx

lightXDE provides a display-manager-free autologin experience by:
- Logging in to TTY1 (via systemd or getty autologin)
- Using `.bash_profile` to auto-launch `startx` only on TTY1

## How it works
- If you log in on TTY1, `.bash_profile` runs `startx` automatically.
- No graphical login screen, no display manager needed.
- You get a full KDE Plasma session with minimal RAM and boot time.

## Setup
- The installer copies `.bash_profile` and `.xinitrc` to your home.
- To enable TTY1 autologin, set up `agetty` or `systemd` autologin for your user. 
