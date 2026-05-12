This is a structured metaprompt designed to be fed into a shell agent (like Copilot CLI, an LLM-integrated terminal, or even a specialized script). It bypasses the "fiddly" manual editing and ensures your Debian-on-Android environment is persistent and clearly labeled.
## Metaprompt: Tmux Persistence & Identity Setup
**Objective:** Configure a highly resilient, auto-saving, and identifiable Tmux environment on Debian (running via Termux/PRoot).
**System Context:**
 * **Host OS:** Debian on Android.
 * **Terminal:** Terminator.
 * **Requirements:** Persistent sessions across device reboots and clearly named sessions.
### Step 1: Core Configuration Instruction
"Configure .tmux.conf to include and initialize the Tmux Plugin Manager (TPM). Specifically, install and enable tmux-resurrect and tmux-continuum with the following behaviors:
 1. **Auto-Save:** Set tmux-continuum to save every 15 minutes.
 2. **Auto-Restore:** Enable tmux-continuum to automatically restore the last saved environment upon Tmux server start.
 3. **Vim/Neovim Support:** Ensure tmux-resurrect captures pane contents and editor sessions."
### Step 2: Session Naming Logic
"Implement a shell alias or function that enforces meaningful session names. Instead of a generic tmux new, create a wrapper command tn (Tmux New) that:
 * Prompts for a session name if one isn't provided.
 * Prevents duplicate session names.
 * Automatically lists existing sessions before creating a new one to avoid confusion."
### Step 3: Execution Script
"Generate a bash script to automate the installation of dependencies:
 * Clone TPM to ~/.tmux/plugins/tpm if not present.
 * Append the necessary configuration lines to ~/.tmux.conf.
 * Silent-install the plugins using the TPM headless install command: ~/.tmux/plugins/tpm/bin/install_plugins."
## How to use this with your Shell Agent
If you are using a tool like **Copilot CLI** or **Aetna Health** (as you mentioned), you can simply paste the block below:
> "I need to automate my Tmux setup on Debian. Install TPM, tmux-resurrect, and tmux-continuum. Set them to auto-save and auto-restore on boot. Also, add a function to my .bashrc that lets me start named sessions easily so I don't lose track of which session is which. Please output the commands to make this happen."
> 
### Pro-Tip for Android Users
Since Android can be aggressive about killing background processes, even with tmux-continuum, you should ensure:
 1. **Battery Optimization:** Turn it **OFF** for your terminal app (Termux/Terminator).
 2. **Acquire Wake Lock:** If you are using Termux, pull down the notification drawer and ensure the "Wake Lock" is active so the CPU doesn't sleep on your Tmux server.
### Quick Reference Table: Key Commands
| Action | Shortcut (After Prefix) | Command Line |
|---|---|---|
| **Manual Save** | Prefix + Ctrl-s | N/A |
| **Manual Restore** | Prefix + Ctrl-r | N/A |
| **Rename Session** | Prefix + , | tmux rename-session -t <old> <new> |
| **List Sessions** | Prefix + s | tmux ls |
This setup turns your "Debian-in-a-phone" into a legitimate workstation that feels less like a mobile app and more like a persistent server. Does the script-based approach feel like it hits the "set it and forget it" mark for you?
