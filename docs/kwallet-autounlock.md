# KWallet Auto-Unlock via PAM

lightXDM uses pam_kwallet5 to automatically unlock your KDE Wallet (KWallet) at login, even without a display manager.

## How it works
- The installer safely backs up `/etc/pam.d/login` before patching, and can restore the original if patching fails.
- It patches `/etc/pam.d/login` to add `pam_kwallet5.so` to both `auth` and `session` sections.
- The `force_run` option ensures KWallet unlock runs even if no display manager is present.
- When you log in on TTY1 and start Plasma with `startx`, your wallet is unlocked seamlessly.

## Troubleshooting
- Make sure your wallet password matches your login password.
- If you use a different PAM stack, adapt the patch accordingly. 
