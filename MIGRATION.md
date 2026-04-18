# macOS Migration Guide

Complete manual for setting up a new MacBook from this dotfiles repo.

---

## Before You Start (on the OLD Mac)

### 1. Push the latest dotfiles
```bash
cd ~/dotfiles
git add -A && git commit -m "Update dotfiles before migration"
git push
```

### 2. Export Raycast settings
Raycast settings are encrypted and can only be exported from within the app:

**Raycast → Settings → Advanced → Export**

Save the `.rayconfig` file to `~/dotfiles/settings/Raycast.rayconfig`, then commit:
```bash
mv ~/Desktop/Raycast.rayconfig ~/dotfiles/settings/
git add settings/Raycast.rayconfig
git commit -m "Add Raycast backup"
git push
```

### 3. Back up secrets and dev project files
Run the backup script — it collects all `.env` files plus CLI credentials into an encrypted zip:
```bash
cd ~/dotfiles && ./backup-envs.sh
```
Store the resulting zip securely (KeePassXC attachment or USB stick). Delete it after copying to the new Mac.

### 4. Back up anything else not in this repo
- Browser bookmarks — export from Chrome/Zen
- KeePassXC database — should already be in Google Drive
- Joplin notes — sync first from within the Joplin app
- SSH keys — optional, the setup script creates a fresh one

---

## Step 1 – Bootstrap the new Mac

> **Do I need to install git first?**
> Yes — but macOS makes it easy. Running `xcode-select --install` installs the Xcode Command Line Tools, which includes `git` at `/usr/bin/git`. You need to do this before cloning. Homebrew's git gets installed later by `brew.sh`.

Open Terminal on the new Mac and run:

