# Android Persistence & Device Configuration Guide

## Battery Optimization (Critical)

### Termux on Android
1. **Open Settings** → Search for "Battery" or "Power Management"
2. **Find Termux app** in battery settings
3. **Disable battery optimization** for Termux:
   - Samsung devices: Settings → Apps → Termux → Battery → Not optimized
   - Stock Android: Settings → Battery → Battery Saver → Manage exceptions → Add Termux
   - Other: Look for "App power management" or "Battery optimization"

### Wake Lock (Recommended)

**Option A: Using Termux notification drawer**
1. Open Termux
2. Swipe down the notification drawer
3. Tap "Wake Lock" to enable
4. Keep enabled while running tmux sessions

**Option B: Command-line**
```bash
# In Termux:
termux-wake-lock
```

## Auto-Start on Boot (Optional but recommended)

### Using a Task Scheduler (Tasker)
1. Install Tasker app
2. Create a task to launch Termux with:
   ```
   Action: Launch app
   App: Termux
   Optional: tmux new-session -d -s autostart
   ```

### Using Android 10+ DeviceAdmin
1. Termux → Settings → Run command on boot (if available)
2. Command: `tmux new-session -d -s boot`

## Session Persistence Checklist
- [ ] Battery optimization disabled for Termux
- [ ] Wake Lock enabled
- [ ] tmux-continuum configured (auto-save every 15 min)
- [ ] tmux-resurrect installed and working
- [ ] Test: Kill and restart Termux, verify sessions restore

## Troubleshooting

### Sessions not restoring after reboot
- Check: `ls -la ~/.tmux/resurrect/`
- Look for recent backup files
- Manually restore: `tmux-resurrect restore` or `Prefix + Ctrl-r`

### tmux-continuum not saving
- Verify plugin installed: `ls ~/.tmux/plugins/tmux-continuum`
- Check: `~/.tmux/resurrect/` directory exists
- Manually trigger save: `Prefix + Ctrl-s`

### Wake Lock not staying active
- Ensure Termux has permission to request wake lock
- Grant permission: Settings → Apps → Termux → Permissions → Battery
- Alternative: Use `termux-wake-lock` in startup script

## Monitoring Session Health

```bash
# List all sessions
tmux list-sessions

# Show session details
tmux show-session -t session_name

# Check continuous save status
cat ~/.tmux/resurrect/last

# Verify plugins loaded
tmux list-plugins
```
