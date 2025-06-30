# Polkit Integration for lightXDE

This document explains how `lightXDE` integrates with Polkit to provide support for USB auto-mounting, power management, and session actions (like reboot, suspend, logout) without needing a display manager.

---

## ✨ What is Polkit?

Polkit (PolicyKit) is a framework for defining and handling **authorization** for privileged operations in desktop environments. When you try to:

* Mount a USB drive in Dolphin
* Reboot or suspend from the GUI
* Change power settings

...these actions are controlled by `polkit` rules.

In systems with no display manager (like SDDM or GDM), some polkit agents and privileges may not work unless explicitly enabled. `lightXDE` solves this by manually starting a polkit agent and installing scoped rules.

---

## 🔒 The Default Polkit Rule (Secure)

By default, `lightXDE` installs a scoped rule at:

```
/etc/polkit-1/rules.d/49-nopasswd.rules
```

**Content:**

```js
polkit.addRule(function(action, subject) {
  if (subject.isInGroup("wheel")) {
    if (
      action.id.match(/^org\.freedesktop\.udisks2\./) ||
      action.id.match(/^org\.freedesktop\.upower\./) ||
      action.id.match(/^org\.freedesktop\.login1\./)
    ) {
      return polkit.Result.YES;
    }
  }
});
```

### ✅ What this allows:

* Mounting removable drives (udisks2)
* Reboot, suspend, logout (login1)
* Battery and brightness control (upower)

### ❌ What it doesn't allow:

* Arbitrary admin-level system changes
* Package installations via polkit
* Actions from unknown services

This ensures your system remains secure even if `wheel` users run untrusted GUI apps.

---

## ⚠️ Optional: Less Secure (Full Access)

If you're the **only user** and want to allow all polkit actions for `wheel`, use this rule instead:

```js
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
```

> Warning: This allows any GUI app running as your user to elevate privileges automatically without a password.

---

## ⚙ Manual Polkit Agent Startup

Since we don't use a display manager, we manually start the polkit agent in `~/.xinitrc`:

```bash
/usr/lib/polkit-kde-authentication-agent-1 &
```

This line is essential to show GUI authentication dialogs when required.

---

## ✅ Verifying That It Works

* Plug in a USB drive — it should mount without password prompts.
* Click shutdown or suspend from the KDE application launcher — it should work instantly.
* Use `journalctl -b | grep polkit` to confirm rule loading.

---

## 🔧 Dependencies

Ensure the following packages are installed:

```
sudo pacman -S polkit udisks2 kde-cli-tools kio-extras gvfs
```

These provide the necessary backend support for KDE to interact with Polkit.

---

## 📄 Summary

| Feature        | Enabled By                          |
| -------------- | ----------------------------------- |
| USB automount  | `udisks2` rule + polkit agent       |
| Reboot/Suspend | `login1` rule                       |
| Brightness     | `upower` rule                       |
| GUI prompt     | `polkit-kde-authentication-agent-1` |

Use the default secure rules for best safety, and only loosen them if you're fully aware of the consequences.

---

For more, see: [Polkit Arch Wiki](https://wiki.archlinux.org/title/Polkit) 