```bash
# Step 1: Install Xcode Command Line Tools (includes git, compilers, etc.)
xcode-select --install
# A dialog appears — complete the install, then continue.

# Step 2: Clone dotfiles
git clone https://github.com/christopherliedtke/dotfiles.git ~/dotfiles

# Step 3: Run the full setup
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

That single command runs all steps below automatically.

---

## Step 2 – macOS System Preferences (`macOS.sh`)

```bash
./macOS.sh
```

Configures system preferences automatically:
- Trackpad: tap-to-click, no natural scroll, fast key repeat
- Locale: German (de_DE), timezone: Europe/Berlin
- Finder: show extensions, path bar, list view
- Dock: autohide, 36px icons, no recent apps
- Screen: require password immediately, PNG screenshots
- Energy: 15 min display sleep, no sleep while charging
- Keyboard: disable autocorrect, smart quotes, smart dashes

Requires `sudo` for some settings. Kills Dock, Finder, and SystemUIServer at the end to apply.

---

## Step 3 – Homebrew + Apps (`brew.sh`)

```bash
./brew.sh
```

### CLI formulae

| Tool | Purpose |
|------|---------|
| `zsh`, `coreutils`, `wget`, `ripgrep`, `trash` | Shell & utilities |
| `zsh-syntax-highlighting` | Zsh plugin |
| `zsh-autosuggestions` | Zsh plugin |
| `zsh-history-substring-search` | Zsh plugin |
| `powerlevel10k` | Zsh theme |
| `git`, `gh` | Version control + GitHub CLI |
| `python`, `nodenv`, `node-build` | Languages |
| `uv` | Fast Python package manager |
| `pnpm` | Node package manager |
| `awscli`, `stripe` | Cloud & services |
| `mongosh`, `mongodb-database-tools`, `redis` | Databases |
| `ollama`, `opencode`, `gemini-cli`, `agent-browser` | AI tools |
| `bfg`, `git-filter-repo` | Git history rewriting |
| `coderabbit` | AI code review CLI |
| `openssl@3` | Security |
| `mas` | Mac App Store CLI |

### macOS apps (casks)

| App | Purpose |
|-----|---------|
| Google Chrome | Browser |
| Zen Browser | Browser (Firefox-based) |
| Helium Browser | Floating browser window |
| VS Code | Editor |
| Cursor | AI-first editor (primary IDE) |
| iTerm2 | Terminal |
| cmux | Terminal multiplexer manager |
| Postman | API testing |
| Bruno | API client |
| Claude Code | AI coding assistant |
| Asana | Project management |
| Joplin | Notes |
| Microsoft Office | Office suite |
| Figma | Design |
| Spotify | Music |
| Raycast | Launcher + window management |
| Google Drive | File sync |
| CheatSheet | Keyboard shortcut helper |
| KeePassXC | Password manager |
| Tor Browser | Private browsing |
| Slack | Team communication |

### Fonts

| Font | Purpose |
|------|---------|
| `font-meslo-lg-nerd-font` | Required for powerlevel10k + iTerm2 profile |
| `font-source-code-pro` | Developer font |

### Also does automatically
- Sets Homebrew zsh as default shell
- Installs Oh My Zsh
- Sets Node 22 LTS as global via nodenv
- Sets git global config (name, email, `defaultBranch: main`, `ignoreCase: false`)
- Creates Python venv at `~/venvs/tutorial`
- Installs `prettier` globally via npm

---

## Step 4 – SSH Key Setup (`ssh.sh`)

```bash
./ssh.sh
```

- Generates a new `ed25519` SSH key at `~/.ssh/id_ed25519`
- Creates `~/.ssh/config` with `AddKeysToAgent yes` + `UseKeychain yes`
- Adds key to macOS Keychain
- Copies public key to clipboard
- Authenticates `gh` CLI and uploads key to GitHub
- Tests the connection with `ssh -T git@github.com`

> If you want to reuse an existing SSH key, copy `id_ed25519` and `id_ed25519.pub` to `~/.ssh/` before running this script — it will skip generation.

---

## Step 5 – iTerm2 Profile

Applied automatically by `install.sh` via iTerm2's DynamicProfiles mechanism.

After install:
1. Open iTerm2
2. Go to **Preferences → Profiles**
3. Select the **dotfiles** profile and click **Other Actions → Set as Default**

The profile uses `MesloLGS NF` font (installed by `brew.sh` as `font-meslo-lg-nerd-font`) which is required for powerlevel10k glyphs to render correctly.

---

## Step 6 – VS Code + Cursor (`vscode.sh`)

```bash
./vscode.sh
```

Installs extensions in **both VS Code and Cursor**:

| Extension | Purpose |
|-----------|---------|
| `anthropic.claude-code` | AI coding |
| `highagency.pencildev` | AI design tool |
| `eamodio.gitlens` | Git superpowers |
| `github.vscode-github-actions` | GitHub Actions |
| `esbenp.prettier-vscode` | Code formatting |
| `dbaeumer.vscode-eslint` | Linting |
| `biomejs.biome` | Fast linter & formatter |
| `aaron-bond.better-comments` | Comment highlighting |
| `formulahendry.auto-rename-tag` | HTML tag rename |
| `bradlc.vscode-tailwindcss` | Tailwind CSS |
| `zignd.html-css-class-completion` | CSS class IntelliSense |
| `wix.vscode-import-cost` | Show import sizes |
| `yoavbls.pretty-ts-errors` | Readable TS errors |
| `cardinal90.multi-cursor-case-preserve` | Multi-cursor case |
| `prisma.prisma` | Prisma ORM |
| `shd101wyy.markdown-preview-enhanced` | Markdown preview |
| `unifiedjs.vscode-mdx` | MDX support |
| `mongodb.mongodb-vscode` | MongoDB |
| `mechatroner.rainbow-csv` | CSV highlighting |
| `christian-kohler.path-intellisense` | Path autocomplete |
| `kisstkondoros.vscode-gutter-preview` | Image preview in gutter |
| `ritwickdey.liveserver` | Local dev server |
| `mikestead.dotenv` | .env syntax |
| `dakshmiglani.hex-to-rgba` | Color conversion |
| `sdras.night-owl` | Theme |
| `pkief.material-icon-theme` | File icons |

Also copies `settings/VSCode-Settings.json` and `settings/VSCode-Keybindings.json` to both editors.

After install: sign in to extensions that require authentication inside VS Code or Cursor.

---

## Step 7 – Shell Configuration

The following dotfiles are symlinked to `~/` by `install.sh`:

| File | Purpose |
|------|---------|
| `.zshrc` | Main shell config (oh-my-zsh, plugins, nodenv, pnpm) |
| `.zprofile` | Login shell (Homebrew PATH) |
| `.aliases` | All shell aliases |
| `.p10k.zsh` | Powerlevel10k prompt config |
| `.private` | Local secrets (not in git — create manually) |

### `.private` file

Not in the repo. Create `~/.private` for secrets loaded in the shell:

```bash
# ~/.private  (never committed to git)
export OPENAI_API_KEY="..."
export ANTHROPIC_API_KEY="..."
```

---

## Step 8 – Manual Steps After Scripts

### Raycast
1. Open Raycast and grant **Accessibility permissions** when prompted
2. **Raycast → Settings → Advanced → Import**
3. Select `~/dotfiles/settings/Raycast.rayconfig`

### Google Drive
Sign in and let it sync before accessing Drive-dependent files (YouTube Scripts folder, etc.)

### Apps to sign in to manually
- Google Chrome (sync bookmarks, extensions)
- Spotify
- Joplin (sync notes)
- Asana
- Figma
- Slack (add workspaces)
- Microsoft Office (activate license)
- KeePassXC (open database from Google Drive)

---

## Keeping Dotfiles Updated

Shell files (`.zshrc`, `.aliases`, etc.) are symlinks — any changes are automatically reflected. Just commit:

```bash
cd ~/dotfiles
git add -A && git commit -m "Update dotfiles"
git push
```

For settings that need manual syncing:

```bash
# VS Code / Cursor settings
cp "$HOME/Library/Application Support/Code/User/settings.json" ~/dotfiles/settings/VSCode-Settings.json
cp "$HOME/Library/Application Support/Code/User/keybindings.json" ~/dotfiles/settings/VSCode-Keybindings.json

