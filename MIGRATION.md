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
| `mongosh`, `redis` | Databases |
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
| `github.copilot` + `copilot-chat` | AI coding |
| `eamodio.gitlens` | Git superpowers |
| `esbenp.prettier-vscode` | Code formatting |
| `dbaeumer.vscode-eslint` | Linting |
| `aaron-bond.better-comments` | Comment highlighting |
| `formulahendry.auto-rename-tag` | HTML tag rename |
| `bradlc.vscode-tailwindcss` | Tailwind CSS |
| `zignd.html-css-class-completion` | CSS class IntelliSense |
| `wix.vscode-import-cost` | Show import sizes |
| `yoavbls.pretty-ts-errors` | Readable TS errors |
| `cardinal90.multi-cursor-case-preserve` | Multi-cursor case |
| `alduncanson.react-hooks-snippets` | React hooks |
| `conrad-hunter.next-ts-snippets` | Next.js snippets |
| `graphql.vscode-graphql` + syntax | GraphQL |
| `mongodb.mongodb-vscode` | MongoDB |
| `alefragnani.project-manager` | Workspace switching |
| `sdras.night-owl` | Theme |
| `pkief.material-icon-theme` | File icons |
| + more | See `vscode.sh` |

Also copies `settings/VSCode-Settings.json` and `settings/VSCode-Keybindings.json` to both editors.

After install: sign in to **GitHub Copilot** inside VS Code or Cursor.

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

### .env files (the critical part)

`.env` files are gitignored and **will not** be in the cloned repos. You currently have 23 of them across `~/DEV`. The `backup-envs.sh` script (run on the old Mac) backs them all up.

On the new Mac, unzip the backup and copy them back:

```bash
# Unzip with the password you set during backup
unzip env-backup-YYYY-MM-DD.zip -d /tmp/env-restore

# Then for each project, copy the relevant .env files, e.g.:
cp /tmp/env-restore/DEV/projects/mfa-mal-anders-nextjs/.env.local \
   ~/DEV/projects/mfa-mal-anders-nextjs/

# Clean up when done
rm -rf /tmp/env-restore
```

Your projects and their env files:

| Project | Env files |
|---------|-----------|
| `mfa-mal-anders-nextjs` | `.env.local`, `.env.test`, `bru_mfa-mal-anders/.env` |
| `mfa-mal-anders-vuejobboard` | `.env`, `.env.dev`, `.env.local`, `client/.env.development.local`, `client/.env.production.local` |
| `zfa-mal-anders` | `.env.development`, `.env.local`, `.env.production`, `.env.test`, `bru_zfa-mal-anders/.env` |
| `arzt-mal-anders-vuejobboard` | `.env` |
| `praxis-website-builder` | `.env` |
| `maurerwerk-leipzig` | `.env.local` |
| `sexpiration` | `.env` |
| `ZuckerRede.de` | `.env` |
| `DEV/ai/mfa-mal-anders` | `.env` |

### AWS credentials

The backup script copies `~/.aws/`. On the new Mac, restore it:

```bash
cp -r /tmp/env-restore/.aws ~/
chmod 600 ~/.aws/credentials
```

Verify with: `aws sts get-caller-identity`

### Stripe CLI

The backup script copies `~/.config/stripe/config.toml`. On the new Mac:

```bash
mkdir -p ~/.config/stripe
cp /tmp/env-restore/.config/stripe/config.toml ~/.config/stripe/
```

Verify with: `stripe config --list`

### GitHub CLI (`gh`)

Re-authenticate on the new Mac — the token is stored in the macOS Keychain and won't transfer:

```bash
gh auth login
```

The `ssh.sh` script handles this automatically during setup.

### Node versions (nodenv)

`brew.sh` installs Node 22 LTS. If your projects need older versions, install them:

```bash
nodenv install 20.10.0
nodenv install 18.17.0
# etc. — check .nvmrc or .node-version in each project
```

### pnpm global packages

`brew.sh` reinstalls these automatically:
- `vercel`
- `eslint`
- `@agentmail/cli`
- `agentmail-cli`

### Shell history

The backup script includes `~/.zsh_history`. On the new Mac:

```bash
cp /tmp/env-restore/.zsh_history ~/.zsh_history
```

Open a new terminal tab to load it.

### cmux workspaces

cmux stores session state (open tabs, directories) locally — it won't transfer. You'll need to re-open your project workspaces manually after cloning. The workspace names and colors from your session:

| Workspace | Project |
|-----------|---------|
| MfaMalAnders_Code | `~/DEV/projects/mfa-mal-anders-nextjs` |
| _(others)_ | Re-create from your project list |

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
