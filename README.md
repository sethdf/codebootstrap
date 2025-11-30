# CodeBootstrap

A container-first development environment with AI coding tools pre-configured.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           YOUR HOST MACHINE                                  │
│                     (macOS, Windows, or Linux)                              │
│                                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │    Docker    │  │  GitHub CLI  │  │   VS Code    │  │ Dev Container│    │
│  │   Desktop    │  │     (gh)     │  │              │  │  Extension   │    │
│  └──────┬───────┘  └──────────────┘  └──────┬───────┘  └──────────────┘    │
│         │                                    │                              │
│         │         Installed by host-setup.sh │                              │
└─────────┼────────────────────────────────────┼──────────────────────────────┘
          │                                    │
          │  runs                    connects  │
          │                                    │
          ▼                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        DOCKER CONTAINER                                      │
│                    (Your actual dev environment)                            │
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                         AI CODING TOOLS                              │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐              │   │
│  │  │ Claude Code  │  │  Codex CLI   │  │  Gemini CLI  │              │   │
│  │  │     (c)      │  │   (codex)    │  │   (gemini)   │              │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘              │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                         MCP SERVERS (7)                              │   │
│  │  filesystem │ memory │ fetch │ sequential-thinking │ context7 │ ... │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                         DEV TOOLS                                    │   │
│  │  Node.js 20 │ Python 3.12 │ uv │ git │ gh │ Spec Kit CLI           │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    /workspaces/projects/          (Docker Volume)    │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐                          │   │
│  │  │ project1 │  │ project2 │  │ project3 │   ← Persists across      │   │
│  │  └──────────┘  └──────────┘  └──────────┘     container rebuilds   │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Quick Start (New Machine)

### One-Liner Setup

Run this single command on a fresh machine:

```bash
curl -fsSL https://raw.githubusercontent.com/sethdf/codebootstrap/main/host-setup.sh | bash
```

**What happens:**
1. Detects your OS (macOS, Ubuntu, Fedora, etc.)
2. Installs Docker (or tells you to install Docker Desktop on macOS/Windows)
3. Installs GitHub CLI (`gh`)
4. Installs VS Code
5. Clones CodeBootstrap to `~/codebootstrap`
6. Installs the Dev Containers extension
7. Opens VS Code in the codebootstrap folder

### After the Script Completes

1. **VS Code opens** with the codebootstrap folder
2. **Click "Reopen in Container"** when prompted (bottom-right popup)
3. **Wait ~2-5 minutes** for the container to build (first time only)
4. **Authenticate AI tools** (one-time):
   ```bash
   claude          # Opens browser for Anthropic OAuth
   codex auth      # Opens browser for OpenAI OAuth
   gemini auth     # Opens browser for Google OAuth
   ```
5. **Start working!**
   ```bash
   new-project my-app    # Create a new project
   # OR
   clone-project         # Clone from your GitHub repos
   ```

---

## Step-by-Step Workflow

### Step 1: Host Setup (One-Time Per Machine)

```bash
curl -fsSL https://raw.githubusercontent.com/sethdf/codebootstrap/main/host-setup.sh | bash
```

| What Gets Installed | Where | Why |
|---------------------|-------|-----|
| Docker | Host OS | Runs the dev container |
| GitHub CLI | Host OS | Authentication with GitHub |
| VS Code | Host OS | Your editor (runs on host, connects to container) |
| Dev Containers ext | VS Code | Enables "Reopen in Container" |
| CodeBootstrap repo | ~/codebootstrap | The container definition |

### Step 2: Open in Container

When VS Code opens, you'll see a popup:

```
Folder contains a Dev Container configuration file.
[Reopen in Container]  [Don't Show Again]
```

Click **"Reopen in Container"**.

**What happens:**
1. Docker builds the container image (downloads Node, Python, AI tools, etc.)
2. Mounts your code into the container
3. Runs `post-create.sh` which:
   - Configures MCP servers for Claude, Codex, and Gemini
   - Installs shell helpers (aliases, functions)
   - Sets up Spec Kit ownership
4. VS Code reconnects, now running INSIDE the container
5. Terminal opens with all tools available

### Step 3: Authenticate AI Tools (One-Time)

Each AI tool needs OAuth authentication the first time:

