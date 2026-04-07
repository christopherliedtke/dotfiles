#!/usr/bin/env zsh

###############################################################################
# backup-envs.sh
#
# Run this on your OLD Mac before migrating.
# Collects .env files, secret files, credentials, AI tool configs, and shell
# history into a single encrypted zip.
# Store the zip in KeePassXC, Google Drive, or on a USB stick.
###############################################################################

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
BACKUP_DIR="/tmp/env-backup-$TIMESTAMP"
ARCHIVE="$HOME/Desktop/env-backup-$TIMESTAMP.zip"
DEV_DIR="$HOME/DEV"

echo "Creating backup staging area..."
mkdir -p "$BACKUP_DIR"

copy_file() {
    local src=$1
    local relative="${src#$HOME/}"
    local target="$BACKUP_DIR/$relative"
    mkdir -p "$(dirname "$target")"
    cp "$src" "$target"
    echo "  + $relative"
}

copy_dir() {
    local src=$1
    local relative="${src#$HOME/}"
    local target="$BACKUP_DIR/$relative"
    mkdir -p "$(dirname "$target")"
    cp -r "$src" "$target"
    echo "  + $relative/"
}

###############################################################################
# 1. .env files                                                               #
###############################################################################

echo "\n── .env files ──"
find "$DEV_DIR" \
    -name ".env*" \
    -not -path "*/node_modules/*" \
    -not -path "*/.git/*" \
    -not -path "*/.venv/*" \
    -not -name "*.example" \
    | while read -r f; do copy_file "$f"; done

###############################################################################
# 2. Other secret files (gitignored credentials)                              #
###############################################################################

echo "\n── Secret/credential files ──"

# Google service accounts
find "$DEV_DIR" -name "google-service-account.json" \
    -not -path "*/node_modules/*" \
    | while read -r f; do copy_file "$f"; done

# secrets.json files
find "$DEV_DIR" -name "secrets.json" \
    -not -path "*/node_modules/*" \
    | while read -r f; do copy_file "$f"; done

# Any other common secret file patterns
find "$DEV_DIR" \
    \( -name "serviceAccountKey.json" -o -name "firebase-adminsdk*.json" \) \
    -not -path "*/node_modules/*" \
    | while read -r f; do copy_file "$f"; done

###############################################################################
# 3. Per-project AI tool configs                                              #
###############################################################################

echo "\n── Per-project AI configs ──"

# Claude Code project settings
find "$DEV_DIR" -name "settings.local.json" -path "*/.claude/*" \
    -not -path "*/node_modules/*" \
    | while read -r f; do copy_file "$f"; done

# Cursor project MCP configs
find "$DEV_DIR" -name "mcp.json" -path "*/.cursor/*" \
    -not -path "*/node_modules/*" \
    | while read -r f; do copy_file "$f"; done

# Root-level .mcp.json files
find "$DEV_DIR" -maxdepth 3 -name ".mcp.json" \
    -not -path "*/node_modules/*" \
    | while read -r f; do copy_file "$f"; done

###############################################################################
# 4. Global CLI credentials                                                   #
###############################################################################

echo "\n── Global CLI credentials ──"

[ -d "$HOME/.aws" ]                          && copy_dir "$HOME/.aws"
[ -f "$HOME/.config/stripe/config.toml" ]   && copy_file "$HOME/.config/stripe/config.toml"
[ -f "$HOME/.claude/settings.json" ]        && copy_file "$HOME/.claude/settings.json"

###############################################################################
# 5. Shell history                                                            #
###############################################################################

echo "\n── Shell history ──"
[ -f "$HOME/.zsh_history" ] && copy_file "$HOME/.zsh_history"

###############################################################################
# 6. Brand assets (not in git, not easily regenerated)                       #
###############################################################################

echo "\n── Brand assets ──"
if [ -d "$DEV_DIR/ai/mfa-mal-anders/brand_assets" ]; then
    copy_dir "$DEV_DIR/ai/mfa-mal-anders/brand_assets"
fi

###############################################################################
# 7. Manifest                                                                 #
###############################################################################

find "$BACKUP_DIR" -type f | sed "s|$BACKUP_DIR/||" | sort > "$BACKUP_DIR/MANIFEST.txt"
echo "\nFiles collected:"
cat "$BACKUP_DIR/MANIFEST.txt"

###############################################################################
# 8. Encrypt as zip                                                           #
###############################################################################

echo "\nCreating encrypted zip at $ARCHIVE..."
echo "You will be prompted for a password — store it in KeePassXC."
zip -er "$ARCHIVE" "$BACKUP_DIR"

rm -rf "$BACKUP_DIR"

echo ""
echo "============================================================"
echo "  Backup created: $ARCHIVE"
echo "  Store securely (KeePassXC attachment, Google Drive, USB)."
echo "  DELETE the zip after restoring it on the new Mac."
echo "============================================================"
echo ""
echo "  Reminder: ~/Documents/ and ~/DEV/ai/generated-images/"
echo "  are NOT included — back those up separately if needed."
echo "============================================================"
