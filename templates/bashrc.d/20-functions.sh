#!/bin/bash
# 20-functions.sh - Helper functions for CodeBootstrap

# ============================================
# Color output helpers
# ============================================
_cb_green() { echo -e "\033[0;32m$1\033[0m"; }
_cb_red() { echo -e "\033[0;31m$1\033[0m"; }
_cb_yellow() { echo -e "\033[0;33m$1\033[0m"; }
_cb_blue() { echo -e "\033[0;34m$1\033[0m"; }

# ============================================
# new-project - Create a new Spec Kit project
# ============================================
new-project() {
    local name="$1"

    if [ -z "$name" ]; then
        echo "Usage: new-project <project-name>"
        return 1
    fi

    # Validate project name (alphanumeric + hyphens)
    if ! [[ "$name" =~ ^[a-zA-Z][a-zA-Z0-9-]*$ ]]; then
        _cb_red "Error: Project name must start with a letter and contain only alphanumeric characters and hyphens"
        return 1
    fi

    local project_dir="${PROJECTS_DIR:-$HOME/projects}/$name"

    if [ -d "$project_dir" ]; then
        _cb_red "Error: Directory already exists: $project_dir"
        return 1
    fi

    echo "Creating project: $name"

    # Check if specify CLI is available
    if command -v specify &> /dev/null; then
        echo "Running specify init..."
        cd "${PROJECTS_DIR:-$HOME/projects}"
        specify init "$name"
    else
        echo "Spec Kit CLI not found, creating basic structure..."
        mkdir -p "$project_dir"
        cd "$project_dir"
        git init

        # Create basic files
        cat > CLAUDE.md << 'EOF'
# Project Context

## Overview
[Describe your project here]

## Tech Stack
[List technologies used]

## Key Files
[Important files and their purposes]
EOF

        cat > .gitignore << 'EOF'
node_modules/
__pycache__/
*.pyc
.env
.env.local
.DS_Store
EOF
    fi

    # Copy CodeBootstrap additions if available
    local templates_dir="/workspaces/codebootstrap/templates/codebootstrap-additions"
    if [ -d "$templates_dir" ]; then
        echo "Adding CodeBootstrap configuration..."

        # Copy devcontainer config
        if [ -f "$templates_dir/devcontainer-json.json" ]; then
            mkdir -p "$project_dir/.devcontainer"
            cp "$templates_dir/devcontainer-json.json" "$project_dir/.devcontainer/devcontainer.json"
        fi

        # Copy .editorconfig
        if [ -f "$templates_dir/editorconfig" ]; then
            cp "$templates_dir/editorconfig" "$project_dir/.editorconfig"
        fi

        # Append context to AI context files
        if [ -f "$templates_dir/context-append.md" ]; then
            local context_content=$(cat "$templates_dir/context-append.md")

            # Append to CLAUDE.md (for Claude)
            if [ -f "$project_dir/CLAUDE.md" ]; then
                echo "" >> "$project_dir/CLAUDE.md"
                echo "$context_content" >> "$project_dir/CLAUDE.md"
            fi

            # Append to AGENTS.md (for Codex)
            if [ -f "$project_dir/AGENTS.md" ]; then
                echo "" >> "$project_dir/AGENTS.md"
                echo "$context_content" >> "$project_dir/AGENTS.md"
            fi

            # Append to GEMINI.md (for Gemini)
            if [ -f "$project_dir/GEMINI.md" ]; then
                echo "" >> "$project_dir/GEMINI.md"
                echo "$context_content" >> "$project_dir/GEMINI.md"
            fi
        fi
    fi

    _cb_green "✓ Project created at $project_dir"

    # Prompt for GitHub repo creation
    echo ""
    read -p "Create GitHub repo? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if command -v gh &> /dev/null; then
            echo "Creating private repo: $name"
            cd "$project_dir"
            gh repo create "$name" --private --source=. --push
            _cb_green "✓ GitHub repo created"
        else
            _cb_yellow "GitHub CLI not available. Install 'gh' to create repos."
        fi
    fi

    echo ""
    echo "Next steps:"
    echo "  cd $project_dir"
    echo "  claude   # or codex, gemini"
}

