#!/bin/bash
# Session Naming Wrapper Function
# Add this to ~/.bashrc or ~/.zshrc for convenient named tmux sessions

tn() {
    # Function to create or attach to named tmux sessions
    
    local session_name="$1"
    
    # If no name provided, prompt for one
    if [ -z "$session_name" ]; then
        echo "Existing sessions:"
        tmux list-sessions 2>/dev/null || echo "  (none)"
        
        echo ""
        read -p "Enter new session name: " session_name
        
        if [ -z "$session_name" ]; then
            echo "No session name provided. Exiting."
            return 1
        fi
    fi
    
    # Check if session already exists
    if tmux has-session -t "$session_name" 2>/dev/null; then
        echo "Attaching to existing session: $session_name"
        tmux attach-session -t "$session_name"
    else
        # Validate session name (no spaces, special chars)
        if [[ "$session_name" =~ [^a-zA-Z0-9_-] ]]; then
            echo "Error: Session name can only contain letters, numbers, dashes, and underscores."
            return 1
        fi
        
        echo "Creating new session: $session_name"
        tmux new-session -d -s "$session_name" -x 200 -y 50
        tmux attach-session -t "$session_name"
    fi
}

# Alias for quick list
alias tml='tmux list-sessions'

# Export function so it's available in subshells
export -f tn
