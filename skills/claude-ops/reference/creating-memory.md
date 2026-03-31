# Creating Memory Entries

Auto-memory persists in `~/.claude/projects/.../memory/`. Use for cross-session context that is NOT derivable from code or git.

## When to Use Memory

Memory is for knowledge that:
- Is not in the codebase (can't be found by reading files)
- Is not a project convention (those go in CLAUDE.md or rules)
- Is specific to the user, their feedback, the project's direction, or external resources

## Memory Types

| Type | When to save | Example |
|------|-------------|---------|
| `user` | User's role, preferences, expertise | "User is a data scientist focused on logging" |
| `feedback` | User corrects or confirms approach | "Don't mock the database — prior incident with prod migration" |
| `project` | Goals, deadlines, strategic decisions | "Merge freeze begins 2026-03-05 for mobile release" |
| `reference` | Pointers to external systems | "Pipeline bugs tracked in Linear project INGEST" |

## What Memory is NOT For

- Code patterns, conventions, architecture → CLAUDE.md or rules
- File paths, project structure → Glob/Grep finds them
- Git history, recent changes → `git log`/`git blame`
- Debugging solutions → the fix is in the code
- Anything documented in CLAUDE.md files → don't duplicate

## Structure

Each memory is a markdown file with frontmatter (`name`, `description`, `type`) plus content.
`MEMORY.md` is the index — one line per entry, under 150 chars each, max 200 lines.
