
## Commit Conventions

Use conventional commits format:
- `feat:` new feature
- `fix:` bug fix
- `docs:` documentation only
- `refactor:` code change that neither fixes nor adds
- `test:` adding or updating tests
- `chore:` maintenance, dependencies, config

Keep commits atomic - one logical change per commit. Write meaningful commit messages that explain *why*, not just *what*.

## Security

- **Never commit secrets** - No .env files, API keys, passwords, or credentials in git
- **OWASP awareness** - Check for top 10 vulnerabilities (injection, XSS, CSRF, etc.)
- **Parameterized queries** - Never use string concatenation for SQL/database queries
- **Input validation** - Validate and sanitize all user input at system boundaries
- **Dependency hygiene** - Pin versions, check for known vulnerabilities, update regularly

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

## Testing Requirements

When implementing features or fixing bugs:

1. **Write tests for new code** - Every new function, endpoint, or component should have corresponding tests
2. **Test before commit** - Run the test suite before committing changes; do not commit if tests fail
3. **Cover edge cases** - Include tests for error conditions, boundary values, and invalid inputs
4. **Match project conventions** - Use the existing test framework and patterns in this project
5. **Prefer headless testing** - When testing UIs, browsers, or visual components, use headless mode by default (e.g., Puppeteer headless, Playwright headless, pytest with headless Chrome). This enables testing in containerized/CI environments without displays.

Test file locations (detect from project structure):
- JavaScript/TypeScript: `__tests__/`, `*.test.ts`, `*.spec.ts`
- Python: `tests/`, `test_*.py`, `*_test.py`
- Go: `*_test.go` (same directory)
- Rust: `#[cfg(test)]` modules or `tests/` directory

If no test framework exists yet, suggest one appropriate for the tech stack before writing tests.

## MCP Server Discovery

When starting work on this project, check for relevant MCP servers based on the tech stack:

1. **Detect technologies**: Look at package.json, requirements.txt, Cargo.toml, etc.
2. **Search for MCPs**: Use Context7 MCP or web search for "<technology> MCP server"
3. **Suggest additions**: If relevant MCPs exist, suggest adding them to `.claude/mcp-servers.json`

Common project-specific MCPs:
- Database: `@modelcontextprotocol/server-postgres`, `@modelcontextprotocol/server-sqlite`
- Puppeteer: `@anthropic-ai/mcp-server-puppeteer` (for web automation/testing)
- Slack: `@modelcontextprotocol/server-slack` (for team notifications)

## Documentation

- **README.md** - Every project needs one: what it does, how to run, how to contribute
- **Code comments** - Explain *why*, not *what*. Complex logic deserves explanation
- **API docs** - Public interfaces need clear documentation
- **.env.example** - Document all environment variables with example values (never real secrets)

## Code Review

When reviewing or being asked to review code, check:
- Does it do what it claims?
- Are there edge cases not handled?
- Is error handling appropriate?
- Are there security concerns?
- Is it readable and maintainable?
- Are there tests?

## Decision Records

For significant architectural decisions, create DECISIONS.md:
- What was decided
- Why (context, constraints, alternatives considered)
- Consequences (tradeoffs accepted)

This helps future developers (and AI) understand the codebase.

## Working Style

- **Stay focused** - Complete the requested task. Don't fix unrelated issues or add unrequested features unless asked
- **Ask when unclear** - If requirements are ambiguous, ask clarifying questions before implementing
- **Flag breaking changes** - When modifying public APIs, note backward compatibility impact and discuss with user before proceeding

## Spec Kit Ownership

Before modifying any Spec Kit artifacts, check ownership:

1. Read `.specify/owner.lock` to see current owner
2. If you are not the owner, you MUST:
   - Refuse to modify .specify/*, specs/*, constitution.md
   - Explain that another tool owns these artifacts
   - Suggest user run `speckit-owner <your-tool>` to transfer

Owned artifacts (require ownership):
- `.specify/**/*`
- `specs/**/*`
- `.specify/memory/constitution.md`

Always accessible (no ownership needed):
- Source code (src/, lib/, etc.)
- Tests
- Documentation outside specs/
- Config files
