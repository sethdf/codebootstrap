# Tasks: Container-First Development Environment

**Input**: Design documents from `/specs/001-bootstrap-script/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Manual testing - open devcontainer locally, open in Codespaces, verify tools work.

**Organization**: Tasks are grouped by component to enable independent implementation.

## Format: `[ID] [P?] [Component] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Component]**: Which component this task belongs to (HOST, CONTAINER, MCP, SHELL, TEMPLATE)
- Include exact file paths in descriptions

## Path Conventions

```text
host-setup.sh               # Minimal host setup script

.devcontainer/
├── devcontainer.json       # Main devcontainer definition
├── Dockerfile              # Container image
├── post-create.sh          # Runs after container creation
└── post-start.sh           # Runs on every container start

templates/
├── bashrc.d/               # Shell helper templates
├── claude-mcp.json         # MCP configuration template
└── project/                # Spec Kit project template
```

---

## Phase 1: Devcontainer Foundation

**Purpose**: Create the core devcontainer that works locally and in Codespaces

**Checkpoint Test**: Open project in VS Code, select "Reopen in Container", verify container builds

- [x] T001 [CONTAINER] Create .devcontainer/devcontainer.json with base configuration
- [x] T002 [CONTAINER] Create .devcontainer/Dockerfile with base image and system packages
- [x] T003 [P] [CONTAINER] Add Node.js 20 installation to Dockerfile
- [x] T004 [P] [CONTAINER] Add Python 3.12 + uv installation to Dockerfile
- [x] T005 [CONTAINER] Add AI tools to Dockerfile: Claude Code, Codex CLI, Gemini CLI
- [x] T006 [CONTAINER] Add Spec Kit CLI to Dockerfile (`pip install specify-cli` or equivalent)
- [x] T007 [CONTAINER] Add jq and other utility packages to Dockerfile
- [x] T008 [CONTAINER] Test: Build container locally with `docker build`

**Checkpoint**: Container builds successfully with all tools installed

---

## Phase 2: Post-Creation Scripts

**Purpose**: Configure the container after creation (MCP, shell, etc.)

**Checkpoint Test**: Container opens, claude is configured, shell helpers work

- [x] T009 [CONTAINER] Create .devcontainer/post-create.sh skeleton with shebang and permissions
- [x] T010 [CONTAINER] Create .devcontainer/post-start.sh skeleton
- [x] T011 [CONTAINER] Add MCP configuration to post-create.sh (create ~/.config/claude/settings.json)
- [x] T012 [CONTAINER] Add shell helper installation to post-create.sh (copy bashrc.d files)
- [x] T013 [CONTAINER] Add projects directory creation to post-create.sh
- [x] T014 [CONTAINER] Make scripts executable in Dockerfile (chmod +x)

**Checkpoint**: Post-create script runs, MCP and shell configured

---

## Phase 3: MCP Configuration

**Purpose**: Configure all 7 MCP servers for all three AI tools

**Checkpoint Test**: Start each AI tool in container, verify MCP tools respond

- [x] T015 [MCP] Create templates/mcp-servers.json with all 7 MCP servers
- [x] T016 [P] [MCP] Create Claude Code config generator (JSON format)
- [x] T017 [P] [MCP] Create Codex CLI config generator (TOML format)
- [x] T018 [P] [MCP] Create Gemini CLI config generator (JSON format)
- [x] T019 [MCP] Update post-create.sh to generate configs for all three tools
- [ ] T020 [MCP] Test: Verify MCPs work in Claude (`claude`)
- [ ] T021 [MCP] Test: Verify MCPs work in Codex (`codex`)
- [ ] T022 [MCP] Test: Verify MCPs work in Gemini (`gemini`)

**Checkpoint**: All 7 MCP servers configured and functional in all AI tools

---

## Phase 4: Shell Helpers

**Purpose**: Install shell aliases and functions

**Checkpoint Test**: Open terminal in container, verify aliases work

