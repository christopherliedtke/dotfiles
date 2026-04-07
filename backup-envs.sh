#!/usr/bin/env zsh

###############################################################################
# backup-envs.sh
#
# Run this on your OLD Mac before migrating.
# Collects all .env files from ~/DEV and CLI credentials into a single
# encrypted zip. Store the zip in KeePassXC, Google Drive, or a USB stick.
###############################################################################

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
BACKUP_DIR="/tmp/env-backup-$TIMESTAMP"
ARCHIVE="$HOME/Desktop/env-backup-$TIMESTAMP.zip"
DEV_DIR="$HOME/DEV"

echo "Creating backup directory at $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

###############################################################################
# 1. .env files from dev projects                                             #
###############################################################################

echo "Collecting .env files from $DEV_DIR..."

find "$DEV_DIR" \
    -name ".env*" \
    -not -path "*/node_modules/*" \
    -not -path "*/.git/*" \
    -not -name "*.example" \
    | while read -r file; do
        # Preserve directory structure inside backup
        relative="${file#$HOME/}"
        target="$BACKUP_DIR/$relative"
        mkdir -p "$(dirname "$target")"
        cp "$file" "$target"
        echo "  + $relative"
    done

###############################################################################
# 2. AWS credentials                                                          #
###############################################################################

if [ -d "$HOME/.aws" ]; then
    echo "Copying ~/.aws..."
    cp -r "$HOME/.aws" "$BACKUP_DIR/.aws"
fi

###############################################################################
# 3. Stripe CLI config                                                        #
###############################################################################

if [ -f "$HOME/.config/stripe/config.toml" ]; then
    echo "Copying Stripe config..."
    mkdir -p "$BACKUP_DIR/.config/stripe"
    cp "$HOME/.config/stripe/config.toml" "$BACKUP_DIR/.config/stripe/config.toml"
fi

###############################################################################
# 4. Shell history                                                            #
###############################################################################

if [ -f "$HOME/.zsh_history" ]; then
    echo "Copying zsh history..."
    cp "$HOME/.zsh_history" "$BACKUP_DIR/.zsh_history"
fi

###############################################################################
# 5. Manifest                                                                 #
###############################################################################

find "$BACKUP_DIR" -type f | sed "s|$BACKUP_DIR/||" | sort > "$BACKUP_DIR/MANIFEST.txt"
echo ""
echo "Files collected:"
cat "$BACKUP_DIR/MANIFEST.txt"

###############################################################################
# 6. Encrypt as zip                                                           #
###############################################################################

echo ""
echo "Creating encrypted zip at $ARCHIVE..."
echo "You will be prompted for a password — store it in KeePassXC."
zip -er "$ARCHIVE" "$BACKUP_DIR"

# Clean up temp dir
rm -rf "$BACKUP_DIR"

echo ""
echo "============================================================"
echo "  Backup created: $ARCHIVE"
echo "  Store it securely (KeePassXC attachment, Google Drive,"
echo "  or USB stick). DELETE it after copying to the new Mac."
echo "============================================================"
