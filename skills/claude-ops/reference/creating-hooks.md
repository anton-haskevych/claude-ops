# Creating Hooks

Hooks live in `.claude/settings.json` (team, committed) or `~/.claude/settings.json` (personal,
all your projects). They are **guards** — deterministic enforcement that runs automatically on
matching tool calls, at zero context cost. Strongest enforcement tier after the compiler/types.

## Anatomy

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{ "type": "command", "command": "bash ~/.claude/hooks/my-guard.sh" }]
    }]
  }
}
```

- `matcher` — exact tool name, pipe list (`Write|Edit`), or regex. `"*"` / omitted = all.
- Optional `if` (permission-rule syntax, e.g. `"Bash(git *)"`) filters **before** the hook process
  spawns — use it for expensive hooks.

## Lifecycle events (most-used)

- `PreToolUse` — before a tool call; **can allow / ask / deny**.
- `PostToolUse` — after success; lint / validate / notify (cannot undo the call).
- `UserPromptSubmit`, `SessionStart`, `Stop` — see the Claude Code hooks docs.

## Output protocol (current contract)

Read JSON from stdin (`INPUT=$(cat)`); extract with `jq` (`.tool_input.file_path`,
`.tool_input.command`, …).

**Block (simple):** `exit 2`, reason on **stderr** (stdout ignored).

**Allow / ask / deny with a reason (exit 0 + JSON stdout)** — for **PreToolUse**:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow" | "deny" | "ask",
    "permissionDecisionReason": "shown to the user / Claude",
    "additionalContext": "extra context injected for Claude"
  }
}
```

> `permissionDecision: "ask"` surfaces a confirm prompt **without hard-blocking** — the right tool
> for a *warn-but-allow* guard. `deny` blocks even in bypass mode. The older top-level
> `{"decision":"approve"|"block"}` shape is **legacy**: still accepted, but new hooks use the
> `hookSpecificOutput` shape above. (`PostToolUse`/`Stop` use a different top-level `decision` shape.)

**Just inject a nudge:** exit 0 with plain (non-JSON) stdout — the text is added as context.

Exit codes: `0` success (stdout parsed as JSON if it is JSON, else added as context) · `2`
blocking (stderr → Claude) · anything else = non-blocking error.

## Scope: where a hook lives matters

- **Team enforcement** → `.claude/settings.json` (committed) so the whole team inherits it.
- **Personal / self enforcement** → `~/.claude/settings.json` (all your projects, only you).

A guard meant to protect every engineer must be **committed** — a personal `~/.claude` hook only
guards your own sessions.

## PreToolUse path-matcher template

```bash
#!/usr/bin/env bash
set -euo pipefail
INPUT=$(cat)
command -v jq >/dev/null 2>&1 || exit 0           # no jq → fail OPEN (never break writes)
FILE=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // ""')
case "$FILE" in
  */some/protected/path/*)
    jq -cn '{hookSpecificOutput:{hookEventName:"PreToolUse",
            permissionDecision:"ask",permissionDecisionReason:"…why…"}}' ;;
  *) exit 0 ;;
esac
```

Always fixture-test before registering: `printf '<json>' | bash hook.sh; echo $?`.

## Personal-Memory Guard (shipped template)

`templates/personal-memory-guard.sh` is a ready PreToolUse guard that **warns (does not block)**
when a write targets PERSONAL machine-local memory (`~/.claude/projects/*/memory/`,
`CLAUDE.local.md`). It makes a personal save a deliberate, confirmed choice — enforcing the
team-by-default scope model without forbidding the rare legit personal save.

**Install at USER scope, with the user's consent** (it guards their own memory):

1. Copy `templates/personal-memory-guard.sh` → `~/.claude/hooks/personal-memory-guard.sh`.
2. Register it in `~/.claude/settings.json` under `PreToolUse`, matcher `"Write|Edit"`.
3. **Never** write it into a target repo's committed settings, and **never** edit the user's
   settings without asking first.

## When NOT to write a hook

- Pure pattern blocking → a `permissions.deny` rule is simpler.
- One-session behavior → a `CLAUDE.md` line.
- A reviewable multi-step workflow → a skill or agent.

Use a hook when you need deterministic, zero-context enforcement on every matching tool call.
