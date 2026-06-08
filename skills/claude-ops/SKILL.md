---
name: claude-ops
description: >
  Guide for building and evolving Claude Code agent infrastructure.
  Use when: deciding where knowledge belongs (rule vs skill vs memory vs hook vs CLAUDE.md),
  choosing scope (git-tracked team vs personal machine-local), creating or updating those
  artifacts, keeping them small and loaded on-demand, reflecting after implementation,
  or auditing config health.
argument-hint: [intent] — e.g., "where should this go?", "create a new rule", "audit"
allowed-tools: Read, Glob, Grep, Write, Edit, Bash, AskUserQuestion
---

# /claude-ops — Agent Infrastructure Guide

Core question: **"If a new teammate's agent session started right now with zero context, would it know how to do what I just did?"**

"Teammate" — not "I". The default home for knowledge is the **git-tracked repo**, where the whole team's harness compounds, not your machine-local memory.

## Routing

If `$ARGUMENTS` is empty → show the Live Inventory below and ask the user what they need.

If `$ARGUMENTS` contains "audit" → read [reference/audit-checklist.md](reference/audit-checklist.md) and run it.

If `$ARGUMENTS` mentions installing the personal-memory guard → read [reference/creating-hooks.md](reference/creating-hooks.md) (Personal-Memory Guard section).

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
!`ls ~/.claude/skills/ 2>/dev/null || echo "(none)"`

**Agents:**
!`ls .claude/agents/ 2>/dev/null || echo "(none)"`

**Rules:**
!`ls .claude/rules/ 2>/dev/null || echo "(none)"`

**Hooks & Permissions:** see `.claude/settings.json`

For detailed inventory with line counts: `bash ${CLAUDE_SKILL_DIR}/scripts/inventory.sh`

## Classification Process

When you have knowledge to place, run it through these three steps. Steps 2 and 3 are
**independent decisions** — decide *scope* (team vs personal) and *artifact + load-trigger*
separately, then combine.

**Step 1 — Filter.** Can a future session learn this from code, commands, or git history? If yes, skip it.

**Step 2 — Scope: team (committed) by default.** Personal machine-local memory is the rare exception, not the default.

> **Tribe Test:** "Would a new teammate's agent session benefit from this?" → **Yes = team knowledge → commit it.**

Default everything to the git-tracked repo. Send it to personal scope (`CLAUDE.local.md` or
auto-memory, both machine-local and invisible to teammates) **only** if it matches the narrow whitelist:
- local credentials, secrets, or sandbox URLs
- single-machine tooling/workflow ergonomics
- an individual preference that contradicts **no** team convention
- ephemeral personal scratch

Clear team-canon or clear whitelist → decide with no prompt. Genuinely ambiguous → ask
`[Team (committed) — default]` vs `[Personal (this machine only)]`. Full rules and the
git-repo vs non-git-dir decision tree: [reference/creating-memory.md](reference/creating-memory.md).

**Step 3 — Artifact + load-trigger.** Find the FIRST matching row. Default to **on-demand**
(`paths:`-scoped) over always-loaded — every always-loaded line is spent every session.

| The knowledge is… | Artifact | Where |
|---|---|---|
| A "never do X" that is **mechanically checkable** on a tool call | Guard | `PreToolUse` hook in `.claude/settings.json` (zero context, hard enforcement) |
| A "never do X" or "when X breaks" tied to a **subsystem** | Topic rule | `.claude/rules/<topic>.md` **with `paths:`** (loads on-demand) |
| A "must/must not when working in `<area>`" (prescriptive) | Path-scoped constraint | `.claude/rules/<topic>.md` **with `paths:`** |
| A "never do X" that can't be mechanized **or** scoped to paths | Unconditional rule | small `.claude/rules/<topic>.md` (no `paths:`) — **last resort** |
| Applies everywhere, every session | Universal rule | Root `CLAUDE.md` |
| "How a subsystem works" (descriptive) | Architecture | `<dir>/CLAUDE.md` (subdirectory) |
| A recurring multi-step workflow | Skill | `.claude/skills/<name>/SKILL.md` |
| The agent needs to reach a system it can't | Integration | `.mcp.json` |
| "Why we chose X" (rationale) | Decision record | `docs/decisions/<n>-<slug>.md` (committed, not auto-loaded) |
| Background context, rarely needed | Reference docs | `docs/` (not auto-loaded) |
| Genuinely personal (passes the whitelist above) | Memory | `CLAUDE.local.md` / auto-memory (machine-local) |

There is **no fixed "mistakes" or "troubleshooting" sink.** A mistake or a fix routes by the
subsystem it touches into a small topic-owner file — never into one growing god-file.

**Find the topic owner, then append-or-split.** Before writing, find the leaf that already owns
this topic (check `.claude/rules/INDEX.md` if present). Append only if the leaf stays under
budget; otherwise **split** (see Decomposition). Do **not** pile into an existing file past its budget.

## Decomposition

Files must stay small enough to read and cheap to load. On every write:

- **Per-leaf budget:** target <40 lines / **hard 50**; ~5–8 entries. Split on whichever cap hits first.
- **Split** by topic into child leaves in the same directory, give each a `paths:` glob inferred
  from the subsystem it covers, and leave a one-line pointer. Regenerate `.claude/rules/INDEX.md`.
- **Only `paths:`-gating actually saves always-loaded context.** Splitting into many *unconditional*
  leaves cuts cognitive load but not the session budget. `@import` does **not** save context (imports
  load at launch). Algorithm + templates: [reference/creating-rules.md](reference/creating-rules.md).
- **Retire by moving, not flagging.** A `status:` field does not unload a file — discovery is
  unconditional. To prune, physically move the leaf to `.claude/archive/` or `docs/`.

## Litmus Test

For every line in an always-loaded file: **"Would removing this cause Claude to make mistakes?"**
Yes → keep. No → cut, scope it with `paths:`, or move to `docs/`.

## Size Targets

| File type | Target | Hard limit |
|-----------|--------|------------|
| Root `CLAUDE.md` | <80 lines | 100 |
| Individual rule / leaf | <40 lines | 50 |
| Always-loaded total (root + ancestor CLAUDE.md + no-`paths:` rules + MEMORY.md) | <150 lines | 200 |
| Skill SKILL.md | <500 lines | 500 |
| Subdirectory CLAUDE.md | <100 lines | 150 |

## Reference

- Creating artifacts: `reference/creating-*.md` files in this skill directory
- Anthropic best practices: [reference/best-practices.md](reference/best-practices.md)
- Audit checklist: [reference/audit-checklist.md](reference/audit-checklist.md)
- Templates (INDEX, leaf, guard hook): `templates/` in this skill directory
