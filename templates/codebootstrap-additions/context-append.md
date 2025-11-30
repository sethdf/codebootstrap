
## Git Workflow (IMPORTANT)

**Always commit and push after completing work.** This ensures changes are saved to GitHub and accessible from any device.

### When to Commit

Commit at logical completion points:
- After completing a feature or fix
- After making a set of related changes
- Before switching to a different task
- When asked to save/commit/push
- At the end of a work session

### How to Commit

1. Stage all changes: `git add -A`
2. Commit with descriptive message using conventional format (see below)
3. Push to remote: `git push`

Or use the shortcut: `save "your commit message"`

### Commit Conventions

Use conventional commits format:
- `feat:` new feature
- `fix:` bug fix
- `docs:` documentation only
- `refactor:` code change that neither fixes nor adds
- `test:` adding or updating tests
- `chore:` maintenance, dependencies, config

Keep commits atomic - one logical change per commit. Write meaningful commit messages that explain *why*, not just *what*.

### Push Requirements

**Always push to GitHub after committing.** The user may be working from multiple devices (including mobile) and needs changes synced.

Exception: If push fails due to conflicts, inform the user and suggest running `sync` to resolve.

## Security

- **Never commit secrets** - No .env files, API keys, passwords, or credentials in git
- **OWASP awareness** - Check for top 10 vulnerabilities (injection, XSS, CSRF, etc.)
- **Parameterized queries** - Never use string concatenation for SQL/database queries
- **Input validation** - Validate and sanitize all user input at system boundaries
- **Dependency hygiene** - Pin versions, check for known vulnerabilities, update regularly
- **Password storage** - Never store plain text; use bcrypt, argon2, or similar
- **Session security** - HttpOnly, Secure, SameSite cookies; proper timeouts
- **HTTPS only** - No HTTP for anything sensitive; no mixed content
- **File uploads** - Validate type, size, and sanitize filenames; never trust client
- **Error exposure** - Never expose stack traces, internal paths, or system info to users

## Code Loss Prevention (CRITICAL)

**Your work may be accessed from mobile devices that can disconnect at any time. Prevent data loss:**

- **Commit working increments** - Don't wait for perfection; commit when code works
- **Backup before risky operations** - Run `backup` before major refactors or migrations
- **Save before fixing** - If errors occur, commit working changes before attempting fixes
- **Never abandon work** - Don't discard uncommitted changes without explicit user approval
- **Report push failures** - If push fails, inform user immediately; local commit is still safe
- **Pull before starting** - Run `sync` at session start to avoid conflicts later

## File Operations Safety

- **Read before overwrite** - Always read files before modifying to understand existing code
- **Confirm bulk deletes** - Before deleting multiple files, list them and confirm with user
- **Atomic writes** - For critical files, write to temp file then move (prevents corruption)
- **Stay in project** - Never delete or modify files outside the project directory
- **Git everything** - All file changes should be tracked in git for recovery
- **Verify paths** - Double-check file paths before write/delete operations

## Database Safety

- **Migrations only** - Schema changes MUST use migration files, never manual SQL
- **No raw DDL** - Never run ALTER, DROP, TRUNCATE directly; always through migrations
- **Transactions** - Wrap multi-step data operations in transactions
- **WHERE clauses** - For UPDATE/DELETE, verify WHERE clause matches expected rows before executing
- **Backup first** - Before destructive migrations, ensure database backup exists
- **Test migrations** - Run migrations on test data before production

## Error Handling

- **Never swallow errors** - Handle errors explicitly; silent failures cause debugging nightmares
- **Context in errors** - Include what failed, why, and how to fix in error messages
- **Graceful degradation** - External service failures shouldn't crash the whole app
- **Timeouts required** - All external calls (APIs, databases) need timeouts
- **Retry with backoff** - For transient failures, retry with exponential backoff
- **Consistent state** - On failure, leave system in a consistent, recoverable state

## Logging Best Practices

- **Log important events** - Authentication, authorization failures, key business operations
- **NEVER log secrets** - No passwords, tokens, API keys, or PII in logs
- **Include context** - Timestamps, request IDs, user IDs (if not PII-sensitive)
- **Appropriate levels** - DEBUG for development, INFO for operations, ERROR for failures
- **Structured format** - JSON logging preferred for parseability

