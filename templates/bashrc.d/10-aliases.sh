#!/bin/bash
# 10-aliases.sh - Short aliases for CodeBootstrap

# ============================================
# AI Tool Aliases (YOLO Mode)
# ============================================
# All AI tools run in dangerous/YOLO mode for uninterrupted workflow

alias c='claude --dangerously-skip-permissions'
alias cr='claude --dangerously-skip-permissions --resume'
alias codex='codex --dangerously-bypass-approvals-and-sandbox'
alias gemini='gemini --yolo'

# ============================================
# Git Aliases
# ============================================

alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph -20'
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch'
alias gco='git checkout'
