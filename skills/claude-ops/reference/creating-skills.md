# Creating Skills

Skills live in `.claude/skills/<name>/SKILL.md`. They are **on-demand context** — loaded when relevant, not every session.

For Anthropic's full authoring guide, see [best-practices.md](best-practices.md).

## Checklist Before Creating

- [ ] Does this workflow recur? (one-off → just do it, don't make a skill)
- [ ] Is the description specific enough? Include what + when. Write in third person.
- [ ] Does it need `disable-model-invocation: true`? (side effects like deploy, send, commit)
- [ ] Are `allowed-tools` restricted to minimum needed?
- [ ] Under 500 lines? Use reference files for bulk content.

## Directory Structure

```
my-skill/
├── SKILL.md           # Overview + routing (required)
├── reference/         # Detailed docs (loaded as needed)
├── scripts/           # Executable scripts
└── examples/          # Example outputs
```

Follow the `/spec` skill pattern: lean SKILL.md that routes to supporting files based on context.

## Gotcha — Discovery vs Invocation

- Skills in subdirectory `.claude/skills/` (e.g., `video/.claude/skills/`) are **discoverable** but **NOT invocable as `/slash` commands**
- Slash commands only resolve from **project root** `.claude/skills/`
- If a skill must be invocable via `/name`, it MUST exist at `.claude/skills/<name>/SKILL.md`

## Project Conventions

- `argument-hint:` documents expected arguments in autocomplete
- `$ARGUMENTS` for input, `AskUserQuestion` for interactive decisions
- `` !`command` `` for dynamic context injection (runs at load time)
- `context: fork` only for tasks that produce output — not reference-only content
- Check description budget with `/context` — total across all skills is limited
- **Project-specific skills** belong at project scope (`.claude/skills/`) — shared via git, team-consistent.
- **Personal workflow skills** (e.g., journaling, spec authoring, code review) belong at user scope (`~/.claude/skills/`) — available in every project.
- User scope takes precedence if both scopes define a skill with the same name.
