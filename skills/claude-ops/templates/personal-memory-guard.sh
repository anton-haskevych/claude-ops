#!/usr/bin/env bash
# personal-memory-guard.sh — a PreToolUse guard (WARN, do not block).
#
# Fires when a write targets PERSONAL, machine-local memory and asks the user to confirm the save
# is genuinely personal — not a team fact misrouted into invisible personal scope. The rare legit
# personal save still goes through; it just becomes a deliberate choice.
#
# Install at USER scope (~/.claude/), with the user's consent — it guards THEIR own memory:
#   1. cp this file to ~/.claude/hooks/personal-memory-guard.sh
#   2. add to ~/.claude/settings.json:
#        { "hooks": { "PreToolUse": [{
#            "matcher": "Write|Edit",
#            "hooks": [{ "type": "command",
#                        "command": "bash ~/.claude/hooks/personal-memory-guard.sh" }] }] } }
#   Never commit this into a target repo, and never edit the user's settings without asking.

set -euo pipefail

INPUT=$(cat)

# jq is the only dependency. If it's missing, fail OPEN (allow) — a guard must never break writes.
command -v jq >/dev/null 2>&1 || exit 0

FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // ""')
[ -n "$FILE_PATH" ] || exit 0

# PERSONAL (machine-local, never committed) write targets:
#   - auto-memory:        ~/.claude/projects/<encoded>/memory/...  (incl. MEMORY.md + entries)
#   - personal overrides: any CLAUDE.local.md
case "$FILE_PATH" in
  "$HOME"/.claude/projects/*/memory/* | */CLAUDE.local.md | CLAUDE.local.md)
    REASON="This writes to PERSONAL, machine-local memory ($FILE_PATH): teammates never see it and it is not committed. Confirm it is genuinely personal (local creds, single-machine ergonomics, or your own preference). If a teammate's agent would benefit from this, it is TEAM knowledge — put it in a committed rule, CLAUDE.md, or docs/decisions/ instead."
    jq -cn --arg r "$REASON" '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "ask",
        permissionDecisionReason: $r
      }
    }'
    exit 0
    ;;
esac

# Not a personal-memory write — allow silently.
exit 0
