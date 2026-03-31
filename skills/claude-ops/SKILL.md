---
name: claude-ops
description: >
  Guide for building and evolving Claude Code agent infrastructure.
  Use when: deciding where knowledge belongs (rule vs skill vs memory vs hook),
  creating or updating CLAUDE.md files, rules, skills, agents, or hooks,
  reflecting after implementation, auditing config health.
argument-hint: [intent] — e.g., "where should this go?", "create a new skill", "audit"
allowed-tools: Read, Glob, Grep, Write, Edit, Bash, AskUserQuestion
---

# /claude-ops — Agent Infrastructure Guide

Core question: **"If a new agent session started right now with zero context, would it know how to do what I just did?"**

## Routing

If `$ARGUMENTS` is empty → show the Live Inventory below and ask the user what they need.

If `$ARGUMENTS` contains "audit" → read [reference/audit-checklist.md](reference/audit-checklist.md) and run it.

If `$ARGUMENTS` mentions creating a specific artifact → read the relevant reference file:
- Rules → [reference/creating-rules.md](reference/creating-rules.md)
- Skills → [reference/creating-skills.md](reference/creating-skills.md) + [reference/best-practices.md](reference/best-practices.md)
- Agents → [reference/creating-agents.md](reference/creating-agents.md)
- Hooks → [reference/creating-hooks.md](reference/creating-hooks.md)
- CLAUDE.md → [reference/creating-claude-md.md](reference/creating-claude-md.md)
- Memory → [reference/creating-memory.md](reference/creating-memory.md)

Otherwise → use the Classification Process below to decide where knowledge goes.

## Live Inventory

**Skills (project):**
!`ls .claude/skills/ 2>/dev/null || echo "(none)"`

**Skills (user):**
!`ls .claude/skills/ 2>/dev/null`

**Agents:**
!`ls .claude/agents/ 2>/dev/null || echo "(none)"`

**Rules:**
!`ls .claude/rules/ 2>/dev/null || echo "(none)"`

**Hooks & Permissions:** see `.claude/settings.json`

For detailed inventory with line counts: `bash ${CLAUDE_SKILL_DIR}/scripts/inventory.sh`

## Classification Process

When you have knowledge to place, run each item through these 3 steps.

**Step 1: Filter.** Can a future session learn this from code, commands, or git history? If yes, skip it.

**Step 2: Classify.** Find the FIRST matching row:

| Ask this question | Type | Where |
|---|---|---|
| "An agent should NEVER do this" | Mistake | `.claude/rules/common-mistakes.md` |
| "When X breaks, here's the fix" | Troubleshooting | `.claude/rules/troubleshooting.md` |
| "You must/must not do X when working here" (prescriptive) | Constraint | `.claude/rules/<name>.md` with `paths:` |
| "This applies everywhere in the project" | Universal rule | Root `CLAUDE.md` |
| "This is how a subsystem works" (descriptive) | Architecture | `<dir>/CLAUDE.md` (subdirectory) |
| "This is a multi-step workflow that recurs" | Skill | `.claude/skills/<name>/SKILL.md` |
| "This must happen mechanically, no exceptions" | Guard | Hook in `.claude/settings.json` |
| "The agent needs to reach a system it can't" | Integration | `.mcp.json` |
| "This is about the user's role, preferences, or expertise" | User context | Auto-memory (`user` type) |
| "The user corrected or confirmed my approach" | Feedback | Auto-memory (`feedback` type) |
| "This is about project goals, deadlines, or decisions" | Project context | Auto-memory (`project` type) |
| "This is where to find info in an external system" | Reference | Auto-memory (`reference` type) |
| "Background context, rarely needed" | Reference docs | `docs/` (not auto-loaded) |

**Step 3: Check existing files.** Add to an existing file before creating a new one.

## Litmus Test

For every line in a config file: **"Would removing this cause Claude to make mistakes?"** Yes → keep. No → cut or move to `docs/`.

## Size Targets

| File type | Target | Hard limit |
|-----------|--------|------------|
| Root `CLAUDE.md` | <80 lines | 100 |
| Individual rule | <40 lines | 50 |
| Always-loaded total (root + unconditional rules) | <150 lines | 200 |
| Skill SKILL.md | <500 lines | 500 |
| Subdirectory CLAUDE.md | <100 lines | 150 |

## Reference

- Creating artifacts: `reference/creating-*.md` files in this skill directory
- Anthropic best practices: [reference/best-practices.md](reference/best-practices.md)
- Audit checklist: [reference/audit-checklist.md](reference/audit-checklist.md)
- Agent enablement philosophy: see project's `docs/architecture/` if available
