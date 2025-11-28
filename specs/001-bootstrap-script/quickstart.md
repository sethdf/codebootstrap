# Quickstart: CodeBootstrap

## Overview

CodeBootstrap provides a container-first development environment with Claude Code and 7 MCP servers pre-configured. Run locally (free) or in GitHub Codespaces (cloud).

## Option A: Local Development (Recommended)

### Prerequisites

- VS Code with Dev Containers extension (or Cursor) - install this yourself
- GitHub account
- Anthropic account (for Claude)

### 1. Prepare Your Host Machine

Run the host setup script to install Docker and GitHub CLI:

```bash
curl -fsSL https://raw.githubusercontent.com/sethdf/codebootstrap/main/host-setup.sh | bash
```

### 2. Clone and Open

```bash
git clone https://github.com/sethdf/codebootstrap.git
cd codebootstrap
code .
```

When VS Code opens, click **"Reopen in Container"**.

### 3. Start Developing

Once inside the container:

```bash
codebootstrap-status  # Verify setup
claude                # Start Claude Code
```

---

## Option B: GitHub Codespaces (Cloud)

1. Go to the repository on GitHub
2. Click **Code** → **Codespaces** → **Create codespace on main**
3. Wait for build (~2-5 minutes)
4. Run `claude` in the terminal

---

## Post-Setup: Authentication

Each tool authenticates separately on first use:

```text
AI Tool Authentication Required
===============================
Run each command once to authenticate:

  claude          → Opens browser for Anthropic OAuth
  codex auth      → Opens browser for ChatGPT OAuth
  gemini auth     → Opens browser for Google OAuth

After auth, use aliases: c, codex, gemini (YOLO mode enabled)
```

---

## Available Commands

### AI Tools (YOLO Mode)

| Command | Expands To | Description |
|---------|------------|-------------|
| `c` | `claude --dangerously-skip-permissions` | Start Claude (no prompts) |
| `cr` | `claude --dangerously-skip-permissions --resume` | Resume Claude session |
| `codex` | `codex --dangerously-bypass-approvals-and-sandbox` | Start Codex (no prompts) |
| `gemini` | `gemini --yolo` | Start Gemini (no prompts) |

### Project Management

| Command | Description |
|---------|-------------|
| `new-project <name>` | Create Spec Kit project with devcontainer |
| `quick-project <name>` | Create minimal project |
| `p [name]` | Jump to project or list all |
| `projects` | List projects with git status |

### Git Shortcuts

| Command | Description |
|---------|-------------|
| `gs` | Git status (short) |
| `glog` | Git log (pretty) |
| `parallel-claude <feature>` | Create worktree for parallel AI session |

### Maintenance

| Command | Description |
|---------|-------------|
| `codebootstrap-status` | Health check |
| `codebootstrap-update` | Update MCP servers |
| `speckit-owner [tool]` | Check/transfer Spec Kit ownership |

---

## MCP Servers Configured

These 7 MCP servers are pre-configured for all AI tools:

| Server | Purpose |
|--------|---------|
| filesystem | File operations |
| memory | Persistent knowledge graph |
| fetch | Web content retrieval |
| sequential-thinking | Complex problem solving |
| context7 | Library/framework documentation |
| git | Repository inspection |
| github | GitHub API access |

---

## Troubleshooting

### "Reopen in Container" not appearing

1. Ensure VS Code Dev Containers extension is installed
2. Ensure Docker is running: `docker info`
3. Reload VS Code window

### Claude not authenticated

```bash
claude  # Follow OAuth prompts
```

### MCP servers not working

```bash
codebootstrap-status  # Check configuration
codebootstrap-update  # Reinstall MCP packages
```