# p10k prompt
cp ~/.p10k.zsh ~/dotfiles/.p10k.zsh

# iTerm2 profile (after changes in Preferences)
python3 -c "
import plistlib, json
with open('$HOME/Library/Preferences/com.googlecode.iterm2.plist', 'rb') as f:
    plist = plistlib.load(f)
profiles = plist.get('New Bookmarks', [])
def convert(obj):
    if isinstance(obj, bytes): return obj.hex()
    if isinstance(obj, dict): return {k: convert(v) for k, v in obj.items()}
    if isinstance(obj, list): return [convert(i) for i in obj]
    return obj
with open('$HOME/dotfiles/settings/iTerm2-Profile.json', 'w') as f:
    json.dump(convert({'Profiles': profiles}), f, indent=2)
print('iTerm2 profile exported')
"

# Raycast settings (from Raycast app)
# Raycast → Settings → Advanced → Export → save to ~/dotfiles/settings/Raycast.rayconfig

git add -A && git commit -m "Update settings"
git push
```

---

## Aliases Reference

| Alias | Command |
|-------|---------|
| `g` | `git` |
| `la` | `ls -lahF` (all files, colored) |
| `ch` | Search git commit history |
| `hg` | Search command history |
| `update_system` | macOS software update |
| `update_brew` | Homebrew update + cleanup |
| `show` / `hide` | Toggle hidden files in Finder |
| `tut_mode` | Prep desktop for screencasting |
| `reg_mode` | Restore normal desktop |
| `clean` | Empty Trash + Downloads |
| `tut_env` | Activate Python tutorial venv |
| `wipe_env` | Recreate Python tutorial venv |
| `yt` / `cyt` / `oyt` | YouTube Scripts folder shortcuts |

---

## Dev Projects Migration

Everything below lives outside the dotfiles repo and must be handled manually.

### Dev projects (the code)

Your projects are already in git — just clone them on the new Mac:

```bash
mkdir -p ~/DEV/projects ~/DEV/ai ~/DEV/mcp-servers
cd ~/DEV/projects
git clone git@github.com:christopherliedtke/mfa-mal-anders-nextjs.git
# repeat for each project
```

Use `gh repo list christopherliedtke --limit 50` to get a full list of your repos.

### Gitignored files — full inventory

The `backup-envs.sh` script captures everything below. Run it on the old Mac, then restore from the zip on the new one.

```bash
# Old Mac — create the backup
cd ~/dotfiles && ./backup-envs.sh
# → produces ~/Desktop/env-backup-YYYY-MM-DD.zip (password-protected)

