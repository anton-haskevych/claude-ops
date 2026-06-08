# Creating Rules

Rules live in `.claude/rules/*.md` — a native, recursively-discovered location. They are
**prescriptive**: constraints, requirements, things agents must/must not do.

## Load semantics — choose the trigger deliberately

- **Path-scoped** (`paths:` frontmatter) — loads ONLY when Claude reads a file matching the glob.
  On-demand; costs **zero** always-loaded context. **Prefer this.**
- **Unconditional** (no `paths:`) — loads at session start, every session. Keep the combined
  total minimal; use only when the rule truly applies everywhere.

`@import` does **not** reduce context — an imported file loads at launch just like its importer.
Only `paths:`-gating, a hook, or moving content to `docs/` actually shrinks the always-loaded budget.

## Path-Scoped Rule Template

```markdown
---
paths:
  - "directory/**/*.ext"
---

# Rule Name

Concise instructions. Each line passes the litmus test.
```

## First: is it even a rule?

Ask: "Is this telling agents what they must/must not do?"

- **Yes, and it's mechanically checkable on a tool call** (e.g. "never use haiku with `claude -p`",
  "always clear `ANTHROPIC_API_KEY`", "never hand-edit generated files") → **a hook, not a rule.**
  A `PreToolUse` hook enforces deterministically at zero context cost. See [creating-hooks.md](creating-hooks.md).
- **Yes, tied to a subsystem/area** → path-scoped rule with `paths:`.
- **Yes, but unmechanizable and unscopable** → small unconditional rule (last resort).
- **No — it explains how something works** → subdirectory `CLAUDE.md`.

## One topic per file — no god-files

Route each constraint into a **small, descriptively-named topic-owner file** scoped to the
subsystem it touches: `troubleshooting-ecs.md`, `mistakes-auth.md`, `infra-email.md` — never
`rule-7.md`, and never a single growing `common-mistakes.md` / `troubleshooting.md` that
accumulates every unrelated case.

> If a repo already has a fat `common-mistakes.md` or `troubleshooting.md`, treat it as debt to
> **drain** into topic-owner leaves — it is not the place to add the next row.

## Budgets and split-on-overflow

- Individual rule/leaf: target <40 lines, **hard 50**; ~5–8 entries. Split on whichever cap hits first.
- Always-loaded budget: root `CLAUDE.md` + ancestor `CLAUDE.md` + every no-`paths:` rule +
  `MEMORY.md`, under 150 lines, **hard 200**.

**Write algorithm** (run on every append):

1. **Find the topic owner** via `.claude/rules/INDEX.md` (or by glob-matching the subsystem the new
   case touches). If a near-duplicate leaf exists, **update it** rather than creating a sibling.
2. If appending keeps the leaf under budget → append.
3. Else **split**: divide by H2 block into child leaves in the same directory, infer each child's
   `paths:` glob from its subsystem, leave a one-line stub pointer in (or delete) the old file, and
   regenerate `INDEX.md`.

Templates: `templates/leaf.md`, `templates/INDEX.md`.

## INDEX — routing + dedup, NOT loading

Native discovery already loads the rules; you do **not** need an index to load them.
`.claude/rules/INDEX.md` exists only so the router can find which leaf owns a topic and avoid
duplicates. Keep it out of the always-loaded set (it's navigation, not instruction). Regenerate it
on every split/merge from each leaf's `description` + `paths` frontmatter.

## Retiring a rule

A `status:` field does **not** unload a file — discovery is unconditional. To retire a rule,
**physically move** the leaf out of `.claude/rules/` (to `.claude/archive/rules/` or
`docs/decisions/`), preserving git history, then regenerate `INDEX.md`.