- [x] T023 [P] [SHELL] Create templates/bashrc.d/00-path.sh
- [x] T024 [P] [SHELL] Create templates/bashrc.d/10-aliases.sh (c, cr, gs, ga, gc, gp, gl, glog)
- [x] T025 [SHELL] Create templates/bashrc.d/20-functions.sh skeleton
- [x] T026 [SHELL] Implement new-project function in 20-functions.sh
- [x] T027 [SHELL] Implement quick-project function in 20-functions.sh
- [x] T028 [SHELL] Implement p and projects functions in 20-functions.sh
- [x] T029 [SHELL] Implement project-status function in 20-functions.sh
- [x] T030 [SHELL] Implement parallel-claude and worktrees functions in 20-functions.sh
- [x] T031 [SHELL] Implement codebootstrap-status function in 20-functions.sh
- [x] T032 [SHELL] Implement codebootstrap-update function in 20-functions.sh
- [x] T033 [SHELL] Implement speckit-owner function in 20-functions.sh
- [x] T034 [SHELL] Update post-create.sh to install bashrc.d files and source them
- [x] T035 [SHELL] Update post-create.sh to create default .specify/owner.lock (claude as default owner)

**Checkpoint**: All shell helpers available and functional

---

## Phase 5: Project Template

**Purpose**: Create template for new projects created with new-project

### 5a: CodeBootstrap Additions (on top of Spec Kit)
- [x] T036 [TEMPLATE] Create templates/codebootstrap-additions/ directory structure
- [x] T037 [TEMPLATE] Create templates/codebootstrap-additions/.devcontainer/devcontainer.json
- [x] T038 [TEMPLATE] Create templates/codebootstrap-additions/.claude/mcp-servers.json (empty template)
- [x] T039 [TEMPLATE] Create MCP discovery instructions to append to context files
- [x] T040 [TEMPLATE] Create Spec Kit ownership instructions to append to context files

### 5b: new-project Function
- [x] T041 [SHELL] Implement new-project to call `specify init <name>`
- [x] T042 [SHELL] Implement new-project to copy CodeBootstrap additions after init
- [x] T043 [SHELL] Implement new-project to append MCP discovery instructions to context files
- [x] T044 [SHELL] Implement new-project to create .specify/owner.lock (claude as default)
- [x] T045 [SHELL] Implement GitHub repo creation prompt

**Checkpoint**: new-project uses Spec Kit CLI, adds CodeBootstrap enhancements, works with all AI tools

---

## Phase 6: Host Setup Script

**Purpose**: Minimal script to prepare host for devcontainers (Docker + gh only)

**Checkpoint Test**: Run on fresh Ubuntu/macOS/WSL, then open devcontainer project

- [x] T046 [HOST] Create host-setup.sh with shebang and strict mode
- [x] T047 [HOST] Add platform detection functions (detect_os, detect_wsl)
- [x] T048 [HOST] Add color output functions (info, success, warn, error)
- [x] T049 [HOST] Implement install_docker function (platform-specific)
- [x] T050 [HOST] Implement install_gh function
- [x] T051 [HOST] Add GitHub authentication guidance (gh auth login)
- [x] T052 [HOST] Add idempotency checks (skip if already installed)
- [x] T053 [HOST] Add summary output with next steps

**Checkpoint**: Host setup complete, ready for devcontainer development

---

## Phase 7: Codespaces Compatibility

**Purpose**: Ensure everything works in GitHub Codespaces

**Checkpoint Test**: Create Codespace from repo, verify identical experience

- [x] T054 [CONTAINER] Add Codespaces-specific environment detection to post-create.sh
- [x] T055 [CONTAINER] Conditionally configure GitHub MCP token in Codespaces
- [ ] T056 [CONTAINER] Test devcontainer.json in Codespaces (no local-only features)
- [x] T057 [CONTAINER] Document any Codespaces-specific setup in quickstart.md

**Checkpoint**: Same devcontainer works local and in Codespaces

---

## Phase 8: Documentation & Polish

**Purpose**: Final documentation and testing

- [x] T058 Update quickstart.md with container-first instructions
- [x] T059 Add README.md to repository root with overview
- [ ] T060 Final test: Fresh Ubuntu VM → host-setup → open project → verify all AI tools + MCPs
- [ ] T061 Final test: Create Codespace → verify identical experience
- [ ] T062 Final test: new-project → verify template fetch + override works correctly
- [ ] T063 Final test: speckit-owner → verify ownership transfer works

---

## Notes

- Primary work is in `.devcontainer/` and `templates/`
- Test locally after each phase checkpoint
- Test in Codespaces after Phase 7
- Commit after each phase completion
- [P] tasks within same phase can be done in any order
