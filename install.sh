#!/usr/bin/env zsh

############################
# macOS Setup – Main Entry Point
#
# Runs in order:
#   1. Symlinks dotfiles to $HOME
#   2. macOS system preferences (macOS.sh)
#   3. Homebrew packages & apps (brew.sh)
#   4. SSH key setup (ssh.sh)
#   5. iTerm2 profile (DynamicProfiles)
#   6. VS Code + Cursor extensions & settings (vscode.sh)
############################

DOTFILEDIR="${HOME}/dotfiles"

echo "Changing to ${DOTFILEDIR}..."
cd "${DOTFILEDIR}" || exit 1

###############################################################################
# 1. Symlinks                                                                 #
###############################################################################

files=(zshrc zprofile aliases private p10k.zsh)

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

echo ""
echo "============================================================"
echo "  Installation complete!"
echo "  Restart your terminal (or open a new tab) to apply all"
echo "  shell changes."
echo "============================================================"