```bash
# Run each once - browser will open for OAuth
claude
codex auth
gemini auth
```

**Troubleshooting OAuth:**
If the OAuth callback fails ("site can't be reached localhost:XXXXX"):
1. Look at the URL in the error - note the port number
2. In VS Code, go to the **Ports** tab (bottom panel)
3. Forward that port
4. Retry the auth command

### Step 4: Create or Clone a Project

**Option A: New project with Spec Kit**
```bash
new-project my-app
```
Creates: `/workspaces/projects/my-app/` with Spec Kit structure

**Option B: Minimal project (no Spec Kit)**
```bash
quick-project scratch
```

**Option C: Clone from GitHub**
```bash
clone-project
```
Shows an interactive list of your GitHub repos to choose from.

### Step 5: Work on Your Project

```bash
# Switch to your project
p my-app

# Start an AI assistant
c                    # Claude Code (YOLO mode)
codex               # OpenAI Codex CLI
gemini              # Google Gemini CLI

# Resume a Claude session
cr
```

---

## Common Scenarios

### Scenario: Returning to Work (Same Machine)

1. Open VS Code
2. Recent folder: `~/codebootstrap`
3. If not in container: **"Reopen in Container"**
4. `p my-project` to jump to your project
5. `c` to start Claude

### Scenario: New Machine, Existing Projects

1. Run the one-liner: `curl -fsSL ... | bash`
2. Open in container
3. Authenticate AI tools
4. `clone-project` to clone your existing repos
5. Projects are now in `/workspaces/projects/`

### Scenario: Container Rebuild (After Pulling Updates)

Sometimes you need to rebuild the container:
- VS Code: `Cmd/Ctrl+Shift+P` → "Dev Containers: Rebuild Container"

**Your projects are safe!** They're stored in a Docker volume that persists across rebuilds.

### Scenario: Working Without VS Code (CLI Only)

```bash
# Install devcontainer CLI
npm install -g @devcontainers/cli

# Start container
cd ~/codebootstrap
devcontainer up --workspace-folder .

# Enter the container
devcontainer exec --workspace-folder . bash
```

### Scenario: Using GitHub Codespaces (No Local Docker)

1. Go to https://github.com/sethdf/codebootstrap
2. Click **Code** → **Codespaces** → **Create codespace on main**
3. Wait for build (~2-5 min)
4. Authenticate AI tools
5. Everything else works the same

### Scenario: OAuth Callback Port Issue

When authenticating AI tools, if you see "site can't be reached":

```
http://localhost:46437/callback?code=...
           ↑
      Note this port
```

**Fix:**
1. VS Code bottom panel → **Ports** tab
2. Click **Forward a Port**
3. Enter the port number (e.g., `46437`)
4. Retry the auth command

### Scenario: Projects Disappeared After Rebuild

Projects should persist in the Docker volume. If they disappeared:

```bash
# Check the volume
docker volume ls | grep codebootstrap

# Projects should be in
ls /workspaces/projects/
```

If the volume was accidentally deleted, you'll need to re-clone your projects.

---

## Command Reference

### AI Tools (YOLO Mode Enabled)

| Command | Description |
|---------|-------------|
| `c` | Start Claude Code |
| `cr` | Resume last Claude session |
| `codex` | Start OpenAI Codex CLI |
| `gemini` | Start Google Gemini CLI |

### Project Management

| Command | Description |
|---------|-------------|
| `new-project <name>` | Create project with Spec Kit + devcontainer |
| `quick-project <name>` | Create minimal project |
| `clone-project [repo]` | Clone from GitHub (interactive if no repo given) |
| `p [name]` | List projects or jump to one |
| `projects` | List all projects with git status |

### Spec Kit (Inside a Project)

| Command | Description |
|---------|-------------|
| `todos` | Show project todos from tasks.md |
| `wip` | Mark task in progress |
| `unwip` | Mark task completed |
| `spec-init` | Initialize Spec Kit in existing project |

### Utilities

| Command | Description |
|---------|-------------|
| `codebootstrap-status` | Health check all tools |
| `codebootstrap-update` | Update MCP servers |
| `backup` | Show backup paths |
| `today` | Git activity today |
| `ports` | List forwarded ports |
| `tree [depth]` | Project structure (default depth 2) |

### Git Shortcuts

