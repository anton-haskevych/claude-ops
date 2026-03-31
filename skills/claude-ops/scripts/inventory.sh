#!/bin/bash
# Generates a live inventory of Claude Code infrastructure
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

echo "**Skills:**"
ls "$ROOT/.claude/skills/" 2>/dev/null | sed 's/^/  /'

echo ""
echo "**Agents:**"
ls "$ROOT/.claude/agents/" 2>/dev/null | sed 's/^/  /'

echo ""
echo "**Rules (unconditional — always loaded):**"
for f in "$ROOT/.claude/rules/"*.md; do
  if ! grep -q '^paths:' "$f" 2>/dev/null; then
    echo "  $(basename "$f") ($(wc -l < "$f" | tr -d ' ') lines)"
  fi
done

echo ""
echo "**Rules (path-scoped — loaded on demand):**"
for f in "$ROOT/.claude/rules/"*.md; do
  if grep -q '^paths:' "$f" 2>/dev/null; then
    echo "  $(basename "$f") ($(wc -l < "$f" | tr -d ' ') lines)"
  fi
done

echo ""
echo "**Hooks** (from .claude/settings.json):"
grep -o '"command": "[^"]*"' "$ROOT/.claude/settings.json" 2>/dev/null | sed 's/"command": "/  /' | sed 's/"$//'

echo ""
echo "**Subdirectory CLAUDE.md files:**"
find "$ROOT" -maxdepth 2 -name "CLAUDE.md" -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/docs/specs/*" 2>/dev/null | sed "s|$ROOT/||" | sort | sed 's/^/  /'

echo ""
TOTAL=$(cat "$ROOT/CLAUDE.md" "$ROOT/.claude/rules/common-mistakes.md" "$ROOT/.claude/rules/troubleshooting.md" 2>/dev/null | wc -l | tr -d ' ')
echo "**Always-loaded line count**: $TOTAL lines (target: under 200)"
