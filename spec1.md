Here's the cleaned-up and updated metaprompt, keeping almost everything from your original while incorporating our discussion:

---

**Metaprompt: Tmux Persistence & Identity Setup (Updated)**

**Objective:** Configure a highly resilient, auto-saving, and identifiable Tmux environment on Debian (running via Termux/PRoot).

**System Context:**
- **Host OS:** Android + Termux
- **Inner Distro:** Debian (via proot-distro)
- **Recommended Architecture:** Termux → tmux (running in Termux) → Debian (inside tmux panes)
- **Terminal:** Termux app (with optional GUI terminal emulator later if desired)

### Step 1: Core Tmux Configuration
"Configure tmux in the **Termux host** to include and initialize the Tmux Plugin Manager (TPM). Specifically, install and enable tmux-resurrect and tmux-continuum with the following behaviors:
1. **Auto-Save:** Set tmux-continuum to save every 15 minutes.
2. **Auto-Restore:** Enable tmux-continuum to automatically restore the last saved environment upon Tmux server start.
3. **Vim/Neovim Support:** Ensure tmux-resurrect captures pane contents and editor sessions."

### Step 2: Session Naming Logic
"Implement a shell alias or function that enforces meaningful session names. Instead of a generic tmux new, create a wrapper command `tn` (Tmux New) that:
- Prompts for a session name if one isn't provided.
- Prevents duplicate session names.
- Automatically lists existing sessions before creating a new one to avoid confusion."

### Step 3: Execution Script
"Generate a bash script to automate the installation of dependencies in **Termux**:
- Clone TPM to ~/.tmux/plugins/tpm if not present.
- Append the necessary configuration lines to ~/.tmux.conf.
- Silent-install the plugins using the TPM headless install command: ~/.tmux/plugins/tpm/bin/install_plugins."

### How to use this with your Shell Agent
You can paste something like this to your shell agent (Copilot CLI, etc.):

> "I need to automate my Tmux setup in Termux on Android. Install TPM, tmux-resurrect, and tmux-continuum in Termux itself. Set them to auto-save every 15 minutes and auto-restore on start. Also add a function to my .bashrc that lets me start nicely named sessions with `tn`. Then I will run Debian proot-distro inside the tmux panes. Please output the exact commands."

### Pro-Tip for Android Users
Since Android can be aggressive about killing background processes:
1. **Battery Optimization:** Turn it **OFF** for Termux (set to Unrestricted).
2. **Wake Lock:** Run `termux-wake-lock` or enable it from the Termux notification drawer so the CPU doesn't sleep.

### Quick Reference Table: Key Commands
| Action              | Shortcut (After Prefix) | Command Line                  |
|---------------------|-------------------------|-------------------------------|
| Manual Save         | Prefix + Ctrl-s        | N/A                           |
| Manual Restore      | Prefix + Ctrl-r        | N/A                           |
| Rename Session      | Prefix + ,             | tmux rename-session -t <old> <new> |
| List Sessions       | Prefix + s             | tmux ls                       |

**Architecture Note:**  
This setup uses **Termux → tmux → Debian**. Tmux runs in the outer Termux layer for better resilience against Android killing processes. Debian runs comfortably inside individual tmux panes/windows. This gives good persistence while keeping things relatively lightweight compared to nested distros.

---

Does this version look good? Any parts you want to keep more exactly as in your original, or any clarifying changes before we finalize it?