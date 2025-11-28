# Data Model: Container-First Development Environment

**Feature**: 001-bootstrap-script
**Date**: 2025-01-26

## Overview

This project has no database. The "data model" consists of configuration files and directory structures that define the development environment.

## MCP Configuration

MCP servers are configured for all three AI tools.

**Claude Code** - `~/.config/claude/settings.json`:
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-filesystem", "/workspaces"]
    },
    "memory": { "command": "npx", "args": ["-y", "@anthropic-ai/mcp-server-memory"] },
    "fetch": { "command": "npx", "args": ["-y", "@anthropic-ai/mcp-server-fetch"] },
    "sequential-thinking": { "command": "npx", "args": ["-y", "@anthropic-ai/mcp-server-sequential-thinking"] },
    "context7": { "command": "npx", "args": ["-y", "@upstash/context7-mcp"] },
    "git": { "command": "npx", "args": ["-y", "@anthropic-ai/mcp-server-git", "--repository", "/workspaces"] },
    "github": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-github"], "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}" } }
  }
}
```

**Codex CLI** - `~/.codex/config.toml`:
```toml
[mcp_servers.filesystem]
command = "npx"
args = ["-y", "@anthropic-ai/mcp-server-filesystem", "/workspaces"]

[mcp_servers.memory]
command = "npx"
args = ["-y", "@anthropic-ai/mcp-server-memory"]
# ... etc
```

**Gemini CLI** - `~/.gemini/settings.json`:
Same structure as Claude Code.

## Spec Kit Ownership Lock

**Location**: `.specify/owner.lock`

```json
{
  "owner": "claude",
  "since": "2025-01-27T10:30:00Z",
  "transferred_from": null
}
```

**Fields**:
- `owner`: One of "claude", "codex", "gemini"
- `since`: ISO 8601 timestamp of ownership acquisition
- `transferred_from`: Previous owner (null if first owner)

## Shell Helper Files

**Location** (inside container): `~/.bashrc.d/`

| File | Purpose |
|------|---------|
| `00-path.sh` | PATH modifications |
| `10-aliases.sh` | Short aliases (c, cr, gs, ga, gc, gp, gl, glog) |
| `20-functions.sh` | Helper functions (new-project, p, projects, etc.) |

## Project-Specific MCP Configuration

**Location** (per project): `.claude/mcp-servers.json`

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

Project MCPs are merged with base 7 MCPs at runtime.
