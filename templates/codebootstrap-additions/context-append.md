
## Testing Requirements

When implementing features or fixing bugs:

1. **Write tests for new code** - Every new function, endpoint, or component should have corresponding tests
2. **Test before commit** - Run the test suite before committing changes; do not commit if tests fail
3. **Cover edge cases** - Include tests for error conditions, boundary values, and invalid inputs
4. **Match project conventions** - Use the existing test framework and patterns in this project

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
