#!/bin/bash
# Environment Detection Script
# Detects if running in Ubuntu-on-Termux, Termux-native, or default Debian

detect_environment() {
    local env_type="unknown"
    local distro=""
    local shell_type=""

    # Check for Termux
    if [ -d "$PREFIX" ] && [ "$TERMUX_VERSION" != "" ]; then
        env_type="termux-native"
        shell_type="Termux"
    fi

    # Check for Ubuntu-on-Termux (proot-distro)
    if [ -f "/etc/os-release" ]; then
        distro=$(grep "^ID=" /etc/os-release | cut -d= -f2 | tr -d '"')
        
        if [ "$distro" = "ubuntu" ] && [ -d "$PREFIX" ]; then
            env_type="ubuntu-on-termux"
            shell_type="Ubuntu (on Termux)"
        elif [ "$distro" = "debian" ]; then
            env_type="debian"
            shell_type="Debian"
        fi
    fi

    # Fallback: check uname for additional context
    if [ "$env_type" = "unknown" ]; then
        if uname -a | grep -q "Android"; then
            env_type="android-generic"
            shell_type="Android (generic)"
        fi
    fi

    # Export for use in other scripts
    export DETECTED_ENV="$env_type"
    export DETECTED_SHELL="$shell_type"

    echo "Environment: $shell_type ($env_type)"
    return 0
}

# Main
detect_environment
