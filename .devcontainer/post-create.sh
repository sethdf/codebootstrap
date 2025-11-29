#!/bin/bash
# post-create.sh - Runs after container creation (once)
# This script configures MCP servers, shell helpers, and initial setup

set -e

echo "========================================"
echo "CodeBootstrap Post-Create Setup"
echo "========================================"

# Get the workspace directory (where the repo is mounted)
WORKSPACE_DIR="${PWD}"
TEMPLATES_DIR="${WORKSPACE_DIR}/templates"

# ============================================
# Create projects directory and fix permissions
# ============================================
echo "Creating projects directory..."
mkdir -p /workspaces/projects
sudo chown -R vscode:vscode /workspaces/projects

# ============================================
# MCP Configuration for Claude Code
# ============================================
echo "Configuring Claude Code MCP servers..."
mkdir -p ~/.config/claude

# Generate Claude settings.json from template
cat > ~/.config/claude/settings.json << 'EOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-filesystem", "/workspaces"]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-memory"]
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-fetch"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-sequential-thinking"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    },
    "git": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-git", "--repository", "/workspaces"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
EOF

echo "  ✓ Claude Code: ~/.config/claude/settings.json"

# ============================================
# MCP Configuration for Codex CLI (TOML format)
# ============================================
echo "Configuring Codex CLI MCP servers..."
mkdir -p ~/.codex

cat > ~/.codex/config.toml << 'EOF'
# Codex CLI MCP Server Configuration

[mcp_servers.filesystem]
command = "npx"
args = ["-y", "@anthropic-ai/mcp-server-filesystem", "/workspaces"]

[mcp_servers.memory]
command = "npx"
args = ["-y", "@anthropic-ai/mcp-server-memory"]

[mcp_servers.fetch]
command = "npx"
args = ["-y", "@anthropic-ai/mcp-server-fetch"]

[mcp_servers.sequential-thinking]
command = "npx"
args = ["-y", "@anthropic-ai/mcp-server-sequential-thinking"]

[mcp_servers.context7]
command = "npx"
args = ["-y", "@upstash/context7-mcp"]

[mcp_servers.git]
command = "npx"
args = ["-y", "@anthropic-ai/mcp-server-git", "--repository", "/workspaces"]

[mcp_servers.github]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-github"]
env = { GITHUB_PERSONAL_ACCESS_TOKEN = "${GITHUB_TOKEN}" }
EOF

echo "  ✓ Codex CLI: ~/.codex/config.toml"

# ============================================
# MCP Configuration for Gemini CLI
# ============================================
echo "Configuring Gemini CLI MCP servers..."
mkdir -p ~/.gemini

cat > ~/.gemini/settings.json << 'EOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-filesystem", "/workspaces"]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-memory"]
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-fetch"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-sequential-thinking"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    },
    "git": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-git", "--repository", "/workspaces"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
EOF

echo "  ✓ Gemini CLI: ~/.gemini/settings.json"

# ============================================
# Shell Helpers Installation
# ============================================
echo "Installing shell helpers..."
mkdir -p ~/.bashrc.d

# Copy bashrc.d files if templates exist
if [ -d "${TEMPLATES_DIR}/bashrc.d" ]; then
    cp -r "${TEMPLATES_DIR}/bashrc.d/"* ~/.bashrc.d/
    echo "  ✓ Shell helpers copied to ~/.bashrc.d/"
else
    echo "  ⚠ No bashrc.d templates found, skipping..."
fi

# Add sourcing to .bashrc if not already present
if ! grep -q "bashrc.d" ~/.bashrc 2>/dev/null; then
    cat >> ~/.bashrc << 'EOF'

# Source all files in ~/.bashrc.d/
if [ -d ~/.bashrc.d ]; then
    for f in ~/.bashrc.d/*.sh; do
        [ -r "$f" ] && source "$f"
    done
fi

# Source custom user extensions if present
if [ -f ~/.codebootstrap/custom.sh ]; then
    source ~/.codebootstrap/custom.sh
fi
EOF
    echo "  ✓ Added bashrc.d sourcing to ~/.bashrc"
fi

# Create codebootstrap config directory for custom extensions
mkdir -p ~/.codebootstrap
if [ ! -f ~/.codebootstrap/custom.sh ]; then
    cat > ~/.codebootstrap/custom.sh << 'EOF'
# Custom CodeBootstrap extensions
# Add your own aliases and functions here
# This file is sourced automatically on shell startup

# Example:
# alias myalias='my-command'
# myfunction() { echo "Hello"; }
EOF
    echo "  ✓ Created ~/.codebootstrap/custom.sh for user extensions"
fi

# ============================================
# Default Spec Kit ownership (claude as default)
# ============================================
echo "Setting up Spec Kit ownership..."
if [ -d ".specify" ] && [ ! -f ".specify/owner.lock" ]; then
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    cat > .specify/owner.lock << EOF
{
  "owner": "claude",
  "since": "$timestamp",
  "transferred_from": null
}
EOF
    echo "  ✓ Default owner set to claude"
fi

# ============================================
# AI Tool Authentication Instructions
# ============================================
echo ""
echo "========================================"
echo "AI Tool Authentication Required"
echo "========================================"
echo ""
echo "Run each command once to authenticate:"
echo ""
echo "  claude          → Opens browser for Anthropic OAuth"
echo "  codex auth      → Opens browser for ChatGPT OAuth"
echo "  gemini auth     → Opens browser for Google OAuth"
echo ""
echo "After auth, use aliases: c, codex, gemini (YOLO mode enabled)"
echo ""
echo "========================================"
echo "Setup complete!"
echo "========================================"
