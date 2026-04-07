# dotfiles

Personal macOS development environment setup for Apple Silicon Macs.

Automates everything: system preferences, Homebrew packages & apps, shell configuration (zsh + oh-my-zsh + powerlevel10k), SSH key setup, and VS Code / Cursor extensions.

> **Note:** These are highly personalized to my own workflow. Fork and adapt rather than running as-is.

---

## Quick Start (new Mac)

```bash
# 1. Install Xcode Command Line Tools (provides git before Homebrew)
xcode-select --install

# 2. Clone
git clone https://github.com/christopherliedtke/dotfiles.git ~/dotfiles

# 3. Run
cd ~/dotfiles && ./install.sh
```

See [MIGRATION.md](MIGRATION.md) for the full step-by-step guide including what to export from your old Mac first.

---

## What's Included

### Scripts

| Script | Purpose |
|--------|---------|
| `install.sh` | Main entry point — runs all steps in order |
| `macOS.sh` | System preferences (trackpad, dock, finder, energy, etc.) |
| `brew.sh` | Homebrew formulae, apps, fonts, Oh My Zsh, nodenv, git config |
| `ssh.sh` | SSH key generation + GitHub upload via `gh` CLI |
| `vscode.sh` | Extensions + settings for VS Code and Cursor |

### Shell

| File | Purpose |
|------|---------|
| `.zshrc` | Main shell config — oh-my-zsh, powerlevel10k, zsh plugins, nodenv, pnpm |
| `.zprofile` | Login shell — Homebrew PATH |
| `.aliases` | Shortcuts for git, ls, brew, Finder, screencasting, Python venvs |
| `.p10k.zsh` | Powerlevel10k prompt config |
| `.private` | Local secrets, not tracked (create manually) |

### Settings

| File | Purpose |
|------|---------|
| `settings/VSCode-Settings.json` | VS Code / Cursor editor settings |
| `settings/VSCode-Keybindings.json` | VS Code / Cursor keybindings |
| `settings/iTerm2-Profile.json` | iTerm2 profile (auto-installed via DynamicProfiles) |
| `settings/Raycast.rayconfig` | Raycast settings export |

---

## Key Tools Installed

**CLI:** zsh, git, gh, python, nodenv, pnpm, uv, ripgrep, awscli, stripe, mongosh, redis, mas

**Apps:** Cursor, VS Code, iTerm2, cmux, Chrome, Zen Browser, Raycast, Slack, Figma, Postman, Bruno, Joplin, Asana, Spark, KeePassXC, Spotify, and more

**Fonts:** Meslo LG Nerd Font (for powerlevel10k), Source Code Pro

---

## Acknowledgments

Originally forked from [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles).

## License

MIT — see [LICENSE-MIT.txt](LICENSE-MIT.txt)