# New Mac — restore
unzip ~/Desktop/env-backup-YYYY-MM-DD.zip -d /tmp/env-restore
# then copy files as described below
rm -rf /tmp/env-restore   # clean up when done
```

#### .env files (23 across projects)

| Project | Files |
|---------|-------|
| `mfa-mal-anders-nextjs` | `.env.local`, `.env.test`, `bru_mfa-mal-anders/.env` |
| `mfa-mal-anders-vuejobboard` | `.env`, `.env.dev`, `.env.local`, `client/.env.*.local` |
| `zfa-mal-anders` | `.env.development`, `.env.local`, `.env.production`, `.env.test`, `bru_zfa-mal-anders/.env` |
| `arzt-mal-anders-vuejobboard` | `.env` |
| `praxis-website-builder` | `.env` |
| `maurerwerk-leipzig` | `.env.local` |
| `sexpiration` | `.env` |
| `ZuckerRede.de` | `.env` |
| `DEV/ai/mfa-mal-anders` | `.env` |

After cloning each project, copy its env files back:
```bash
cp -r /tmp/env-restore/DEV/projects/mfa-mal-anders-nextjs/.env* \
      ~/DEV/projects/mfa-mal-anders-nextjs/
# repeat per project
```

#### Credential files (gitignored, not .env)

| File | What it is |
|------|------------|
| `DEV/ai/mfa-mal-anders/google-service-account.json` | Google Cloud service account key |
| `DEV/projects/CarCheckApp/utils/secrets.json` | AWS + MongoDB credentials |

Restore:
```bash
cp /tmp/env-restore/DEV/ai/mfa-mal-anders/google-service-account.json \
   ~/DEV/ai/mfa-mal-anders/
cp /tmp/env-restore/DEV/projects/CarCheckApp/utils/secrets.json \
   ~/DEV/projects/CarCheckApp/utils/
```

#### Per-project AI tool configs

| File | What it is |
|------|------------|
| `*/.claude/settings.local.json` | Claude Code project-level settings |
| `*/.cursor/mcp.json` | Cursor project-level MCP servers |
| `*/.mcp.json` | Shared MCP server definitions |

Restore:
```bash
# For each project — example:
mkdir -p ~/DEV/projects/mfa-mal-anders-nextjs/.claude
cp /tmp/env-restore/DEV/projects/mfa-mal-anders-nextjs/.claude/settings.local.json \
   ~/DEV/projects/mfa-mal-anders-nextjs/.claude/
```

### Global CLI credentials

| Credential | Location | How to restore |
|------------|----------|----------------|
| AWS | `~/.aws/` | `cp -r /tmp/env-restore/.aws ~/; chmod 600 ~/.aws/credentials` |
| Stripe | `~/.config/stripe/config.toml` | `mkdir -p ~/.config/stripe && cp /tmp/env-restore/.config/stripe/config.toml ~/.config/stripe/` |
| Claude Code | `~/.claude/settings.json` | `cp /tmp/env-restore/.claude/settings.json ~/.claude/` |
| GitHub CLI | macOS Keychain (can't transfer) | Re-run `gh auth login` — handled by `ssh.sh` |

Verify AWS: `aws sts get-caller-identity`
Verify Stripe: `stripe config --list`

### AI tool configs (non-secret, in dotfiles)

`install.sh` restores these automatically:
- `~/.config/opencode/config.json` — opencode + ollama setup
- `~/.cursor/mcp.json` — global Cursor MCP servers (next-devtools, context7)

### Agent skills (Claude Code & Cursor)

**Local skills** — copy from backup:
```bash
# Claude Code skills
mkdir -p ~/.claude/skills
for skill in pdf-to-job-html react-doctor skill-creator stage-commit-pr vercel-react-best-practices web-design-guidelines; do
  cp -r /tmp/env-restore/.claude/skills/$skill ~/.claude/skills/
done
cp /tmp/env-restore/.claude/skills/pdf-to-job-html.skill ~/.claude/skills/

# Cursor skills
mkdir -p ~/.cursor/skills
for skill in react-doctor vercel-react-best-practices web-design-guidelines; do
  cp -r /tmp/env-restore/.cursor/skills/$skill ~/.cursor/skills/
