# CodeBootstrap Development Guidelines

## Project Overview

CodeBootstrap is a container-first development environment with Claude Code, Codex CLI, Gemini CLI, and 7 MCP servers pre-configured.

## Prohibited Destructive Operations

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

## Project Structure

```
.devcontainer/          # Container configuration
templates/              # Templates for new projects
  bashrc.d/             # Shell helpers
  mcp-servers.json      # MCP server config
  codebootstrap-additions/  # Files added to new projects
specs/                  # Feature specifications
.specify/               # Meta Spec Kit (for developing codebootstrap)
host-setup.sh           # Host machine setup script
```

## Commands

```bash
# Inside container
codebootstrap-status    # Health check
codebootstrap-update    # Update MCP servers
new-project <name>      # Create Spec Kit project
quick-project <name>    # Create minimal project
```

## Testing

Before committing:
1. Ensure devcontainer builds: Reopen in Container
2. Run `codebootstrap-status` - all checks should pass
3. Test any modified shell functions