# ============================================
# clone-project - Clone a GitHub project locally
# ============================================
clone-project() {
    local repo="$1"

    if [ -z "$repo" ]; then
        echo "Usage: clone-project <github-url-or-user/repo>"
        echo ""
        echo "Examples:"
        echo "  clone-project https://github.com/user/repo"
        echo "  clone-project user/repo"
        return 1
    fi

    # Convert user/repo format to full URL
    if [[ ! "$repo" =~ ^https?:// ]]; then
        repo="https://github.com/$repo"
    fi

    # Extract repo name from URL
    local name=$(basename "$repo" .git)

    local projects_dir="${PROJECTS_DIR:-$HOME/projects}"
    local project_dir="$projects_dir/$name"

    if [ -d "$project_dir" ]; then
        _cb_red "Error: Directory already exists: $project_dir"
        echo "  Use: cd $project_dir"
        return 1
    fi

    echo "Cloning $repo..."
    git clone "$repo" "$project_dir"

    if [ $? -ne 0 ]; then
        _cb_red "Error: Clone failed"
        return 1
    fi

    cd "$project_dir"

    _cb_green "✓ Project cloned to $project_dir"
    echo ""
    echo "Next steps:"
    echo "  claude   # or codex, gemini"
}

# ============================================
# quick-project - Create minimal project
# ============================================
quick-project() {
    local name="$1"

    if [ -z "$name" ]; then
        echo "Usage: quick-project <project-name>"
        return 1
    fi

    local project_dir="${PROJECTS_DIR:-$HOME/projects}/$name"

    if [ -d "$project_dir" ]; then
        _cb_red "Error: Directory already exists: $project_dir"
        return 1
    fi

    echo "Creating minimal project: $name"
    mkdir -p "$project_dir"
    cd "$project_dir"
    git init

    cat > CLAUDE.md << 'EOF'
# Project Context

[Describe your project here]
EOF

    cat > .gitignore << 'EOF'
node_modules/
__pycache__/
*.pyc
.env
.DS_Store
EOF

    _cb_green "✓ Project created at $project_dir"
}

# ============================================
# p - Jump to project or list all
# ============================================
p() {
    local name="$1"
    local projects_dir="${PROJECTS_DIR:-$HOME/projects}"

    if [ -z "$name" ]; then
        # List all projects
        if [ -d "$projects_dir" ]; then
            ls -1 "$projects_dir"
        else
            echo "No projects directory found at $projects_dir"
        fi
        return 0
    fi

    local project_dir="$projects_dir/$name"

    if [ -d "$project_dir" ]; then
        cd "$project_dir"
    else
        _cb_red "Project not found: $name"
        return 1
    fi
}

# ============================================
# projects - List projects with git status
# ============================================
projects() {
    local projects_dir="${PROJECTS_DIR:-$HOME/projects}"

    if [ ! -d "$projects_dir" ]; then
        echo "No projects directory found at $projects_dir"
        return 1
    fi

    for dir in "$projects_dir"/*/; do
        if [ -d "$dir" ]; then
            local name=$(basename "$dir")
            local status=""

            if [ -d "$dir/.git" ]; then
                cd "$dir"
                local changes=$(git status --porcelain 2>/dev/null | wc -l)
                if [ "$changes" -eq 0 ]; then
                    status="(clean)"
                else
                    status="($changes uncommitted)"
                fi
                cd - > /dev/null
            else
                status="(no git)"
            fi

            printf "  %-20s %s\n" "$name" "$status"
        fi
    done
}

# ============================================
# project-status - Git status for all projects
# ============================================
project-status() {
    local projects_dir="${PROJECTS_DIR:-$HOME/projects}"

    if [ ! -d "$projects_dir" ]; then
        echo "No projects directory found at $projects_dir"
        return 1
    fi

    for dir in "$projects_dir"/*/; do
        if [ -d "$dir" ]; then
            local name=$(basename "$dir")

            if [ -d "$dir/.git" ]; then
                cd "$dir"
                local branch=$(git branch --show-current 2>/dev/null)
                local staged=$(git diff --staged --stat 2>/dev/null | tail -1)
                local unstaged=$(git diff --stat 2>/dev/null | tail -1)

                local status_icon="✓"
                local extra=""

                if [ -n "$staged" ] || [ -n "$unstaged" ]; then
                    status_icon="●"
                    local added=$(git status --porcelain 2>/dev/null | grep "^A" | wc -l)
                    local modified=$(git status --porcelain 2>/dev/null | grep "^.M" | wc -l)
                    [ "$added" -gt 0 ] && extra="+$added"
                    [ "$modified" -gt 0 ] && extra="$extra ~$modified"
                fi

                printf "%-20s %s %s %s\n" "$name:" "$branch" "$status_icon" "$extra"
                cd - > /dev/null
            else
                printf "%-20s %s\n" "$name:" "(not a git repo)"
            fi
        fi
    done
}

# ============================================
# parallel-claude - Create worktree for parallel work
# ============================================
parallel-claude() {
    local feature="$1"

    if [ -z "$feature" ]; then
        echo "Usage: parallel-claude <feature-name>"
        return 1
    fi

    # Check if we're in a git repo
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        _cb_red "Error: Not in a git repository"
        return 1
    fi

    local repo_name=$(basename "$(git rev-parse --show-toplevel)")
    local branch_name="feature/$feature"
    local worktree_dir="../${repo_name}-${feature}"

    # Check if branch already exists
    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        _cb_red "Error: Branch already exists: $branch_name"
        return 1
    fi

    echo "Creating worktree for feature: $feature"
    git worktree add -b "$branch_name" "$worktree_dir"

    _cb_green "✓ Worktree created at $worktree_dir"
    echo ""
    echo "To start parallel Claude session:"
    echo "  cd $worktree_dir && claude"
}

# ============================================
# worktrees - List git worktrees
# ============================================
worktrees() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        _cb_red "Error: Not in a git repository"
        return 1
    fi

    git worktree list
}

# ============================================
# todos - Find TODO/FIXME/HACK in codebase
# ============================================
todos() {
    echo "Finding TODOs, FIXMEs, HACKs, and XXXs..."
    echo ""

    grep -rn --color=always \
        -e "TODO" -e "FIXME" -e "HACK" -e "XXX" \
        --include="*.py" \
        --include="*.js" --include="*.ts" --include="*.jsx" --include="*.tsx" \
        --include="*.go" \
        --include="*.rs" \
        --include="*.rb" \
        --include="*.java" \
        --include="*.c" --include="*.cpp" --include="*.h" \
        --include="*.sh" \
        --include="*.md" \
        . 2>/dev/null | grep -v "node_modules" | grep -v ".git" | head -50

    echo ""
    echo "(Showing max 50 results)"
}

# ============================================
# backup - Create safety branch
# ============================================
backup() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        _cb_red "Error: Not in a git repository"
        return 1
    fi

    local branch_name="backup-$(date +%Y%m%d-%H%M%S)"
    git branch "$branch_name"
    _cb_green "✓ Backup branch created: $branch_name"
    echo "  Restore with: git checkout $branch_name"
}