done
```

**Registry skills** (symlinked, can't transfer) — reinstall via `/find-skills` in Claude Code:
- `agent-browser`, `docx`, `find-skills`, `frontend-design`, `git-commit`, `word-document-processor`

### Shell history

Included in backup. Restore:
```bash
cp /tmp/env-restore/.zsh_history ~/.zsh_history
```
Open a new terminal tab to load it.

### Node versions (nodenv)

`brew.sh` installs Node 22 LTS. Reinstall older versions as needed:
```bash
nodenv install 20.10.0
nodenv install 18.17.0
# check each project's .nvmrc or .node-version
```

### pnpm global packages

Installed automatically by `brew.sh`: `vercel`, `eslint`, `@agentmail/cli`, `agentmail-cli`

### Python virtual environments

`.venv` directories are not backed up — recreate them per project:
```bash
cd ~/path/to/python-project
uv sync   # or: python3 -m venv .venv && pip install -r requirements.txt
```

### cmux workspaces

cmux session state is local and won't transfer. Re-create workspaces manually after cloning your projects. Your current workspaces to recreate:

| Workspace | Project |
|-----------|---------|
| MfaMalAnders_Code | `~/DEV/projects/mfa-mal-anders-nextjs` |
| _(others)_ | Re-create from your project list |

---

## Local System Files

Things that live on your Mac outside of git repos and aren't covered by the scripts above.

### ~/Documents

Contains personal and business files (invoices, registrations, PDFs, etc.). These are **not** synced to iCloud or Google Drive automatically.

**Back up before migrating:**
```bash
# Copy to Google Drive manually, or to an external drive:
cp -r ~/Documents ~/Google\ Drive/My\ Drive/Documents-Backup-$(date +%Y-%m-%d)
```

Or use AirDrop / Migration Assistant to transfer directly to the new Mac.

### ~/Pictures (1.3 GB)

Contains project image assets and your Photos library. **Not synced anywhere automatically.**

| Folder | Content |
|--------|---------|
| `01. mfa_mal_anders` | MFA mal anders brand/media assets |
| `02. arzt_mal_anders` | Arzt mal anders brand/media assets |
| `03. zfa_mal_anders` | ZFA mal anders brand/media assets |
| `zuckerrede`, `stadt_und_gruen` | Project assets |
| `ChristopherLiedtke` | Personal photos/portraits |
| `campermoments` | Personal photos |
| `Photos Library.photoslibrary` | macOS Photos app library |
| `Screenshots` | Probably skippable |

**Back up before migrating:**
```bash
# Copy the whole folder to Google Drive
cp -r ~/Pictures ~/Google\ Drive/My\ Drive/Pictures-Backup-$(date +%Y-%m-%d)
```

Or use AirDrop / an external drive for the Photos library (it can be large).

> **Note:** If you use iCloud Photos, the Photos library syncs automatically — check in System Settings → iCloud → Photos.

### ~/DEV/ai/mfa-mal-anders/generated-images

AI-generated images (~20+ files). Not in git, not in Google Drive.
Either push them to Google Drive or accept they can be regenerated.

```bash
cp -r ~/DEV/ai/mfa-mal-anders/generated-images \
      ~/Google\ Drive/My\ Drive/mfa-mal-anders-generated-images
