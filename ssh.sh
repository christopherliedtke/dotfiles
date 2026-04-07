#!/usr/bin/env zsh

###############################################################################
# SSH Key Setup                                                               #
# Generates an ed25519 SSH key, configures the agent, and guides you         #
# through adding it to GitHub.                                                #
###############################################################################

SSH_DIR="$HOME/.ssh"
KEY_FILE="$SSH_DIR/id_ed25519"
SSH_CONFIG="$SSH_DIR/config"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Generate key if it doesn't already exist
if [ -f "$KEY_FILE" ]; then
    echo "SSH key already exists at $KEY_FILE. Skipping generation."
else
    echo "Enter your email address for the SSH key:"
    read ssh_email
    ssh-keygen -t ed25519 -C "$ssh_email" -f "$KEY_FILE"
    echo "SSH key generated."
fi

# Ensure ssh-agent is running and key is added
eval "$(ssh-agent -s)"

# Write SSH config if not present
if [ ! -f "$SSH_CONFIG" ]; then
    cat > "$SSH_CONFIG" <<EOF
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF
    chmod 600 "$SSH_CONFIG"
    echo "SSH config created."
fi

# Add key to agent (UseKeychain stores passphrase in macOS Keychain)
ssh-add --apple-use-keychain "$KEY_FILE" 2>/dev/null || ssh-add "$KEY_FILE"

###############################################################################
# Add public key to GitHub                                                    #
###############################################################################

echo ""
echo "Your public SSH key:"
echo "------------------------------------------------------------"
cat "${KEY_FILE}.pub"
echo "------------------------------------------------------------"

# Copy to clipboard
pbcopy < "${KEY_FILE}.pub"
echo "Public key copied to clipboard."
echo ""

# Try using GitHub CLI if available
if command -v gh &>/dev/null; then
    # Authenticate first if not already logged in
    if ! gh auth status &>/dev/null; then
        echo "Logging in to GitHub CLI..."
        gh auth login
    fi
    echo "Enter a name for this key on GitHub (e.g. 'MacBook Pro 2025'):"
    read key_title
    gh ssh-key add "${KEY_FILE}.pub" --title "$key_title" && \
        echo "SSH key added to GitHub successfully." || \
        echo "Could not add key via CLI. Add it manually (see below)."
else
    echo "To add this key to GitHub:"
    echo "  1. Go to https://github.com/settings/ssh/new"
    echo "  2. Paste the key (already in your clipboard)"
    echo ""
    echo "Press enter when done..."
    read
fi

# Verify connection
echo ""
echo "Testing GitHub SSH connection..."
ssh -T git@github.com 2>&1 || true
