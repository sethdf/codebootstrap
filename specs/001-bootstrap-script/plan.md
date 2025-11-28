# Implementation Plan: Container-First Development Environment

**Branch**: `001-bootstrap-script` | **Date**: 2025-01-27 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-bootstrap-script/spec.md`

## Summary

Build a container-first development environment using devcontainers that works identically on local Docker and GitHub Codespaces. The container includes Claude Code, OpenAI Codex CLI, Google Gemini CLI, and 7 pre-configured MCP servers. A minimal host setup script installs only Docker and GitHub CLI. The `new-project` command uses Spec Kit CLI with CodeBootstrap additions layered on top.

## Technical Context

**Language/Version**: Bash scripts (POSIX-compatible), Dockerfile
**Primary Dependencies**: Docker, VS Code Dev Containers, devcontainer features
**Storage**: N/A (configuration files only)
**Testing**: Manual testing - open devcontainer locally, open in Codespaces, verify tools work
**Target Platform**: Linux containers (Docker Desktop on macOS/Windows, native Docker on Linux)
**Project Type**: single (configuration/tooling project)
**Performance Goals**: Container opens in <60 seconds (after first build)
**Constraints**: Single devcontainer.json must work on local Docker AND Codespaces
**Scale/Scope**: Single developer setup, supports unlimited projects

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Container-First Development | ✅ PASS | Core design - all tools in devcontainer |
| II. One Definition, Runs Anywhere | ✅ PASS | Single devcontainer.json for local + Codespaces |
| III. Minimal Host Requirements | ✅ PASS | Host only needs Docker + gh |
| IV. Idempotency Always | ✅ PASS | Re-running scripts is safe |
| V. Transparency Over Convenience | ✅ PASS | Explicit Dockerfile, readable config |
| VI. AI-First Development | ✅ PASS | 3 AI tools + 7 MCPs pre-configured |
| VII. Security by Default | ✅ PASS | Credentials forwarded, not copied |
| VIII. Local-First, Cloud-Optional | ✅ PASS | Local is default, Codespaces optional |

**Constitution Check Result**: ✅ ALL GATES PASS

## Project Structure

### Documentation (this feature)

```text
specs/001-bootstrap-script/
├── plan.md              # This file
├── spec.md              # Feature specification
├── research.md          # Tool decisions and rationale
├── data-model.md        # Configuration file schemas
├── quickstart.md        # User-facing documentation
├── contracts/           # Shell function contracts
│   └── shell-functions.md
└── tasks.md             # Implementation tasks
```

### Source Code (repository root)

```text
host-setup.sh               # Minimal host setup script (Docker + gh only)

.devcontainer/
├── devcontainer.json       # Main devcontainer definition
├── Dockerfile              # Container image with all tools
├── post-create.sh          # Runs after container creation (MCP config, shell setup)
└── post-start.sh           # Runs on every container start

templates/
├── bashrc.d/               # Shell helper templates
│   ├── 00-path.sh          # PATH modifications
│   ├── 10-aliases.sh       # Short aliases (c, gs, etc.)
│   └── 20-functions.sh     # Helper functions (new-project, etc.)
├── mcp-servers.json        # Base MCP server definitions
└── codebootstrap-additions/
    ├── .devcontainer/
    │   └── devcontainer.json
    ├── .claude/
    │   └── mcp-servers.json
    └── context-append.md   # MCP discovery instructions for context files
```

**Structure Decision**: Single project structure. This is a configuration/tooling project with shell scripts and devcontainer definitions. No backend/frontend split needed.

## Key Decisions

1. **Three AI tools, not just Claude**: Include Codex CLI and Gemini CLI since they all support MCP
2. **Spec Kit integration**: Use `specify init` then layer CodeBootstrap additions on top
3. **CLI-only workflow**: Support `devcontainer CLI` and `docker run` without VS Code
4. **Project-specific MCPs**: Support `.claude/mcp-servers.json` for project-specific MCP servers
5. **Dynamic MCP discovery**: Context files instruct AI tools to search for relevant MCPs
6. **YOLO mode by default**: All AI tool aliases run in dangerous mode (no permission prompts)
7. **Spec Kit ownership lock**: Only one AI tool can modify spec artifacts at a time (prevents conflicts)

## References

- [spec.md](./spec.md) - Feature specification
- [research.md](./research.md) - Technical decisions and rationale
- [data-model.md](./data-model.md) - Configuration schemas
- [contracts/shell-functions.md](./contracts/shell-functions.md) - Shell function contracts
- [quickstart.md](./quickstart.md) - User documentation
- [tasks.md](./tasks.md) - Implementation tasks
