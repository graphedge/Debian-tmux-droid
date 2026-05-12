# Implementation Plan: Copilot CLI and Tmux Persistence on Android/Debian/Termux

## Objective
Automate the installation and configuration of Copilot CLI, Tmux, TPM, and plugins for a persistent, portable development environment on Android using Termux and Debian (via proot-distro), following the main plan from spec1.md.

## Key Requirements
- All automation and config should be portable between Ubuntu-on-Termux and Termux-native, but default to Debian for automated installs.
- Environment detection logic to adjust paths/commands as needed.
- Automate dependency installation in default Debian only.
- Tmux/TPM/plugins/config should be set up in a way that can be migrated or reused.

## Steps
1. **Environment Detection**
   - Script detects if running in Ubuntu-on-Termux, Termux-native, or default Debian.
2. **Install Dependencies (in default Debian)**
   - Install tmux, git, curl, and other prerequisites.
   - Install Copilot CLI (official instructions).
3. **Tmux & TPM Setup**
   - Clone TPM to ~/.tmux/plugins/tpm if not present.
   - Append required plugin config to ~/.tmux.conf.
   - Install tmux-resurrect and tmux-continuum plugins.
   - Configure auto-save/auto-restore.
4. **Session Naming Wrapper**
   - Add a shell function/alias (`tn`) for named tmux sessions.
5. **Persistence & Android-Specific Steps**
   - Remind user to disable battery optimization and enable wake lock for Termux.
6. **(Optional) Migration/Portability**
   - Document how to copy configs/scripts between environments if needed.

## Out of Scope
- GUI terminal emulators (e.g., Terminator) unless specifically requested.
- Automated setup in Ubuntu-on-Termux or Termux-native (manual steps only).

## Next Steps
- Generate install/config scripts for default Debian.
- Document manual steps for other environments.
- Validate persistence and portability.
