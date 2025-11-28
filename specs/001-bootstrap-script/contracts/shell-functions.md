# Shell Function Contracts

**Feature**: 001-bootstrap-script
**Date**: 2025-01-26

## Aliases

### AI Tool Aliases (YOLO Mode)

```bash
alias c='claude --dangerously-skip-permissions'
alias cr='claude --dangerously-skip-permissions --resume'
alias codex='codex --dangerously-bypass-approvals-and-sandbox'
alias gemini='gemini --yolo'
```

### Git Aliases

```bash
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph -20'
```

---

## Functions

### `new-project`

**Signature**: `new-project <project-name>`

**Behavior**:
1. Validates project name (alphanumeric + hyphens)
2. Runs `specify init <name>` if Spec Kit CLI available
3. Copies CodeBootstrap additions
4. Prompts for GitHub repo creation

**Exit Codes**: 0 (success), 1 (invalid name or exists), 2 (Spec Kit error)

---

### `quick-project`

**Signature**: `quick-project <project-name>`

**Behavior**: Creates minimal project with CLAUDE.md and .gitignore (no Spec Kit)

---

### `p`

**Signature**: `p [project-name]`

**Behavior**:
- With name: `cd ~/projects/<name>`
- Without name: List all projects

---

### `projects`

**Signature**: `projects`

**Behavior**: Lists all projects in ~/projects/ with git status indicator

---

### `codebootstrap-status`

**Signature**: `codebootstrap-status`

**Checks**:
- git installed
- gh installed and authenticated
- node >= 18
- python >= 3.12
- claude installed
- MCP config has 7 servers
- Shell helpers loaded

---

### `codebootstrap-update`

**Signature**: `codebootstrap-update`

**Behavior**: Updates all 7 MCP server npm packages to latest

---

### `speckit-owner`

**Signature**: `speckit-owner [tool-name]`

**Behavior**:
- No args: Show current owner
- With tool: Transfer ownership to claude/codex/gemini

**Lock File**: `.specify/owner.lock`
```json
{
  "owner": "claude",
  "since": "2025-01-27T10:30:00Z",
  "transferred_from": null
}
```

---

### `parallel-claude`

**Signature**: `parallel-claude <feature-name>`

**Behavior**: Creates git worktree at `../<repo>-<feature>` with branch `feature/<name>`

---

### `worktrees`

**Signature**: `worktrees`

**Behavior**: Lists all git worktrees for current repository
