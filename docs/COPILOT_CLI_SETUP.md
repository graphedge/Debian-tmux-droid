# Copilot CLI Installation & Setup Guide

## Prerequisites

### System Requirements
- Tmux installed and running
- Git installed
- curl or wget available
- Node.js 18+ (for Copilot CLI)

### Environment Check

```bash
# Run environment detection
bash scripts/detect_env.sh

# Expected output:
# Environment: Debian (debian)
# or
# Environment: Ubuntu (on Termux) (ubuntu-on-termux)
# or
# Environment: Termux (termux-native)
```

## Installation Steps (Manual — No Auto-Install)

### Step 1: Install Node.js (if needed)

**For Debian:**
```bash
# Check if already installed
node --version

# If needed, install via apt (requires root or sudo):
# apt update && apt install nodejs npm
```

**For Ubuntu-on-Termux:**
```bash
# Similar to Debian
node --version
# If needed: apt update && apt install nodejs npm
```

**For Termux-native:**
```bash
# Check if already installed
node --version

# If needed, install via pkg:
# pkg update && pkg install nodejs
```

### Step 2: Install Copilot CLI

```bash
# Option A: Using npm (recommended)
npm install -g @github/copilot-cli

# Option B: Using GitHub releases (if npm unavailable)
# Download from: https://github.com/github/copilot-cli/releases
# Extract and add to PATH
```

### Step 3: Initialize Copilot CLI

```bash
# First run — initializes config
gh copilot configure

# Login with GitHub
gh auth login

# Verify installation
copilot --version
```

### Step 4: Integrate with Tmux Sessions

**Add to session wrapper function** (`scripts/session_wrapper.sh`):

```bash
tn() {
    local session_name="$1"
    
    if [ -z "$session_name" ]; then
        echo "Existing sessions:"
        tmux list-sessions 2>/dev/null || echo "  (none)"
        echo ""
        read -p "Enter new session name: " session_name
        [ -z "$session_name" ] && return 1
    fi
    
    if tmux has-session -t "$session_name" 2>/dev/null; then
        echo "Attaching to: $session_name"
        tmux attach-session -t "$session_name"
    else
        # NEW: Initialize Copilot CLI in new session
        echo "Creating session: $session_name"
        tmux new-session -d -s "$session_name" -x 200 -y 50
        tmux send-keys -t "$session_name" "# Use 'copilot' or '?' for CLI help" Enter
        tmux attach-session -t "$session_name"
    fi
}
```

### Step 5: Add Copilot to .bashrc

```bash
# Add to ~/.bashrc or ~/.zshrc:
alias copilot-help='copilot --help'
alias copilot-ask='copilot explain'

# Optional: Automatically load in new tmux sessions
# (Already done in session wrapper above)
```

## Usage Examples

### Basic Commands

```bash
# Get help
copilot --help

# Explain shell command or concept
copilot explain "git merge"

# Get suggestions for a task
copilot suggest

# Interactive mode
copilot
```

### In Tmux Sessions

Once set up, use Copilot CLI naturally within tmux panes:

```bash
# In a tmux pane:
$ copilot explain ls -lah
# Returns explanation of ls command

$ copilot suggest "how to list files recursively"
# Returns command suggestions
```

## Troubleshooting

### Copilot CLI not found after install

```bash
# Verify npm installation
npm --version

# Check if copilot-cli is installed globally
npm list -g @github/copilot-cli

# Add npm global bin to PATH if needed
export PATH="$PATH:$(npm config get prefix)/bin"
echo "export PATH=\"\$PATH:\$(npm config get prefix)/bin\"" >> ~/.bashrc
source ~/.bashrc
```

### Authentication failed

```bash
# Re-authenticate with GitHub
gh auth logout
gh auth login

# Or refresh token
gh auth refresh -h github.com

# Verify auth
gh auth status
```

### Copilot CLI not persistent after tmux restart

This is expected — Copilot CLI is a CLI tool, not a background service. To use it in a restored session:

```bash
# After tmux restore, simply use copilot commands again
copilot --version
```

## Integration with Other Tools

### With Neovim/Vim
```bash
# Copilot CLI commands can be called from vim using :!
# Example: :!copilot explain 'function definition'
```

### With Debian Proot Environment
```bash
# If running Debian in a tmux pane, Copilot CLI is available in parent Termux/Ubuntu session
# To use from within Debian pane:
# (requires shared /home or PATH adjustment)
```

## Next Steps

1. After Copilot CLI is installed, test it:
   ```bash
   copilot explain "tmux new-session"
   ```

2. Create named sessions:
   ```bash
   tn dev
   tn research
   tn workspace
   ```

3. Within sessions, use Copilot CLI for help and suggestions

4. Sessions will auto-save every 15 minutes (tmux-continuum)

## Tips & Best Practices

- **Use `copilot suggest`** when unsure what command to run
- **Use `copilot explain`** to learn what a command does
- **Check `copilot --help`** for all available options
- **Keep GitHub credentials fresh** — token may expire after 8 hours
- **Sessions persist** but Copilot CLI state does not — each command is independent
