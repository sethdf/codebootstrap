#!/bin/bash
# post-start.sh - Runs on every container start
# This script handles startup tasks that need to run each time

set -e

# ============================================
# Codespaces-specific setup
# ============================================
if [ "$CODESPACES" = "true" ]; then
    echo "Running in GitHub Codespaces..."

    # GitHub token is automatically available in Codespaces as GITHUB_TOKEN
    # Configure it for the GitHub MCP server if not already set
    if [ -n "$GITHUB_TOKEN" ]; then
        # Update Claude config with the Codespaces token
        if [ -f ~/.config/claude/settings.json ]; then
            # Token is already referenced as ${GITHUB_TOKEN} in the config
            # which will be expanded by the MCP server at runtime
            echo "  ✓ GitHub token available for MCP"
        fi
    fi

    # In Codespaces, git is pre-configured with user credentials
    echo "  ✓ Git credentials configured automatically"
fi

# ============================================
# Verify core tools are available
# ============================================
# Silent check - only output if something is wrong
command -v claude >/dev/null 2>&1 || echo "Warning: claude not found in PATH"
command -v node >/dev/null 2>&1 || echo "Warning: node not found in PATH"
command -v python3 >/dev/null 2>&1 || echo "Warning: python3 not found in PATH"

# Container is ready
