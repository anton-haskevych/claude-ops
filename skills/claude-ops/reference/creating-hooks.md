# Creating Hooks

Hooks live in `.claude/settings.json`. They are **guards** — mechanical enforcement that runs automatically.

## Anatomy

```json
{
  "hooks": {
    "PreToolUse": [{ "matcher": "Edit", "hooks": [{ "type": "command", "command": "bash script.sh" }] }],
    "PostToolUse": [{ "matcher": "Write", "hooks": [{ "type": "command", "command": "bash script.sh" }] }]
  }
}
```

## Lifecycle Events

- `PreToolUse` — runs before a tool call (can block it)
- `PostToolUse` — runs after a tool call (can lint, validate, notify)
- `Notification` — runs on system notifications
- `Stop` — runs when the main agent stops
- `SubagentStop` — runs when a subagent stops

## Script Conventions

- Scripts read JSON from stdin: `INPUT=$(cat)`
- Extract tool input: `FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')`
- Return `{"decision": "approve"}` or `{"decision": "block", "reason": "..."}`
- Claude Code hooks in `.claude/hooks/`, infra-specific hooks in `infra/hooks/`

## When to Use Hooks (not Rules)

Ask: "Must this happen mechanically, with no exceptions?"
- **Yes** → hook (e.g., lint-on-edit, protect-generated-files)
- **No, it's guidance** → rule or CLAUDE.md

Hooks are the highest-enforcement tier after the compiler/type system. Use them for: file protection, automated linting, format validation, checkpoint reminders.