```

### ~/dump.rdb

Redis persistence file in your home directory (88B — essentially empty).
Not worth migrating; Redis will create a fresh one on the new Mac.

### macOS Keychain

iCloud Keychain is enabled — passwords, wifi passwords, and certificates sync automatically to the new Mac as soon as you sign in with your Apple ID. Nothing to do here.

Items that still need re-authentication regardless (tokens, not passwords):
- GitHub CLI (`gh auth login`)
- Stripe CLI (restored from backup)
- Any browser-saved passwords (sync via Chrome or export from Safari)

### Apple ID / iCloud

Sign in with your Apple ID first thing on the new Mac. This restores:
- App Store purchases and apps
- iCloud Keychain (if enabled)
- iCloud Drive files (if you use it)

### App-specific data that auto-syncs via Google Drive

| App | Sync mechanism |
|-----|----------------|
| KeePassXC database | Google Drive (open from Drive path) |
| Joplin notes | Joplin's built-in sync |
| Google Drive files | Re-sign in to Google Drive app |

### Superwhisper / Wispr Flow

These AI dictation apps store settings locally. Re-configure them after installing — no migration needed for settings, they're minimal.

### NordVPN

Re-login with your NordVPN account credentials after installing.

---

## M1 Pro → M5 Pro: Hardware Differences

Your current machine is a **MacBook Pro 14" M1 Pro (2021)** (`MacBookPro18,3`, 8-core CPU, 16 GB RAM, 500 GB SSD). The target is the **MacBook Pro 14" M5 Pro (2026)**.

### What changes

| | M1 Pro (current) | M5 Pro (new) |
|---|---|---|
| CPU | 8-core (6P+2E) | 15-core (5 super-P + 10P) |
| GPU | 14-core | 16–20-core |
| RAM (your config) | 16 GB | up to 64 GB |
| Memory bandwidth | 200 GB/s | 273 GB/s |
| Thunderbolt | 3× TB4 (40 Gb/s) | 3× TB5 (120 Gb/s) |
| HDMI | 2.0 (4K@60Hz) | 2.1 (4K@240Hz / 8K@60Hz) |
| External displays | 2 max | 3 max |
| MagSafe | MagSafe 3 | MagSafe 3 (same plug, faster 140W) |
| Wi-Fi | Wi-Fi 6 | Wi-Fi 7 |
| macOS (ships with) | macOS 12 Monterey | macOS 26.3 Tahoe |

### What this means for your developer setup

**Zero recompilation needed.** M1 Pro and M5 Pro share the same ARM64 ISA. Every native arm64 binary — Homebrew bottles, Node.js, Python wheels, compiled npm packages (esbuild, swc, sharp), Cursor/VS Code extensions — runs identically on M5 Pro without any changes or rebuilds.

**Your dotfiles scripts work as-is.** `install.sh`, `brew.sh`, `vscode.sh` — all unchanged.

**Thunderbolt 5 is backwards-compatible.** Your existing TB4 hub/dock/cable works at TB4 speeds. You only need new TB5 hardware to use the higher bandwidth or drive a third external display.

**Your MagSafe cable is the same.** The MagSafe 3 connector hasn't changed; the new 140W charger is faster but your existing adapter works.

### Rosetta 2 audit — do this before migrating

macOS 26.4 now actively warns you when you launch an Intel-only (x86_64) binary. macOS 27 (late 2026) will be the last to support Rosetta 2; macOS 28 drops it.

Check if you have any lingering Intel-only tools:
```bash
# Find x86_64-only apps in /Applications
find /Applications -name "Info.plist" -exec grep -l "x86_64" {} \; 2>/dev/null

# Or use the free "Silicon" app from the Mac App Store for a visual audit
```

For your developer toolchain specifically:
```bash
# Verify your key binaries are arm64 (not x86_64)
file $(which brew) $(which node) $(which python3) $(which git)
# All should say: Mach-O 64-bit executable arm64
```

If any show `x86_64`, that means they were installed under Rosetta — reinstall natively before migrating.

### Docker
Docker Desktop works identically. `linux/arm64` images run natively. `linux/amd64` images still use Rosetta 2 emulation ("Use Rosetta" toggle in Docker settings) — this continues to work on M5 Pro for now but will stop working when Rosetta 2 is removed. Prefer arm64 images where possible.

---

## Common Migration Pitfalls

Things that commonly go wrong for developers migrating to a new Mac — especially on Apple Silicon / macOS Sequoia.

### Terminal running under Rosetta (silent architecture contamination)

**The most dangerous mistake.** If your terminal is set to "Open using Rosetta", every tool you install (Homebrew, Node, Python) installs as x86_64 instead of arm64. Everything appears to work but performance is worse and some tools silently misbehave.

`install.sh` checks this automatically, but verify manually:
```bash
uname -m          # must return: arm64
file $(which brew) # must contain: arm64
file $(which node) # must contain: arm64
```

If Activity Monitor shows the terminal process as Kind: "Intel" instead of "Apple", that's Rosetta mode. Fix: close the terminal, Get Info on the app, uncheck "Open using Rosetta".

### Full Disk Access not granted to terminals

macOS TCC blocks Terminal, iTerm2, Cursor, and VS Code integrated terminals from reading `~/Documents`, `~/Desktop`, `~/Downloads`, and other protected paths without explicit permission.

**System Settings → Privacy & Security → Full Disk Access → enable iTerm2, Cursor, VS Code**

This is per-app — granting it to iTerm2 does NOT apply to Cursor's terminal. Do all three.
Without it, file operations in integrated terminals fail silently or with confusing "Operation not permitted" errors.

### Xcode CLT breaks after every macOS major update

After upgrading macOS (e.g. 14→15), `git`, `make`, `clang`, and `brew update` all break with:
```
xcrun: error: invalid active developer path
```
Fix: `xcode-select --install` — you need to re-run this after every major macOS version bump, not just on a new machine.

### SSH key permissions wrong after restore

If you restore `~/.ssh/` from the backup zip, the permissions must be exact or SSH silently refuses to use the keys:
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 600 ~/.ssh/config
```
Verify with: `ssh -T git@github.com` — should say "Hi username!"

