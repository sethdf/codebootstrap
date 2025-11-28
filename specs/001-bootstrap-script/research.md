# Research: Container-First Development Environment

**Feature**: 001-bootstrap-script
**Date**: 2025-01-26

## Devcontainer Base Image

### Decision: Use Microsoft's universal devcontainer image with customizations

**Rationale**: Microsoft's images are battle-tested, include common tools, and work across all devcontainer platforms.

**Options Evaluated**:
- `mcr.microsoft.com/devcontainers/universal:2` - Full-featured, large (~8GB)
- `mcr.microsoft.com/devcontainers/base:debian` - Minimal, customize from scratch
- Custom Dockerfile from `ubuntu:22.04` - Full control, more maintenance

**Selected**: Custom Dockerfile based on `mcr.microsoft.com/devcontainers/base:debian`
- Good balance of size and features
- Allows precise control over tool versions
- Faster builds than universal image

---

## AI Coding Tools

### Decision: Include all three major AI CLI tools

**Rationale**: Different tools have different strengths; let user choose

**Tools Included**:

| Tool | Package | Auth Method |
|------|---------|-------------|
| Claude Code | `@anthropic-ai/claude-code` | OAuth (browser login) |
| OpenAI Codex CLI | `@openai/codex` | ChatGPT account |
| Google Gemini CLI | `@google/gemini-cli` | Google account (free tier available) |

**YOLO Mode Flags**:
- Claude: `--dangerously-skip-permissions`
- Codex: `--dangerously-bypass-approvals-and-sandbox`
- Gemini: `--yolo`

---

## MCP Server Configuration

### Decision: Configure MCP servers for all three AI tools

**Rationale**: All three tools support MCP; share the same 7 base servers

**7 Base MCP Servers**:

| Server | Package | Purpose |
|--------|---------|---------|
| filesystem | @anthropic-ai/mcp-server-filesystem | File operations |
| memory | @anthropic-ai/mcp-server-memory | Persistent knowledge graph |
| fetch | @anthropic-ai/mcp-server-fetch | Web content retrieval |
| sequential-thinking | @anthropic-ai/mcp-server-sequential-thinking | Complex reasoning |
| context7 | @upstash/context7-mcp | Library documentation |
| git | @anthropic-ai/mcp-server-git | Repository inspection |
| github | @modelcontextprotocol/server-github | GitHub API access |

**Config Locations** (inside container):
- Claude Code: `~/.config/claude/settings.json`
- Codex CLI: `~/.codex/config.toml`
- Gemini CLI: `~/.gemini/settings.json`

---

## Host Setup Script

### Decision: Minimal script focused only on Docker and gh

**Rationale**: Host needs very little - just Docker to run containers and gh for GitHub auth.

**Platform Detection**:
- Linux: Check /etc/os-release for ID
- macOS: `$(uname -s) == "Darwin"`
- WSL: /proc/version contains "microsoft"

**Installation Methods**:

| Tool | Linux (apt) | macOS | WSL |
|------|-------------|-------|-----|
| Docker | apt + docker.io or Docker Desktop | Docker Desktop | Docker Desktop (Windows) |
| gh | GitHub apt repo | brew | apt |

---

## Spec Kit Integration

### Decision: Use Spec Kit CLI then layer CodeBootstrap additions

**Rationale**: Spec Kit provides structured development workflow; CodeBootstrap adds container and MCP support

**new-project workflow**:
1. Run `specify init <name>` (creates Spec Kit structure)
2. Copy CodeBootstrap additions (devcontainer, MCP config)
3. Append context instructions to CLAUDE.md, AGENTS.md, GEMINI.md
4. Optionally create GitHub repo

---

## Alternatives Considered

### Why Not Native Bootstrap?

The original approach was a curl-pipe bash script that installed tools directly on the host. This was rejected because:
- Cross-platform complexity (apt vs brew vs dnf)
- Version conflicts with system packages
- No isolation between projects
- Hard to reproduce exact environment

### Why Not Nix?

Nix provides reproducible environments but:
- Steep learning curve
- Not integrated with VS Code/Codespaces ecosystem
- Overkill for this use case