| Command | Description |
|---------|-------------|
| `gs` | git status |
| `gd` | git diff |
| `gl` | git log --oneline -20 |
| `gp` | git pull |
| `gpu` | git push |
| `gcm "msg"` | git commit -m |

---

## MCP Servers

Pre-configured for all three AI tools:

| Server | Purpose | Example Use |
|--------|---------|-------------|
| filesystem | Read/write files | Editing code |
| memory | Persistent knowledge graph | Remember context across sessions |
| fetch | Retrieve web content | Get documentation |
| sequential-thinking | Multi-step reasoning | Complex problem solving |
| context7 | Library documentation | Look up API docs |
| git | Repository operations | Inspect git history |
| github | GitHub API | Create PRs, issues |

### Adding Project-Specific MCP Servers

Create `.claude/mcp-servers.json` in your project:

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

---

## File Structure

```
~/codebootstrap/                    ← Cloned to your home directory
├── .devcontainer/
│   ├── devcontainer.json          # Container config + volume mount
│   ├── Dockerfile                 # Image with all tools
│   ├── post-create.sh             # MCP + shell setup (runs once)
│   └── post-start.sh              # Startup tasks (runs each start)
├── templates/
│   ├── bashrc.d/                  # Shell helpers (aliases, functions)
│   └── codebootstrap-additions/   # Template for new projects
├── host-setup.sh                  # Host machine setup script
└── README.md                      # This file

/workspaces/projects/               ← Docker volume (persists!)
├── my-app/                        # Your projects live here
├── another-project/
└── ...
```

---

## Requirements

### Host Machine
- Docker Desktop (macOS/Windows) or Docker Engine (Linux)
- VS Code with Dev Containers extension
- GitHub account

### AI Tool Accounts
- **Claude**: Anthropic account (Claude Pro or Team recommended)
- **Codex**: OpenAI/ChatGPT account
- **Gemini**: Google account (free tier available)

---

## Remote Development with Tailscale

Tailscale creates a secure mesh VPN between your devices, making it easy to code on remote machines from anywhere.

### Architecture with Tailscale

```
┌─────────────────────────────────┐         ┌─────────────────────────────────┐
│      YOUR LOCAL MACHINE         │         │      REMOTE DEV MACHINE         │
│        (laptop/desktop)         │         │    (home server, cloud VM)      │
│                                 │         │                                 │
│  ┌───────────────────────────┐ │         │ ┌───────────────────────────┐   │
│  │  VS Code                  │ │         │ │  Docker + CodeBootstrap   │   │
│  │  + Remote-SSH extension   │ │  SSH    │ │  (devcontainer running)   │   │
│  │                           │─┼─────────┼─│                           │   │
│  └───────────────────────────┘ │  over   │ │  Claude, Codex, Gemini    │   │
│                                 │Tailscale│ │  MCP servers, projects    │   │
│  ┌───────────────────────────┐ │         │ └───────────────────────────┘   │
│  │  Tailscale client         │ │         │                                 │
│  │  (100.x.x.x)              │ │         │ ┌───────────────────────────┐   │
│  └───────────────────────────┘ │         │ │  Tailscale client         │   │
│                                 │         │ │  (100.x.x.x)              │   │
└─────────────────────────────────┘         │ │  + Tailscale SSH enabled  │   │
                                            │ └───────────────────────────┘   │
                                            └─────────────────────────────────┘
```

### Step 1: Install Tailscale on Both Machines