### SSH keys not persisting across reboots (macOS Sequoia)

Sequoia changed how the SSH agent interacts with the Keychain. After a reboot, keys may not be loaded. The `~/.ssh/config` in your dotfiles already has `UseKeychain yes` and `AddKeysToAgent yes` which handles this — but if git suddenly asks for a passphrase, re-add the key:
```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

### nodenv globals lost after installing a new Node version

Each Node version managed by nodenv has its own isolated global package directory. Installing a new version and setting it as global means all previous globals (eslint, prettier, vercel, etc.) are gone from that version.

`brew.sh` handles the initial install, but if you add a new nodenv version later:
```bash
nodenv install 20.10.0
nodenv global 20.10.0
npm install -g prettier vercel eslint  # reinstall globals
```

### pnpm + Homebrew + Corepack conflict

`brew install pnpm` and `corepack enable` both try to manage the `pnpm` binary and conflict. Your setup installs pnpm via Homebrew — do NOT run `corepack enable pnpm` or it will fight with the Homebrew version. Stick to one or the other.

### Gatekeeper blocks unsigned CLI tools (Sequoia)

In Sequoia, `spctl --master-disable` no longer fully disables Gatekeeper. Unsigned binaries downloaded from GitHub releases must be approved individually:

**System Settings → Privacy & Security → scroll to bottom → "Open Anyway"**

This cannot be scripted. Tools installed via Homebrew are notarized and not affected.

### macOS Sequoia 15.0 broke VPN and networking tools

The initial Sequoia 15.0 release broke VPN clients and security tools (NordVPN, CrowdStrike, etc.) due to networking stack changes. **Update to 15.0.1 or later before starting the migration setup** — otherwise NordVPN and other network tools may silently fail after install.

```bash
# Check your macOS version before starting:
sw_vers -productVersion
# Should be 15.0.1 or higher
```

### VS Code / Cursor integrated terminal doesn't source `.zprofile`

Cursor and VS Code open terminals as interactive non-login shells — `.zprofile` is not sourced. Your `.zshrc` already handles this correctly (all PATH inits are in `.zshrc`), but if you ever notice `brew`, `node`, or `python3` not found in the integrated terminal, this is why.

---

## Troubleshooting

**Homebrew not found after install:**
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

**nodenv not found:**
```bash
eval "$(nodenv init -)"
```

**Oh My Zsh overwrites .zshrc:**
Re-create the symlink after Oh My Zsh install:
```bash
ln -sf ~/dotfiles/.zshrc ~/.zshrc
```

**p10k prompt not appearing:**
```bash
source ~/.p10k.zsh
# or reconfigure from scratch:
p10k configure
```

**SSH key not accepted by GitHub:**
```bash
ssh -T git@github.com       # Should say: "Hi username!"
ssh-add ~/.ssh/id_ed25519   # Re-add key to agent if needed
```

**`gh` CLI not authenticated:**
```bash
gh auth login
```

**Permissions error in macOS.sh:**
```bash
sudo -v  # prime sudo, then re-run
```
