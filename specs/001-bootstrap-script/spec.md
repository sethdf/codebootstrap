# Specification: Container-First Development Environment

**Feature**: 001-bootstrap-script
**Status**: Implementation Complete
**Date**: 2025-01-26

## Overview

A container-first development environment that provides Claude Code, OpenAI Codex CLI, Google Gemini CLI, and 7 MCP servers pre-configured. Works identically on local Docker and GitHub Codespaces.

## Functional Requirements

### Host Setup

- **FR-001**: Host setup script MUST be runnable via `curl -fsSL <url> | bash`
- **FR-002**: Host setup script MUST install Docker if not present
- **FR-003**: Host setup script MUST install GitHub CLI (gh) if not present
- **FR-004**: Host setup script MUST be idempotent (safe to run multiple times)
- **FR-005**: Host setup script MUST detect platform (macOS, Ubuntu, Debian, Fedora, WSL)
- **FR-006**: All scripts MUST print actions being taken to stdout for transparency

### Devcontainer

- **FR-007**: Devcontainer MUST work on local Docker Desktop
- **FR-008**: Devcontainer MUST work on GitHub Codespaces
- **FR-009**: Single devcontainer.json MUST work for both local and Codespaces
- **FR-010**: Container MUST include Node.js 20 LTS
- **FR-011**: Container MUST include Python 3.12+
- **FR-012**: Container MUST include uv (fast Python package manager)
- **FR-013**: Container MUST include git and gh CLI
- **FR-014**: Container MUST include jq for JSON processing

### AI Tools

- **FR-015**: Container MUST include Claude Code (`@anthropic-ai/claude-code`)
- **FR-016**: Post-create script MUST display auth instructions for all AI tools on first run
- **FR-017**: Auth instructions MUST include commands: `claude` (OAuth), `codex auth` (ChatGPT), `gemini auth` (Google)
- **FR-018**: Container MUST include OpenAI Codex CLI (`@openai/codex`)
- **FR-019**: Container MUST include Google Gemini CLI (`@google/gemini-cli`)

### MCP Configuration

- **FR-020**: MCP servers MUST be configured for Claude Code
- **FR-021**: MCP servers MUST be configured for Codex CLI
- **FR-022**: MCP servers MUST be configured for Gemini CLI
- **FR-023**: AI tool aliases MUST run in dangerous/YOLO mode by default:
  - `c` → `claude --dangerously-skip-permissions`
  - `codex` → `codex --dangerously-bypass-approvals-and-sandbox`
  - `gemini` → `gemini --yolo`
- **FR-024**: All 7 base MCP servers MUST be configured:
  - filesystem, memory, fetch, sequential-thinking, context7, git, github
- **FR-025**: Project-specific MCPs MUST be supported via `.claude/mcp-servers.json`
- **FR-026**: Context files MUST instruct AI tools to discover relevant MCPs

### Shell Environment

- **FR-027**: Shell aliases MUST be installed: c, cr, gs, ga, gc, gp, gl, glog
- **FR-028**: Shell functions MUST be installed: new-project, quick-project, p, projects
- **FR-029**: Maintenance functions MUST be installed: codebootstrap-status, codebootstrap-update
- **FR-030**: Advanced functions MUST be installed: parallel-claude, worktrees, project-status

### Project Creation

- **FR-031**: `new-project` MUST use Spec Kit CLI (`specify init`)
- **FR-032**: `new-project` MUST copy CodeBootstrap additions after Spec Kit init
- **FR-033**: `new-project` MUST prompt for GitHub repo creation
- **FR-034**: `quick-project` MUST create minimal project without Spec Kit
- **FR-035**: Context files MUST include MCP discovery instructions
- **FR-036**: Context files MUST include testing requirements

### Spec Kit Artifact Ownership

- **FR-037**: All AI tools MUST have read access to Spec Kit artifacts
- **FR-038**: Only ONE AI tool can have write access at a time (ownership lock)
- **FR-039**: Claude Code MUST be the default owner
- **FR-040**: Ownership transfer MUST be explicit via `speckit-owner <tool>` command
- **FR-041**: When switching AI tools, the new tool MUST check ownership before modifying specs
- **FR-042**: Lock state MUST be stored in `.specify/owner.lock`
- **FR-043**: Non-owner AI tools MUST refuse to modify Spec Kit artifacts

### Codespaces Compatibility

- **FR-044**: GITHUB_TOKEN MUST be available for GitHub MCP in Codespaces
- **FR-045**: Git credentials MUST work automatically in Codespaces
- **FR-046**: No local-only features in devcontainer.json

### CLI-Only Workflow

- **FR-047**: Devcontainer CLI MUST be supported (`devcontainer up`)
- **FR-048**: Direct docker run MUST be supported as fallback
- **FR-049**: All functionality MUST work without VS Code

## Non-Functional Requirements

- **NFR-001**: Container first open MUST complete in <60 seconds (after image cached)
- **NFR-002**: Host setup script MUST complete in <5 minutes on typical connection
- **NFR-003**: All scripts MUST be idempotent
- **NFR-004**: All configuration MUST be transparent (no hidden magic)
