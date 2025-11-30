#!/bin/bash
# 30-welcome.sh - Welcome message for CodeBootstrap container
# Shows key commands when entering the container (great for mobile/SSH access)

# Only show welcome on interactive shells and first login
if [[ $- == *i* ]] && [ -z "$CODEBOOTSTRAP_WELCOMED" ]; then
    export CODEBOOTSTRAP_WELCOMED=1

    # Check if this is likely a mobile/SSH session (no VSCODE_* env vars)
    if [ -z "$VSCODE_GIT_IPC_HANDLE" ]; then
        echo ""
        echo "┌─────────────────────────────────────────┐"
        echo "│         CodeBootstrap Container         │"
        echo "└─────────────────────────────────────────┘"
        echo ""
        echo "  AI Tools    c = Claude   codex   gemini"
        echo "  Projects    p = list/switch   new-project <name>"
        echo "  Status      codebootstrap-status"
        echo ""

        # Show current project if in one
        if [ -f ".specify/owner.lock" ] || [ -f "package.json" ] || [ -f "pyproject.toml" ]; then
            local project_name=$(basename "$PWD")
            echo "  Current: $project_name"
            echo ""
        fi
    fi
fi
