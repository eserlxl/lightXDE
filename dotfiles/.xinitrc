#!/bin/bash
# .xinitrc for lightXDE: start KDE Plasma with dbus, session vars, and polkit agent

export DESKTOP_SESSION=plasma
export XDG_CURRENT_DESKTOP=KDE

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
[[ -f ~/.xprofile ]] && source ~/.xprofile

/usr/lib/polkit-kde-authentication-agent-1 &

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
  exec dbus-launch --exit-with-session startplasma-x11
else
  exec startplasma-x11
fi
