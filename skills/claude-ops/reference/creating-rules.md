# Creating Rules

Rules live in `.claude/rules/*.md`. They are **prescriptive** — constraints, requirements, things agents must/must not do.

## Path-Scoped Rule Template

```markdown
---
paths:
  - "directory/**/*.ext"
---

# Rule Name

Concise instructions. Each line passes the litmus test.
```

## When to Use a Rule (not a CLAUDE.md)

Ask: "Is this telling agents what they must/must not do?"
- **Yes** → path-scoped rule
- **No, it's explaining how something works** → subdirectory CLAUDE.md

Examples of rule content: "never use haiku with claude -p", "always clear ANTHROPIC_API_KEY", "never hand-edit generated files".
Examples of CLAUDE.md content: architecture layers, file patterns, commands.

## Conventions

- **Path-scoped** (has `paths:` frontmatter) — loads only when Claude reads matching files. Use to reduce always-loaded context.
- **Unconditional** (no `paths:`) — loads every session. Keep the total minimal.
- **Target**: individual rule under 40 lines, hard limit 50.
- **Always-loaded budget**: total of root CLAUDE.md + unconditional rules under 150 lines, hard limit 200.
- **Name descriptively**: `infra-email.md` not `rule-7.md`.
- **Check existing files first.** Add a row to `troubleshooting.md`, don't create `troubleshooting-ecs.md`.

## Example Rule Files

Common patterns you might see:
- `common-mistakes.md` — "An agent should NEVER do this" (unconditional)
- `troubleshooting.md` — "When X breaks, here's the fix" (unconditional)
- `pipeline-ops.md` — "You must do X when working in ops/" (path-scoped)
- `infra-email.md`, `infra-sdk.md` — subsystem constraints (path-scoped)