# ============================================
# tree - Show project structure
# ============================================
tree() {
    local depth="${1:-2}"

    if command -v /usr/bin/tree &> /dev/null; then
        /usr/bin/tree -a -L "$depth" -I '.git|node_modules|__pycache__|.venv|venv|dist|build|.next|.nuxt' --dirsfirst
    else
        # Fallback using find
        echo "Project structure (depth $depth):"
        find . -maxdepth "$depth" \
            -not -path "*/node_modules/*" \
            -not -path "*/.git/*" \
            -not -path "*/__pycache__/*" \
            -not -path "*/.venv/*" \
            -not -name "node_modules" \
            -not -name ".git" \
            -not -name "__pycache__" \
            | sort | head -50
    fi
}

# ============================================
# d - Git diff shortcut
# ============================================
alias d='git diff'

# ============================================
# ds - Git diff staged shortcut
# ============================================
alias ds='git diff --staged'

# ============================================
# cm - Quick commit with message
# ============================================
cm() {
    if [ -z "$*" ]; then
        echo "Usage: cm <commit message>"
        return 1
    fi

    git add -A
    git commit -m "$*"
}

# ============================================
# today - Show today's git activity
# ============================================
today() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        _cb_red "Error: Not in a git repository"
        return 1
    fi

    echo "Today's commits:"
    echo ""
    git log --oneline --since="midnight" --author="$(git config user.name)" 2>/dev/null

    local count=$(git log --oneline --since="midnight" --author="$(git config user.name)" 2>/dev/null | wc -l)
    echo ""
    echo "$count commit(s) today"
}

# ============================================
# wip - Quick work-in-progress commit
# ============================================
wip() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        _cb_red "Error: Not in a git repository"
        return 1
    fi

    git add -A
    git commit -m "WIP"
    _cb_green "✓ WIP commit created"
}