## Dependency Management

- **Commit lock files** - package-lock.json, yarn.lock, Cargo.lock, etc. MUST be committed
- **Check vulnerabilities** - Before adding packages, check for known CVEs
- **Prefer established** - Choose well-maintained, widely-used packages over obscure ones
- **Minimize deps** - Don't add packages for trivial functionality (a few lines of code)
- **Pin versions** - Use exact versions or tight ranges; avoid `*` or `latest`
- **Audit regularly** - Run `npm audit`, `pip-audit`, etc. periodically

## Performance Awareness

- **N+1 queries** - Batch database queries; use eager loading for related data
- **Pagination** - Never return unbounded result sets; always paginate
- **Async I/O** - Use async/await for network, file, and database operations
- **Index columns** - Add indexes for frequently queried/filtered columns
- **Cache expensive** - Cache results of expensive computations or API calls
- **Measure first** - Profile before optimizing; don't guess at bottlenecks

## Environment & Configuration

- **No hardcoded secrets** - Use environment variables or secret managers
- **No hardcoded URLs** - Base URLs, API endpoints should be configurable
- **Validate at startup** - Check required config exists before app runs
- **Document all vars** - Every env var in .env.example with descriptions
- **Sensible defaults** - Provide defaults where safe (not for secrets)
- **Environment parity** - Dev/staging/prod should differ only in config, not code

## External Services & APIs

- **Always set timeouts** - Network calls without timeouts can hang forever
- **Handle failures** - External services will fail; have a fallback strategy
- **Retry transient errors** - 5xx, timeouts, connection errors with backoff
- **Don't retry 4xx** - Client errors won't succeed on retry
- **Circuit breakers** - For critical services, prevent cascade failures
- **Validate responses** - Don't trust external data; validate before use

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

## Before Making Changes

- **Read first** - Before modifying code, read relevant files to understand existing patterns, utilities, and conventions
- **Verify assumptions** - Confirm files, dependencies, and APIs exist before using them. Don't assume project structure

## Writing Code

- **Stay focused** - Complete the requested task. Don't fix unrelated issues or add unrequested features unless asked
- **Ask when unclear** - If requirements are ambiguous, ask clarifying questions before implementing
- **Match existing patterns** - Follow the codebase's style and conventions. Don't introduce new patterns without discussion
- **Minimal dependencies** - Don't add packages for functionality achievable in a few lines of code
- **Use what exists** - Check for existing utilities in the codebase before writing new ones
- **No hallucination** - Only use APIs, methods, and features you've verified exist. When uncertain, check documentation or source

## After Making Changes

- **Verify it works** - Run tests or manually verify changes. Don't assume success
- **Acknowledge errors** - If output shows errors or warnings, address them. Don't proceed silently
- **Explain errors clearly** - When errors occur, explain what went wrong, why it happened, and how to fix it
- **Flag breaking changes** - When modifying public APIs, note backward compatibility impact and discuss with user
- **Clean up** - Remove debug statements, console.logs, and commented code before committing
- **Commit incrementally** - For long tasks, commit working increments. Don't wait until everything is done
- **Revert on failure** - If changes break things, revert to last working state before trying alternatives

## Session End Protocol

When ending a session or when the user seems to be wrapping up:

1. **Save all work** - Commit and push any uncommitted changes
2. **Verify tests pass** - Run test suite to ensure nothing is broken
3. **Summarize accomplishments** - Brief list of what was completed
4. **List remaining tasks** - Any TODOs, known issues, or next steps
5. **Note tech debt** - Any shortcuts taken that should be addressed later
6. **Flag concerns** - Security issues, performance concerns, or architectural questions

Example session end:
```
Session Summary:
✓ Implemented user authentication (feat: add login/logout)
✓ Added password reset flow (feat: password reset email)
✓ Fixed session timeout bug (fix: extend session to 24h)

Remaining:
- Add rate limiting to login endpoint
- Write tests for password reset flow

Tech debt:
- Hardcoded email templates (should use template engine)

All changes committed and pushed.
```

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
