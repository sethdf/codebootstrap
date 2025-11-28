#!/bin/bash
# host-setup.sh - Minimal host setup for CodeBootstrap
# Installs only Docker and GitHub CLI
# Run with: curl -fsSL <url>/host-setup.sh | bash

set -e

# ============================================
# Color output helpers
# ============================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[⚠]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; exit 1; }

# ============================================
# Platform detection
# ============================================
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

detect_wsl() {
    if grep -qi microsoft /proc/version 2>/dev/null; then
        return 0  # true, is WSL
    fi
    return 1  # false, not WSL
}

# ============================================
# Docker installation
# ============================================
install_docker() {
    local os="$1"

    # Check if already installed
    if command -v docker &> /dev/null; then
        local version=$(docker --version | cut -d' ' -f3 | tr -d ',')
        success "Docker already installed: $version"
        return 0
    fi

    info "Installing Docker..."

    case "$os" in
        macos)
            warn "Docker Desktop for macOS required"
            echo ""
            echo "Please install Docker Desktop manually:"
            echo "  1. Download from: https://www.docker.com/products/docker-desktop"
            echo "  2. Install and start Docker Desktop"
            echo "  3. Re-run this script"
            echo ""
            return 1
            ;;
        ubuntu|debian)
            if detect_wsl; then
                warn "WSL detected - Docker Desktop for Windows required"
                echo ""
                echo "Please install Docker Desktop on Windows:"
                echo "  1. Download from: https://www.docker.com/products/docker-desktop"
                echo "  2. Install Docker Desktop"
                echo "  3. Enable WSL 2 integration in Docker Desktop settings"
                echo "  4. Re-run this script"
                echo ""
                return 1
            fi

            # Install Docker on native Linux
            info "Installing Docker via apt..."
            sudo apt-get update
            sudo apt-get install -y \
                ca-certificates \
                curl \
                gnupg \
                lsb-release

            # Add Docker's official GPG key
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/$os/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

            # Set up repository
            echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$os \
                $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

            # Install Docker Engine
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

            # Add user to docker group
            sudo usermod -aG docker "$USER"

            success "Docker installed"
            warn "Log out and back in for docker group to take effect"
            ;;
        fedora|rhel|centos)
            info "Installing Docker via dnf..."
            sudo dnf -y install dnf-plugins-core
            sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            sudo systemctl start docker
            sudo systemctl enable docker
            sudo usermod -aG docker "$USER"
            success "Docker installed"
            ;;
        *)
            error "Unsupported OS: $os. Please install Docker manually."
            ;;
    esac
}

# ============================================
# GitHub CLI installation
# ============================================
install_gh() {
    local os="$1"

    # Check if already installed
    if command -v gh &> /dev/null; then
        local version=$(gh --version | head -1 | cut -d' ' -f3)
        success "GitHub CLI already installed: $version"
        return 0
    fi

    info "Installing GitHub CLI..."

    case "$os" in
        macos)
            if command -v brew &> /dev/null; then
                brew install gh
            else
                warn "Homebrew not found. Installing via official installer..."
                curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            fi
            ;;
        ubuntu|debian)
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt-get update
            sudo apt-get install -y gh
            ;;
        fedora|rhel|centos)
            sudo dnf install -y gh
            ;;
        *)
            error "Unsupported OS: $os. Please install gh manually from https://cli.github.com"
            ;;
    esac

    success "GitHub CLI installed"
}

# ============================================
# Main
# ============================================
main() {
    echo ""
    echo "========================================"
    echo "CodeBootstrap Host Setup"
    echo "========================================"
    echo ""
    echo "This script installs:"
    echo "  • Docker (for running devcontainers)"
    echo "  • GitHub CLI (for authentication)"
    echo ""

    local os=$(detect_os)
    info "Detected OS: $os"

    if detect_wsl; then
        info "Running in WSL"
    fi

    echo ""

    # Install Docker
    install_docker "$os"

    echo ""

    # Install GitHub CLI
    install_gh "$os"

    echo ""

    # GitHub authentication guidance
    echo "========================================"
    echo "GitHub Authentication"
    echo "========================================"
    echo ""

    if command -v gh &> /dev/null; then
        if gh auth status &> /dev/null; then
            local user=$(gh api user -q .login 2>/dev/null)
            success "Already authenticated as: $user"
        else
            info "Run the following to authenticate with GitHub:"
            echo ""
            echo "    gh auth login --web"
            echo ""
            echo "This will open a browser for OAuth authentication."
        fi
    fi

    echo ""

    # Summary
    echo "========================================"
    echo "Setup Summary"
    echo "========================================"
    echo ""

    # Docker status
    if command -v docker &> /dev/null; then
        if docker info &> /dev/null; then
            success "Docker: Running"
        else
            warn "Docker: Installed but not running. Start Docker Desktop."
        fi
    else
        error "Docker: Not installed"
    fi

    # gh status
    if command -v gh &> /dev/null; then
        if gh auth status &> /dev/null; then
            success "GitHub CLI: Authenticated"
        else
            warn "GitHub CLI: Installed but not authenticated"
        fi
    else
        error "GitHub CLI: Not installed"
    fi

    echo ""
    echo "========================================"
    echo "Next Steps"
    echo "========================================"
    echo ""
    echo "1. Install VS Code with Dev Containers extension"
    echo "   https://code.visualstudio.com/"
    echo ""
    echo "2. Clone a project with devcontainer:"
    echo "   git clone https://github.com/<owner>/codebootstrap.git"
    echo "   cd codebootstrap"
    echo "   code ."
    echo ""
    echo "3. Click 'Reopen in Container' when prompted"
    echo ""
    success "Host setup complete!"
}

main "$@"
