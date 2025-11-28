#!/bin/bash
# 00-path.sh - PATH modifications for CodeBootstrap

# Add local bin to PATH (for uv and other user-installed tools)
export PATH="$HOME/.local/bin:$PATH"

# Add npm global bin to PATH
export PATH="$HOME/.npm-global/bin:$PATH"

# Set default projects directory
export PROJECTS_DIR="${PROJECTS_DIR:-$HOME/projects}"
