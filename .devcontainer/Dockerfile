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

# Install uv (fast Python package manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && echo 'export PATH="$HOME/.local/bin:$PATH"' >> /etc/bash.bashrc

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
# Spec Kit CLI
# ============================================
# Note: Using pip for now; update package name when available
# RUN pip3 install specify-cli --break-system-packages

# ============================================
# Default user setup
# ============================================
USER vscode
WORKDIR /workspaces

# Ensure npm global packages are in PATH for vscode user
ENV PATH="/home/vscode/.local/bin:$PATH"
