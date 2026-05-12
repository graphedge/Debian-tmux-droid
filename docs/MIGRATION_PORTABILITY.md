# Migration & Portability Guide

## Overview
This guide explains how to migrate Tmux, TPM, and plugin configs between environments (Ubuntu-on-Termux ↔ Termux-native ↔ Debian).

## Configuration Portability

### What's Portable
- `.tmux.conf` — Settings are mostly universal
- TPM plugins (tmux-resurrect, tmux-continuum)
- Shell functions/aliases (session wrapper `tn`)
- Tmux session data (via tmux-resurrect backups)

### What Requires Adjustment
- Path variables (PREFIX, $HOME)
- Package manager commands (`apt` vs `pkg`)
- Shell RC files (.bashrc location)

## Migration Steps

### 1. Export Current Config

```bash
# In source environment:
export SRC_ENV=$(bash /path/to/detect_env.sh)
echo "Exporting from: $SRC_ENV"

# Backup current tmux config
cp ~/.tmux.conf ~/.tmux.conf.backup

# Backup session data
cp -r ~/.tmux/resurrect ~/.tmux/resurrect.backup
```

### 2. Copy Configuration Files

```bash
# Copy to portable location (USB/cloud storage or to target environment)
scp -r ~/.tmux username@target-device:/tmp/tmux_backup/
scp ~/.tmux.conf username@target-device:/tmp/tmux.conf.backup
```

### 3. Adapt for Target Environment

```bash
# In target environment:
bash /path/to/detect_env.sh

# Update TPM location if needed
# Most installations use ~/.tmux/plugins/tpm — verify it exists or reinstall
```

### 4. Restore Session Data (Optional)

```bash
# Copy backed-up session data to new environment
mkdir -p ~/.tmux/resurrect
cp /tmp/tmux_backup/resurrect/* ~/.tmux/resurrect/

# Manually restore in tmux
tmux new-session -d -s test
tmux send-keys -t test "source ~/.tmux/plugins/tmux-resurrect/scripts/restore.sh" Enter
```

### 5. Verify Portability

```bash
# Check environment
cat /etc/os-release | grep "^ID="

# Verify tmux works
tmux -V

# Test session creation
tn test_session

# Confirm plugins loaded
tmux list-plugins
```

## Environment-Specific Notes

### Termux → Ubuntu-on-Termux

**Changes needed:**
- Ubuntu uses `/bin`, `/usr` standard paths
- `.bashrc` location: same (`~/.bashrc`)
- Package manager: `apt` (not `pkg`)
- No PREFIX env var in Ubuntu

**Automated adjustment:**
```bash
#!/bin/bash
# adjust_for_ubuntu.sh
if grep -q "ubuntu" /etc/os-release; then
    # Remove Termux-specific commands
    sed -i '/termux-wake-lock/d' ~/.bashrc
    # Add Ubuntu-specific settings if needed
fi
```

### Ubuntu-on-Termux → Termux-native

**Changes needed:**
- Termux uses `$PREFIX` for package root
- `.bashrc` location: same
- Package manager: `pkg` (not `apt`)
- May need reinstall of packages (limited pkg compatibility)

**Automated adjustment:**
```bash
#!/bin/bash
# adjust_for_termux.sh
if [ -n "$TERMUX_VERSION" ]; then
    # Termux-specific setup
    export PREFIX=$(termux-info | grep "PREFIX" | cut -d= -f2)
    # Reinstall TPM in Termux
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
```

### Debian ↔ Ubuntu

**Changes needed:**
- Mostly compatible
- `.bashrc` location: same
- Package manager compatible (`apt`)
- May differ slightly in package versions

**No major adjustments needed**, but verify package availability.

## Troubleshooting Migration

### TPM not loading in target environment

```bash
# Reinstall TPM
rm -rf ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins
```

### Session data not restoring

```bash
# Check if resurrect data exists
ls -la ~/.tmux/resurrect/

# Manually restore last session backup
cat ~/.tmux/resurrect/last | head -20
```

### Shell functions (like `tn`) not working

```bash
# Verify function is in shell RC file
grep -n "^tn()" ~/.bashrc

# If missing, re-add it
cat scripts/session_wrapper.sh >> ~/.bashrc
source ~/.bashrc
```

## Keeping Configs in Sync

### Option 1: Cloud Sync (Git)
```bash
# Commit configs to private repo
git add ~/.tmux.conf scripts/ docs/
git commit -m "Update tmux config"
git push

# In target environment, pull updates
git pull
```

### Option 2: Manual Backup
```bash
# Regular backups to USB/external storage
cp -r ~/.tmux /media/usb/tmux_backup_$(date +%Y%m%d)
```

### Option 3: Dotfiles Manager
Use tools like `dotfiles`, `stow`, or `yadm` to manage symlinked configs across devices.
