# Debian + Tmux + Droid: Implementation Guide

## Overview

This repository contains a complete, portable implementation plan for setting up a persistent Tmux environment with Copilot CLI on Android using Termux and Debian (via proot-distro).

**Recommended architecture:** Ubuntu-on-Termux → Tmux → Debian

## Quick Start

### 1. Environment Detection

```bash
bash scripts/detect_env.sh
```

This identifies whether you're running in:
- **Debian** (default, recommended for automation)
- **Ubuntu-on-Termux** (more stable base)
- **Termux-native** (Android app)

### 2. Configure Tmux

```bash
# Copy template to your tmux config
cp scripts/tmux.conf.template ~/.tmux.conf

# View what it does:
cat scripts/tmux.conf.template
```

### 3. Add Session Naming Function

```bash
# Add to your shell RC file (~/.bashrc or ~/.zshrc):
cat scripts/session_wrapper.sh >> ~/.bashrc
source ~/.bashrc

# Use it:
tn my_session
```

### 4. Install Dependencies Manually (No auto-install)

See `docs/COPILOT_CLI_SETUP.md` for environment-specific installation steps.

**Required packages (vary by environment):**
- `tmux` — Terminal multiplexer
- `git` — Version control (for TPM)
- `curl` or `wget` — Download tools
- `nodejs` + `npm` — For Copilot CLI

### 5. Set Up TPM & Plugins

```bash
# Clone TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install plugins (requires tmux running or manual install):
~/.tmux/plugins/tpm/bin/install_plugins

# Or inside tmux: Prefix + I (capital i)
```

### 6. Enable Android Persistence

Follow `docs/ANDROID_PERSISTENCE.md`:
- [ ] Disable battery optimization for Termux
- [ ] Enable wake lock
- [ ] Configure tmux-continuum (auto-save every 15 min)

## Documentation

### Core Documentation
- **`specs/implementation_plan.md`** — Overall strategy and architecture
- **`spec1.md`** — Original metaprompt, Q&A, and architecture analysis

### Setup Guides
- **`docs/COPILOT_CLI_SETUP.md`** — Install and configure Copilot CLI
- **`docs/ANDROID_PERSISTENCE.md`** — Battery, wake lock, and session recovery
- **`docs/MIGRATION_PORTABILITY.md`** — Move configs between environments

## Scripts

### `scripts/detect_env.sh`
Detects the current environment (Debian, Ubuntu-on-Termux, Termux-native).

**Usage:**
```bash
bash scripts/detect_env.sh
# Output: Environment: Debian (debian)
```

### `scripts/tmux.conf.template`
Complete Tmux configuration with:
- TPM plugin manager
- tmux-resurrect (session capture)
- tmux-continuum (auto-save/restore)
- Vim keybindings
- Mouse support

**Usage:**
```bash
cp scripts/tmux.conf.template ~/.tmux.conf
```

### `scripts/session_wrapper.sh`
Shell function `tn` for creating/attaching named Tmux sessions.

**Features:**
- Prompts for session name if not provided
- Lists existing sessions to avoid duplicates
- Prevents special characters in names
- Validates before creation

**Usage:**
```bash
source scripts/session_wrapper.sh
tn my_session
```

## Environment Guide

### Ubuntu-on-Termux (Recommended)
- **Stability:** Higher than raw Termux
- **Setup:** Use ubuntu-specific package manager (`apt`)
- **Benefits:** Better isolation from Android, more familiar Linux environment
- **Trade-off:** One additional layer of nesting

### Termux-native
- **Stability:** Lower, but improving
- **Setup:** Use Termux package manager (`pkg`)
- **Benefits:** Direct Android integration, minimal nesting
- **Trade-off:** Inherit Termux limitations and bugs

### Debian (via proot-distro)
- **Stability:** High
- **Setup:** Can run in individual Tmux panes
- **Benefits:** Full Debian environment, compatibility with dev tools
- **Trade-off:** Performance overhead if nested too deeply

## Troubleshooting

### Sessions not persisting after device restart
See `docs/ANDROID_PERSISTENCE.md` — check battery optimization and wake lock.

### Tmux plugins not loading
```bash
# Reinstall TPM
rm -rf ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins
```

### Copilot CLI not found
See `docs/COPILOT_CLI_SETUP.md` — verify Node.js and npm are installed and in PATH.

### Config not portable between environments
See `docs/MIGRATION_PORTABILITY.md` — use environment detection and adjust paths.

## File Structure

```
Debian-tmux-droid/
├── docs/
│   ├── ANDROID_PERSISTENCE.md      # Battery, wake lock, session recovery
│   ├── COPILOT_CLI_SETUP.md         # Installation and integration
│   └── MIGRATION_PORTABILITY.md     # Cross-environment setup
├── scripts/
│   ├── detect_env.sh                # Environment detection
│   ├── tmux.conf.template           # Tmux configuration
│   └── session_wrapper.sh           # Session naming function
├── specs/
│   ├── implementation_plan.md       # Strategic plan
│   └── archive/spec1.md             # Original metaprompt
├── spec1.md                         # Main reference (Q&A history)
└── LICENSE
```

## Next Steps

1. **Choose your base environment** — Ubuntu-on-Termux or Termux-native
2. **Follow `docs/COPILOT_CLI_SETUP.md`** for manual installation
3. **Configure Tmux** using `scripts/tmux.conf.template`
4. **Add session wrapper** from `scripts/session_wrapper.sh`
5. **Enable persistence** via `docs/ANDROID_PERSISTENCE.md`
6. **Test and validate** — start sessions and verify auto-save/restore

## References

- [Tmux Documentation](https://github.com/tmux/tmux/wiki)
- [TPM (Tmux Plugin Manager)](https://github.com/tmux-plugins/tpm)
- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)
- [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum)
- [Termux App](https://termux.dev/)
- [GitHub Copilot CLI](https://github.com/github/copilot-cli)

## License

See `LICENSE` file for details.

---

**Note:** This setup prioritizes portability and documentation over automation. Manual steps are provided to ensure compatibility across diverse Android/Termux/Linux environments.
