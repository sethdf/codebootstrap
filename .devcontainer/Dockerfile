# CodeBootstrap Development Container
# Base image with common dev tools
FROM mcr.microsoft.com/devcontainers/base:debian

# Avoid prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

# ============================================
# System packages
# ============================================
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    jq \
    unzip \
    build-essential \
    tmux \
    && rm -rf /var/lib/apt/lists/*

# ============================================
# Node.js 20 LTS
# ============================================
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# ============================================
# Python 3.12 + uv (fast package manager)
# ============================================
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Install uv system-wide (fast Python package manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | env CARGO_HOME=/usr/local UV_INSTALL_DIR=/usr/local/bin sh

# ============================================
# AI Coding Tools
# ============================================

# Claude Code
RUN npm install -g @anthropic-ai/claude-code

# OpenAI Codex CLI
RUN npm install -g @openai/codex

# Google Gemini CLI
RUN npm install -g @google/gemini-cli

# ============================================
# Spec Kit CLI (installed via uv for vscode user)
# ============================================
USER vscode
RUN uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
USER root

# ============================================
# Default user setup
# ============================================
USER vscode
WORKDIR /workspaces

# Ensure npm global packages are in PATH for vscode user
ENV PATH="/home/vscode/.local/bin:$PATH"