**On your local machine (where you'll code from):**

```bash
# macOS
brew install tailscale
# Then open Tailscale from Applications

# Ubuntu/Debian
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# Windows
# Download from https://tailscale.com/download/windows
```

**On your remote machine (where CodeBootstrap will run):**

```bash
# Ubuntu/Debian (most common for servers)
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --ssh
#                  ↑
#          Enables Tailscale SSH!
```

### Step 2: Enable Tailscale SSH on Remote Machine

Tailscale SSH lets you SSH without managing keys - it uses your Tailscale identity.

```bash
# On the REMOTE machine, ensure SSH is enabled
sudo tailscale up --ssh

# Verify it's working
tailscale status
```

You should see your machines listed with their Tailscale IPs (100.x.x.x).

### Step 3: Configure Tailscale Admin Console

1. Go to https://login.tailscale.com/admin/machines
2. Find your remote machine
3. Click the **...** menu → **Edit ACLs** or check **SSH** settings
4. Ensure SSH is allowed for your user

**Optional: Enable MagicDNS** (recommended)
- Go to **DNS** tab in admin console
- Enable **MagicDNS**
- Now you can use hostnames instead of IPs: `ssh remote-server` instead of `ssh 100.x.x.x`

### Step 4: Test SSH Connection

From your local machine:

```bash
# Using Tailscale IP
ssh user@100.x.x.x

# Or with MagicDNS enabled (use machine name)
ssh user@remote-server

# Tailscale SSH (no keys needed!)
ssh user@remote-server
```

### Step 5: Set Up CodeBootstrap on Remote Machine

SSH into your remote machine and run the setup:

```bash
# Connect to remote machine
ssh user@remote-server

# Run CodeBootstrap setup
curl -fsSL https://raw.githubusercontent.com/sethdf/codebootstrap/main/host-setup.sh | bash
```

### Step 6: Connect VS Code via Remote-SSH

**Install Remote-SSH extension** (on your local VS Code):
1. Open VS Code
2. Install extension: `ms-vscode-remote.remote-ssh`

**Connect to remote machine:**
1. `Cmd/Ctrl+Shift+P` → "Remote-SSH: Connect to Host..."
2. Enter: `user@remote-server` (or `user@100.x.x.x`)
3. VS Code opens connected to remote machine
4. Open folder: `~/codebootstrap`
5. Click **"Reopen in Container"**

Now you're running VS Code locally, connected to a devcontainer on your remote machine!

### Workflow: Remote Development

```
Local Machine                    Remote Machine
─────────────                    ──────────────
VS Code              ──SSH──►    CodeBootstrap container
(thin client)       Tailscale    - Claude Code
                                 - All AI tools
                                 - Your projects
```

**Daily workflow:**
1. Open VS Code locally
2. `Cmd/Ctrl+Shift+P` → "Remote-SSH: Connect to Host..." → `remote-server`
3. Open `~/codebootstrap`
4. "Reopen in Container"
5. `p my-project` and start coding

### SSH Config for Convenience

Add to `~/.ssh/config` on your local machine:

```
Host dev
    HostName remote-server    # Or 100.x.x.x
    User your-username
    ForwardAgent yes
```

Now connect with just:
```bash
ssh dev
# Or in VS Code: connect to "dev"
```

### Tailscale + Codespaces Alternative

If you don't want to manage a remote server, you can also:
1. Use GitHub Codespaces (cloud-hosted devcontainer)
2. Install Tailscale in the Codespace for accessing other Tailscale resources

### Troubleshooting Tailscale

**Can't connect via Tailscale SSH:**
```bash
# Check Tailscale status on remote
tailscale status

# Ensure SSH is enabled
sudo tailscale up --ssh

# Check if tailscaled is running
sudo systemctl status tailscaled
```

**MagicDNS not resolving:**
- Ensure MagicDNS is enabled in admin console
- Try flushing DNS: `sudo systemd-resolve --flush-caches`
- Fall back to IP: `ssh user@100.x.x.x`

**Permission denied:**
- Check Tailscale ACLs in admin console
- Ensure your user has SSH access in ACL policy

**VS Code Remote-SSH slow:**
- Tailscale uses direct connections when possible
- If going through relay (DERP), check firewall/NAT settings
- Run `tailscale netcheck` to diagnose

---

## Troubleshooting

### "Reopen in Container" not appearing
- Ensure Dev Containers extension is installed
- Try: `Cmd/Ctrl+Shift+P` → "Dev Containers: Reopen in Container"

### Docker not running
- macOS/Windows: Start Docker Desktop
- Linux: `sudo systemctl start docker`

### AI tool says "not authenticated"
- Run the auth command: `claude`, `codex auth`, or `gemini auth`
- If OAuth callback fails, forward the port in VS Code

### Projects not persisting
- Ensure the volume mount exists in devcontainer.json
- Check: `docker volume ls | grep codebootstrap`

### Permission denied on /workspaces/projects
- Run: `sudo chown -R vscode:vscode /workspaces/projects`

### Container build fails
- Try: "Dev Containers: Rebuild Container Without Cache"
- Check Docker has enough disk space

---

## License

MIT
