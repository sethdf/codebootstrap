# CodeBootstrap Constitution

## Core Principles

### I. Container-First
All development happens inside containers. The host machine only needs Docker and a code editor. No tools installed directly on host except Docker and gh CLI.

### II. AI Tool Agnostic
Support all major AI coding assistants equally: Claude Code, Codex CLI, Gemini CLI. Same MCP servers, same shell helpers, same experience.

### III. YOLO Mode Default
AI tools run without permission prompts by default. Developers opt into this workflow - trust the tools, move fast.

### IV. Spec Kit Integration
New projects use Spec Kit for structured development. CodeBootstrap adds container and MCP support on top.

### V. Simplicity
Minimal host setup. Single devcontainer config works locally and in Codespaces. No complex configuration required.

## Safety Requirements

### Prohibited Destructive Operations

**NEVER run these commands** - they can cause irreversible data loss:

- `git gc --prune=now` - Permanently deletes unreachable objects
- `git reflog expire --expire=now --all` - Destroys recovery history
- `git filter-branch` - Rewrites history (use only with explicit user approval)
- `git reset --hard` on shared branches - Loses uncommitted work
- `git push --force` to main/master - Overwrites shared history
- `rm -rf .git` - Destroys entire repository
- `git clean -fdx` without confirmation - Deletes untracked files permanently

**Before any history-rewriting operation**:
1. Confirm with the user that they understand the risks
2. Ensure there's a backup (push to remote first)
3. Never combine multiple destructive operations

**Safe alternatives**:
- Use `git revert` instead of `git reset --hard` for undoing commits
- Use `git stash` instead of discarding changes
- Use `git push --force-with-lease` instead of `--force` (fails if remote changed)

## Development Workflow

1. Use Spec Kit to plan features (`/speckit.plan`, `/speckit.tasks`)
2. Implement inside container
3. Test with `codebootstrap-status`
4. Commit only when tests pass

## Governance

This constitution governs development of CodeBootstrap itself. Child projects created with `new-project` get their own vanilla Spec Kit plus CodeBootstrap additions.

**Version**: 1.0.0 | **Ratified**: 2025-01-28 | **Last Amended**: 2025-01-28
