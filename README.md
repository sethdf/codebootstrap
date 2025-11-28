# CodeBootstrap

A container-first development environment with AI coding tools pre-configured.

## What's Included

- **AI Tools**: Claude Code, OpenAI Codex CLI, Google Gemini CLI (all in YOLO mode)
- **MCP Servers**: 7 pre-configured servers (filesystem, memory, fetch, sequential-thinking, context7, git, github)
- **Dev Tools**: Node.js 20, Python 3.12, uv, git, gh
- **Shell Helpers**: Project management, git shortcuts, health checks

## Quick Start

### Option A: Local Development

1. **Prepare your host** (one-time):
   ```bash
   curl -fsSL https://raw.githubusercontent.com/sethdf/codebootstrap/main/host-setup.sh | bash
   ```

2. **Clone and open**:
   ```bash
   git clone https://github.com/sethdf/codebootstrap.git
   cd codebootstrap
   code .
   ```

3. Click **"Reopen in Container"** when prompted

### Option B: GitHub Codespaces

1. Click the green **Code** button on this repo
2. Select **Codespaces** → **Create codespace on main**
3. Wait for build (~2-5 min first time)

### Option C: CLI-Only

```bash
# Install devcontainer CLI
npm install -g @devcontainers/cli

# Start container
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . bash
```

## Usage

### AI Tools

All AI tools run in YOLO mode (no permission prompts):

| Command | Tool |
|---------|------|
| `c` | Claude Code |
| `cr` | Claude Code (resume session) |
| `codex` | OpenAI Codex CLI |
| `gemini` | Google Gemini CLI |

### First-Time Authentication

```bash
claude          # Opens browser for Anthropic OAuth
codex auth      # Opens browser for ChatGPT OAuth
gemini auth     # Opens browser for Google OAuth
```

### Project Management

```bash
new-project my-app     # Create Spec Kit project with devcontainer
quick-project scratch  # Create minimal project
p my-app               # Jump to project
projects               # List all projects with status
```

### Maintenance

```bash
codebootstrap-status   # Health check
codebootstrap-update   # Update MCP servers
```

## MCP Servers

Pre-configured for all AI tools:

| Server | Purpose |
|--------|---------|
| filesystem | File operations |
| memory | Persistent knowledge graph |
| fetch | Web content retrieval |
| sequential-thinking | Complex problem solving |
| context7 | Library documentation |
| git | Repository inspection |
| github | GitHub API access |

### Project-Specific MCPs

Add custom MCP servers in `.claude/mcp-servers.json`:

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": { "DATABASE_URL": "${DATABASE_URL}" }
    }
  }
}
```

## Structure

```
.devcontainer/
├── devcontainer.json    # Container definition
├── Dockerfile           # Image with all tools
├── post-create.sh       # MCP + shell setup
└── post-start.sh        # Startup tasks

templates/
├── bashrc.d/            # Shell helpers
├── mcp-servers.json     # Base MCP config
└── codebootstrap-additions/
    └── ...              # Template for new projects

host-setup.sh            # Host preparation script
```

## Requirements

**Host Machine**:
- Docker (Docker Desktop on macOS/Windows)
- VS Code with Dev Containers extension (or Cursor)
- GitHub account

**Accounts for AI Tools**:
- Anthropic account (Claude)
- OpenAI/ChatGPT account (Codex)
- Google account (Gemini - free tier available)

## Documentation

- [Quickstart Guide](specs/001-bootstrap-script/quickstart.md)
- [Shell Function Reference](specs/001-bootstrap-script/contracts/shell-functions.md)

## License

MIT
