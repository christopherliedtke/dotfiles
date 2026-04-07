#!/usr/bin/env zsh

# Ensure Homebrew is in PATH for this session
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || true

###############################################################################
# VS Code Extensions                                                          #
###############################################################################

extensions=(
    # AI
    github.copilot
    github.copilot-chat

    # Git
    eamodio.gitlens
    github.vscode-github-actions

    # Code quality & formatting
    esbenp.prettier-vscode
    dbaeumer.vscode-eslint
    aaron-bond.better-comments

    # HTML / CSS
    formulahendry.auto-rename-tag
    zignd.html-css-class-completion
    bradlc.vscode-tailwindcss

    # JavaScript / TypeScript
    wix.vscode-import-cost
    yoavbls.pretty-ts-errors
    cardinal90.multi-cursor-case-preserve
    alduncanson.react-hooks-snippets
    conrad-hunter.next-ts-snippets

    # GraphQL
    graphql.vscode-graphql
    graphql.vscode-graphql-syntax

    # Database
    mongodb.mongodb-vscode
    mechatroner.rainbow-csv

    # Utilities
    christian-kohler.path-intellisense
    kisstkondoros.vscode-gutter-preview
    ritwickdey.liveserver
    mikestead.dotenv
    alefragnani.project-manager
    dakshmiglani.hex-to-rgba

    # Theme & icons
    sdras.night-owl
    pkief.material-icon-theme
)

install_extensions_for() {
    local CMD=$1
    if ! command -v "$CMD" &>/dev/null; then
        echo "$CMD not found. Skipping extension install for $CMD."
        return
    fi
    local installed
    installed=$("$CMD" --list-extensions 2>/dev/null)
    for ext in "${extensions[@]}"; do
        if echo "$installed" | grep -qi "^${ext}\$"; then
            echo "$ext already installed in $CMD. Skipping..."
        else
            echo "Installing $ext in $CMD..."
            "$CMD" --install-extension "$ext"
        fi
    done
}

echo "--- Installing VS Code extensions ---"
install_extensions_for "code"

echo "--- Installing Cursor extensions ---"
install_extensions_for "cursor"

###############################################################################
# VS Code Settings                                                            #
###############################################################################

copy_settings() {
    local SETTINGS_DIR=$1
    if [ -d "$SETTINGS_DIR" ]; then
        [ -f "$SETTINGS_DIR/settings.json" ] && \
            cp "$SETTINGS_DIR/settings.json" "$SETTINGS_DIR/settings.json.backup"
        [ -f "$SETTINGS_DIR/keybindings.json" ] && \
            cp "$SETTINGS_DIR/keybindings.json" "$SETTINGS_DIR/keybindings.json.backup"

        cp "settings/VSCode-Settings.json" "$SETTINGS_DIR/settings.json"
        cp "settings/VSCode-Keybindings.json" "$SETTINGS_DIR/keybindings.json"
        echo "Settings copied to $SETTINGS_DIR"
    else
        echo "Settings dir not found: $SETTINGS_DIR (skipping)"
    fi
}

VSCODE_DIR="$HOME/Library/Application Support/Code/User"
CURSOR_DIR="$HOME/Library/Application Support/Cursor/User"

echo "--- Copying VS Code settings ---"
copy_settings "$VSCODE_DIR"

echo "--- Copying Cursor settings ---"
copy_settings "$CURSOR_DIR"

###############################################################################
# Manual steps                                                                #
###############################################################################

echo ""
echo "Sign in to GitHub Copilot and any other extensions inside VS Code/Cursor."
echo "Press enter to continue..."
read
