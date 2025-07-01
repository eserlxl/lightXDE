# GPG Agent Integration for KWallet

lightXDE provides seamless integration between the GPG agent and KWallet, ensuring that your GPG keys are automatically available in your Plasma session. This integration allows you to use GPG for signing, encryption, and SSH authentication without repeatedly entering your passphrase.

## How It Works

1.  **`~/.gpg-agent-kwallet` Script**: This script, located in the `dotfiles` directory, is responsible for initializing the GPG agent and configuring it to use KWallet as a secure password cache. It sets the necessary environment variables, such as `GPG_TTY` and `SSH_AUTH_SOCK`, to ensure that GPG and SSH operations can communicate with the agent.

2.  **`.xinitrc-plasma`**: The `.xinitrc-plasma` file, which is used to start the Plasma session, sources the `~/.gpg-agent-kwallet` script. This ensures that the GPG agent is started and configured correctly every time you log in to your Plasma session.

## Benefits

-   **Single Sign-On**: Unlock your KWallet once at login, and your GPG keys are ready to use.
-   **Seamless SSH Authentication**: Use your GPG keys for SSH authentication without any extra steps.
-   **Secure Password Caching**: Your GPG passphrase is securely stored in KWallet.