# ============================================
# unwip - Undo WIP commit (keep changes)
# ============================================
unwip() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        _cb_red "Error: Not in a git repository"
        return 1
    fi

    local last_msg=$(git log -1 --format=%s 2>/dev/null)
    if [ "$last_msg" != "WIP" ]; then
        _cb_yellow "Warning: Last commit is not a WIP commit"
        read -p "Undo anyway? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 0
        fi
    fi

    git reset HEAD~1
    _cb_green "✓ Last commit undone (changes preserved)"
}

# ============================================
# serve - Quick HTTP server
# ============================================
serve() {
    local port="${1:-8000}"

    _cb_blue "Starting HTTP server on port $port..."
    echo "Press Ctrl+C to stop"
    echo ""

    if command -v python3 &> /dev/null; then
        python3 -m http.server "$port"
    elif command -v python &> /dev/null; then
        python -m SimpleHTTPServer "$port"
    else
        _cb_red "Error: Python not found"
        return 1
    fi
}

# ============================================
# ports - Show listening ports
# ============================================
ports() {
    echo "Listening ports:"
    echo ""

    if command -v ss &> /dev/null; then
        ss -tlnp 2>/dev/null | grep LISTEN
    elif command -v netstat &> /dev/null; then
        netstat -tlnp 2>/dev/null | grep LISTEN
    elif command -v lsof &> /dev/null; then
        lsof -i -P -n | grep LISTEN
    else
        _cb_red "Error: No supported tool found (ss, netstat, or lsof)"
        return 1
    fi
}

# ============================================
# archive-project - Move project to archive
# ============================================
archive-project() {
    local name="$1"

    if [ -z "$name" ]; then
        echo "Usage: archive-project <project-name>"
        return 1
    fi

    local projects_dir="${PROJECTS_DIR:-$HOME/projects}"
    local archive_dir="$HOME/archived"
    local project_dir="$projects_dir/$name"

    if [ ! -d "$project_dir" ]; then
        _cb_red "Error: Project not found: $project_dir"
        return 1
    fi

    # Create archive directory
    mkdir -p "$archive_dir"

    # Archive with timestamp
    local timestamp=$(date +%Y%m%d)
    local archive_name="${name}-${timestamp}"

    # Handle existing archive with same name
    if [ -d "$archive_dir/$archive_name" ]; then
        archive_name="${name}-$(date +%Y%m%d-%H%M%S)"
    fi

    mv "$project_dir" "$archive_dir/$archive_name"

    _cb_green "✓ Archived to ~/archived/$archive_name"
}

# ============================================
# scratch - Create temporary project
# ============================================
scratch() {
    local name="scratch-$(date +%Y%m%d-%H%M%S)"
    local dir="/tmp/$name"

    mkdir -p "$dir"
    cd "$dir"
    git init --quiet

    cat > README.md << EOF
# Scratch: $name

Temporary project for quick experiments.
This will be lost on container restart.
EOF

    cat > .gitignore << 'EOF'
node_modules/
__pycache__/
*.pyc
.env
.DS_Store
EOF

    _cb_green "✓ Scratch project at $dir"
    _cb_yellow "⚠ Temporary - will be lost on container restart"
}

