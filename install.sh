#!/usr/bin/env zsh

############################
# macOS Setup – Main Entry Point
#
# Runs in order:
#   0. Pre-flight checks (architecture, Rosetta)
#   1. Symlinks dotfiles to $HOME
#   2. macOS system preferences (macOS.sh)
#   3. Homebrew packages & apps (brew.sh)
#   4. SSH key setup (ssh.sh)
#   5. iTerm2 profile (DynamicProfiles)
#   6. VS Code + Cursor extensions & settings (vscode.sh)
#   7. AI tool configs (opencode, Cursor MCP)
############################

DOTFILEDIR="${HOME}/dotfiles"

echo "Changing to ${DOTFILEDIR}..."
cd "${DOTFILEDIR}" || exit 1

###############################################################################
# 0. Pre-flight checks                                                        #
###############################################################################

echo ""
echo "── Pre-flight checks ──"

# Verify running on Apple Silicon natively (not under Rosetta)
ARCH=$(uname -m)
if [ "$ARCH" != "arm64" ]; then
    echo "WARNING: Running as $ARCH — expected arm64."
    echo "If this terminal is set to 'Open using Rosetta', disable that first."
    echo "Check: Activity Monitor → this process → Kind should be 'Apple'."
    echo "Press enter to continue anyway, or Ctrl+C to abort..."
    read
else
    echo "✓ Architecture: arm64"
fi

# Install Rosetta 2 (needed for some x86-only tools and installers)
if ! /usr/bin/pgrep oahd >/dev/null 2>&1; then
    echo "Installing Rosetta 2..."
    softwareupdate --install-rosetta --agree-to-license
else
    echo "✓ Rosetta 2 already installed"
fi

###############################################################################
# 1. Symlinks                                                                 #
###############################################################################

files=(zshrc zprofile aliases private p10k.zsh npmrc)

for file in "${files[@]}"; do
    if [ -f "${DOTFILEDIR}/.${file}" ]; then
        echo "Creating symlink: ~/.${file} → ${DOTFILEDIR}/.${file}"
        ln -sf "${DOTFILEDIR}/.${file}" "${HOME}/.${file}"
    else
        echo "Skipping .${file} (not found in dotfiles)"
    fi
done

###############################################################################
# 2. macOS System Preferences                                                 #
###############################################################################

echo ""
echo "Running macOS system preferences..."
zsh ./macOS.sh

###############################################################################
# 3. Homebrew + Applications                                                  #
###############################################################################

echo ""
echo "Running Homebrew setup..."
zsh ./brew.sh

###############################################################################
# Full Disk Access prompt (apps are now installed)                            #
###############################################################################

echo ""
echo "ACTION REQUIRED — grant Full Disk Access to your terminals:"
echo "  System Settings → Privacy & Security → Full Disk Access"
echo "  Enable: iTerm2, Cursor, Visual Studio Code"
echo "  (Without this, file operations in the integrated terminal will fail silently)"
echo ""
echo "Press enter when done..."
read

###############################################################################
# 4. SSH Key                                                                  #
###############################################################################

echo ""
echo "Setting up SSH key..."
zsh ./ssh.sh

###############################################################################
# 5. iTerm2 Profile (DynamicProfiles)                                         #
###############################################################################

ITERM_DYNPROFILES="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
mkdir -p "$ITERM_DYNPROFILES"
cp "${DOTFILEDIR}/settings/iTerm2-Profile.json" "$ITERM_DYNPROFILES/dotfiles.json"
echo "iTerm2 profile installed. Open iTerm2 → Preferences → Profiles to set it as default."

###############################################################################
# 6. VS Code + Cursor                                                         #
###############################################################################

echo ""
echo "Setting up VS Code and Cursor..."
zsh ./vscode.sh

###############################################################################
# 7. AI tool configs                                                          #
###############################################################################

echo ""
echo "Restoring AI tool configs..."

# opencode
mkdir -p "$HOME/.config/opencode"
cp "${DOTFILEDIR}/settings/opencode-config.json" "$HOME/.config/opencode/config.json"

# Cursor global MCP servers
mkdir -p "$HOME/.cursor"
cp "${DOTFILEDIR}/settings/cursor-mcp.json" "$HOME/.cursor/mcp.json"

echo "AI tool configs restored."

###############################################################################
# Post-install verification                                                   #
###############################################################################

echo ""
echo "── Verifying binary architectures ──"
for bin in brew node python3 git; do
    path=$(command -v $bin 2>/dev/null)
    if [ -n "$path" ]; then
        arch_info=$(file "$path" | grep -o "arm64\|x86_64" | head -1)
        if [ "$arch_info" = "arm64" ]; then
            echo "  ✓ $bin → $path ($arch_info)"
        else
            echo "  ✗ $bin → $path ($arch_info) — WRONG ARCHITECTURE"
        fi
    else
        echo "  ? $bin not found"
    fi
done

echo ""
echo "============================================================"
echo "  Installation complete!"
echo "  Restart your terminal to apply all shell changes."
echo ""
echo "  NEXT STEPS:"
echo "  1. Restore from your env-backup zip (see MIGRATION.md)"
echo "  2. Clone your dev repos into ~/DEV"
echo "  3. Sign in to apps: Slack, Spotify, Figma, Joplin, Asana"
echo "  4. Import Raycast settings"
echo "  5. Set iTerm2 'dotfiles' profile as default"
echo "  6. Sign in to GitHub Copilot in Cursor/VS Code"
echo "============================================================"
