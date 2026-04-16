#!/usr/bin/env zsh

###############################################################################
# Homebrew                                                                     #
###############################################################################

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
    echo "Homebrew not installed. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! command -v brew &>/dev/null; then
    echo "ERROR: Homebrew could not be configured. Add it to PATH manually and re-run."
    exit 1
fi

# Always ensure brew is in PATH for this session (needed when re-running)
eval "$(/opt/homebrew/bin/brew shellenv)"

brew update
brew upgrade
brew upgrade --cask
brew cleanup

###############################################################################
# Formulae                                                                     #
###############################################################################

packages=(
    # Shell & core utilities
    "zsh"
    "coreutils"
    "wget"
    "ripgrep"
    "trash"
    "mas"                 # Mac App Store CLI

    # Zsh enhancements (sourced in .zshrc)
    "zsh-syntax-highlighting"
    "zsh-autosuggestions"
    "zsh-history-substring-search"
    "powerlevel10k"

    # Version control
    "git"
    "gh"                  # GitHub CLI

    # Languages & runtimes
    "python"
    "nodenv"              # Node version manager
    "node-build"          # nodenv plugin for installing Node versions

    # Python tooling
    "uv"                  # Fast Python package/project manager

    # JavaScript tooling
    "pnpm"

    # Cloud & services
    "awscli"
    "stripe"

    # Database
    "mongosh"
    "mongodb/brew/mongodb-database-tools"
    "redis"

    # AI tools
    "ollama"
    "opencode"
    "gemini-cli"
    "agent-browser"

    # Git utilities
    "bfg"                 # Git history cleaner
    "git-filter-repo"     # Advanced git history rewriting
    "coderabbit"          # AI code review CLI

    # Security
    "openssl@3"
)

for package in "${packages[@]}"; do
    if brew list --formula | grep -q "^${package}\$"; then
        echo "$package already installed. Skipping..."
    else
        echo "Installing $package..."
        brew install "$package"
    fi
done

###############################################################################
# Default shell → Homebrew zsh                                                #
###############################################################################

BREW_ZSH="$(brew --prefix)/bin/zsh"
if ! grep -qF "$BREW_ZSH" /etc/shells; then
    echo "Adding Homebrew zsh to /etc/shells..."
    echo "$BREW_ZSH" | sudo tee -a /etc/shells >/dev/null
fi
chsh -s "$BREW_ZSH"

###############################################################################
# Oh My Zsh                                                                   #
###############################################################################

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh already installed. Skipping..."
fi

###############################################################################
# nodenv – set global Node version                                            #
###############################################################################

eval "$(nodenv init -)" 2>/dev/null || true
LATEST_LTS="22.14.0"
if ! nodenv versions | grep -q "$LATEST_LTS"; then
    echo "Installing Node $LATEST_LTS via nodenv..."
    nodenv install "$LATEST_LTS"
fi
nodenv global "$LATEST_LTS"
nodenv rehash
echo "Node global set to $LATEST_LTS"

###############################################################################
# Git global config                                                           #
###############################################################################

echo "Please enter your FULL NAME for Git configuration:"
read git_user_name
echo "Please enter your EMAIL for Git configuration:"
read git_user_email

git config --global user.name "$git_user_name"
git config --global user.email "$git_user_email"
git config --global init.defaultBranch main
git config --global core.ignoreCase false
git config --global pull.rebase false
echo "Git global config set."

###############################################################################
# Python virtual environment                                                  #
###############################################################################

if [ ! -d "$HOME/venvs/tutorial" ]; then
    echo "Creating tutorial Python venv at ~/venvs/tutorial..."
    mkdir -p "$HOME/venvs"
    python3 -m venv "$HOME/venvs/tutorial"
fi

###############################################################################
# Global npm/pnpm tools                                                       #
###############################################################################

# Use full path so we get the nodenv-managed npm, not any system npm
NODE_BIN="$HOME/.nodenv/versions/$LATEST_LTS/bin"
"$NODE_BIN/npm" install --global prettier

# pnpm global packages
pnpm_globals=(
    "vercel"
    "eslint"
    "@agentmail/cli"
    "agentmail-cli"
)
for pkg in "${pnpm_globals[@]}"; do
    echo "Installing pnpm global: $pkg..."
    pnpm add -g "$pkg"
done

###############################################################################
# macOS Applications (Casks)                                                  #
###############################################################################

apps=(
    # Browsers
    "google-chrome"
    "zen-browser"
    "helium-browser"      # Floating browser window

    # Development
    "visual-studio-code"
    "cursor"              # AI-first editor (primary IDE)
    "iterm2"
    "cmux"                # Terminal multiplexer manager
    "postman"
    "bruno"               # API client
    "commander-one"       # File manager

    # AI tools
    "claude-code"

    # Productivity & work
    "asana"
    "joplin"              # Notes
    "microsoft-office"
    "figma"

    # Media & entertainment
    "spotify"

    # Utilities
    "raycast"             # Launcher & window management
    "wispr-flow"          # Voice dictation
    "google-drive"
    "cheatsheet"
    "keepassxc"           # Password manager
    "tor-browser"
    "slack"
    "whatsapp"
)

for app in "${apps[@]}"; do
    if brew list --cask | grep -q "^${app}\$"; then
        echo "$app already installed. Skipping..."
    else
        echo "Installing $app..."
        brew install --cask "$app"
    fi
done

###############################################################################
# Fonts                                                                       #
###############################################################################

# cask-fonts tap is deprecated; fonts are now in the main homebrew/cask registry
fonts=(
    "font-meslo-lg-nerd-font"   # Required for powerlevel10k + iTerm2 profile
    "font-source-code-pro"
)

for font in "${fonts[@]}"; do
    if brew list --cask | grep -q "^${font}\$"; then
        echo "$font already installed. Skipping..."
    else
        echo "Installing $font..."
        brew install --cask "$font"
    fi
done

###############################################################################
# Final cleanup                                                               #
###############################################################################

brew update
brew upgrade
brew upgrade --cask
brew cleanup

###############################################################################
# Manual steps                                                                #
###############################################################################

echo ""
echo "============================================================"
echo "  MANUAL STEPS REMAINING"
echo "============================================================"
echo ""
echo "1. iTerm2 profile: already applied via DynamicProfiles."
echo "   Open iTerm2, go to Preferences → Profiles and set 'dotfiles' as default."
echo ""
echo "2. Raycast: Open Raycast → Settings → Advanced → Import"
echo "   File: ~/dotfiles/settings/Raycast.rayconfig (if exported before migration)"
echo ""
echo "3. Sign in to apps:"
echo "   - Google Chrome & Google Drive"
echo "   - Spotify"
echo "   - Joplin (sync your notes)"
echo "   - Asana"
echo "   - Figma"
echo "   - Slack workspaces"
echo ""
echo "Press enter to continue to VS Code setup..."
read