# ============================================
# codebootstrap-status - Health check
# ============================================
codebootstrap-status() {
    echo "CodeBootstrap Health Check"
    echo "=========================="
    echo ""

    local issues=0

    # Check git
    if command -v git &> /dev/null; then
        local git_version=$(git --version | cut -d' ' -f3)
        _cb_green "✓ git          $git_version"
    else
        _cb_red "✗ git          not found"
        echo "  Fix: Install git"
        ((issues++))
    fi

    # Check gh
    if command -v gh &> /dev/null; then
        local gh_version=$(gh --version | head -1 | cut -d' ' -f3)
        if gh auth status &> /dev/null; then
            local gh_user=$(gh api user -q .login 2>/dev/null)
            _cb_green "✓ gh           $gh_version (authenticated as $gh_user)"
        else
            _cb_yellow "⚠ gh           $gh_version (not authenticated)"
            echo "  Fix: Run 'gh auth login --web'"
            ((issues++))
        fi
    else
        _cb_red "✗ gh           not found"
        ((issues++))
    fi

    # Check node
    if command -v node &> /dev/null; then
        local node_version=$(node --version)
        _cb_green "✓ node         $node_version"
    else
        _cb_red "✗ node         not found"
        ((issues++))
    fi

    # Check python
    if command -v python3 &> /dev/null; then
        local python_version=$(python3 --version | cut -d' ' -f2)
        _cb_green "✓ python       $python_version"
    else
        _cb_red "✗ python       not found"
        ((issues++))
    fi

    # Check claude
    if command -v claude &> /dev/null; then
        _cb_green "✓ claude       installed"
    else
        _cb_red "✗ claude       not found"
        ((issues++))
    fi

    # Check MCP config
    if [ -f ~/.config/claude/settings.json ]; then
        local server_count=$(jq '.mcpServers | length' ~/.config/claude/settings.json 2>/dev/null)
        if [ "$server_count" -eq 7 ]; then
            _cb_green "✓ MCP config   $server_count servers configured"
        else
            _cb_yellow "⚠ MCP config   $server_count/7 servers configured"
            echo "  Fix: Run 'codebootstrap-update'"
            ((issues++))
        fi
    else
        _cb_red "✗ MCP config   not found"
        echo "  Fix: Run 'codebootstrap-update'"
        ((issues++))
    fi

    # Check shell helpers
    if [ -d ~/.bashrc.d ]; then
        _cb_green "✓ Shell helpers loaded"
    else
        _cb_red "✗ Shell helpers not found"
        ((issues++))
    fi

    echo ""
    if [ $issues -eq 0 ]; then
        _cb_green "All systems operational!"
    else
        _cb_yellow "$issues issue(s) found. Run suggested fixes above."
    fi

    return $issues
}

# ============================================
# codebootstrap-update - Update components
# ============================================
codebootstrap-update() {
    echo "CodeBootstrap Update"
    echo "===================="
    echo ""
    echo "Updating MCP server packages..."

    # Update MCP server packages
    local packages=(
        "@anthropic-ai/mcp-server-filesystem"
        "@anthropic-ai/mcp-server-memory"
        "@anthropic-ai/mcp-server-fetch"
        "@anthropic-ai/mcp-server-sequential-thinking"
        "@upstash/context7-mcp"
        "@anthropic-ai/mcp-server-git"
        "@modelcontextprotocol/server-github"
    )

    for pkg in "${packages[@]}"; do
        echo "  Updating $pkg..."
        npm install -g "$pkg" --silent 2>/dev/null
        _cb_green "  ✓ $pkg"
    done

    echo ""
    _cb_green "Update complete!"
}

# ============================================
# speckit-owner - Manage Spec Kit ownership
# ============================================
speckit-owner() {
    local tool="$1"
    local lock_file=".specify/owner.lock"

    # Show current owner if no argument
    if [ -z "$tool" ]; then
        echo "Spec Kit Owner"
        echo "=============="

        if [ -f "$lock_file" ]; then
            local owner=$(jq -r '.owner' "$lock_file" 2>/dev/null)
            local since=$(jq -r '.since' "$lock_file" 2>/dev/null)

            echo "Current owner: $owner"
            echo "Since: $since"
            echo ""
            echo "Only $owner can modify:"
            echo "  - .specify/"
            echo "  - specs/"
            echo "  - constitution.md"
            echo ""
            echo "Other AI tools have read-only access."
        else
            _cb_yellow "No owner lock found. Run 'speckit-owner claude' to set."
        fi
        return 0
    fi

    # Validate tool name
    if [[ ! "$tool" =~ ^(claude|codex|gemini)$ ]]; then
        _cb_red "Error: Invalid tool name. Use: claude, codex, or gemini"
        return 1
    fi

    # Get current owner
    local current_owner=""
    if [ -f "$lock_file" ]; then
        current_owner=$(jq -r '.owner' "$lock_file" 2>/dev/null)
    fi

    echo "Spec Kit Ownership Transfer"
    echo "==========================="

    if [ -n "$current_owner" ]; then
        echo "Current owner: $current_owner"
    else
        echo "Current owner: (none)"
    fi
    echo "Transfer to: $tool"
    echo ""

    # Create .specify directory if needed
    mkdir -p .specify

    # Write new lock file
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    cat > "$lock_file" << EOF
{
  "owner": "$tool",
  "since": "$timestamp",
  "transferred_from": ${current_owner:+\"$current_owner\"}${current_owner:-null}
}
EOF

    _cb_green "✓ Ownership transferred to $tool"
    echo ""
    echo "$tool now has write access to Spec Kit artifacts."
    [ -n "$current_owner" ] && echo "$current_owner is now read-only."
}
