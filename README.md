# claude-ops

Agent infrastructure guide for Claude Code.

> "If a new **teammate's** agent session started right now with zero context, would it know how to do what I just did?"

Claude Code gives you rules, skills, agents, hooks, memory, and CLAUDE.md files. **claude-ops**
helps you decide which one to use, **where it should be scoped (git-tracked team vs personal)**,
create it correctly, and keep your infrastructure small and healthy over time.

Two opinions baked in:

- **Team knowledge by default.** New knowledge lands in the git-tracked repo so the whole team's
  agent harness compounds — personal machine-local memory is the rare, deliberate exception.
- **No god-files.** Knowledge is routed into small, on-demand, topic-owned files that split when
  they outgrow their budget — never piled into one ever-growing `common-mistakes.md`.

## What it does

| You say | claude-ops does |
|---------|----------------|
| "Where should this knowledge go?" | Runs the classification process — filter, scope (team vs personal), then artifact + load-trigger |
| "Create a rule / skill / agent / hook / CLAUDE.md / memory" | Targeted, best-practice reference for each artifact type |
| "Install the memory guard" | Sets up a user-scope hook that warns before a save lands in personal memory |
| `/claude-ops audit` | Runs the audit checklist and emits concrete actions: split, scope, promote, archive, drain |
| `/claude-ops` (no args) | Shows a live inventory with an honest always-loaded budget |

## Install

### As a Claude Code plugin

```
/plugin install gh:anton-haskevych/claude-ops
```

### Manual install (user-scope — available in every project)

```bash
git clone https://github.com/anton-haskevych/claude-ops.git
cp -r claude-ops/skills/claude-ops ~/.claude/skills/claude-ops
```

### Manual install (project-scope — shared with team via git)

```bash
git clone https://github.com/anton-haskevych/claude-ops.git
cp -r claude-ops/skills/claude-ops .claude/skills/claude-ops
```

Then use `/claude-ops` in any Claude Code session.

## The classification process

Two **independent** decisions, plus a filter.

**Step 1 — Filter.** Can a future session learn this from code, commands, or git history? Skip it.

**Step 2 — Scope (team by default).**

> **Tribe Test:** "Would a new teammate's agent session benefit from this?" → Yes = team → commit it.

Goes to personal machine-local memory **only** if it matches a narrow whitelist — local
creds/sandbox URLs, single-machine ergonomics, a non-conflicting personal preference, or ephemeral
scratch. Everything else is committed. In a non-git directory, claude-ops asks *global vs project*.

**Step 3 — Artifact + load-trigger** (prefer on-demand `paths:`-scoping over always-loaded):

| The knowledge is… | Artifact | Where |
|---|---|---|
| A "never do X" that's **mechanically checkable** on a tool call | Guard | `PreToolUse` hook in `.claude/settings.json` |
| A "never do X" / "when X breaks" tied to a **subsystem** | Topic rule | `.claude/rules/<topic>.md` **with `paths:`** |
| A "must/must not when working in `<area>`" | Path-scoped constraint | `.claude/rules/<topic>.md` **with `paths:`** |
| A "never do X" that can't be mechanized or scoped | Unconditional rule | small `.claude/rules/<topic>.md` (last resort) |
| Applies everywhere, every session | Universal rule | Root `CLAUDE.md` |
| "How a subsystem works" (descriptive) | Architecture | `<dir>/CLAUDE.md` |
| A recurring multi-step workflow | Skill | `.claude/skills/<name>/SKILL.md` |
| The agent needs to reach a system it can't | Integration | `.mcp.json` |
| "Why we chose X" (rationale) | Decision record | `docs/decisions/<n>-<slug>.md` |
| Genuinely personal (passes the whitelist) | Memory | `CLAUDE.local.md` / auto-memory |

There is **no fixed "mistakes" or "troubleshooting" sink** — a mistake or fix routes by the
subsystem it touches into a small topic-owner file.

## Decomposition

Files stay small and cheap to load. On every write: find the topic owner (via
`.claude/rules/INDEX.md`), append only if it stays under budget, otherwise **split** by topic into
sibling leaves — each with a `paths:` glob so it loads only when relevant. Only `paths:`-gating
actually reduces always-loaded context (`@import` does not). Retire a rule by **moving** it out of
the tree, never by a `status:` flag (discovery is unconditional).

## Personal-memory guard

`templates/personal-memory-guard.sh` is a `PreToolUse` hook that **warns (does not block)** when a
write targets personal machine-local memory (`~/.claude/projects/*/memory/`, `CLAUDE.local.md`),
so a personal save is a deliberate choice — not a team fact misrouted into invisible scope.
Installed at user scope, with your consent.

## Litmus test

For every line in an always-loaded file: **"Would removing this cause Claude to make mistakes?"**
Yes → keep. No → cut, scope it with `paths:`, or move to `docs/`.

## Size targets

| File type | Target | Hard limit |
|-----------|--------|------------|
| Root `CLAUDE.md` | <80 lines | 100 |
| Individual rule / leaf | <40 lines | 50 |
| Always-loaded total (root + ancestor CLAUDE.md + no-`paths:` rules + MEMORY.md) | <150 lines | 200 |
| Skill SKILL.md | <500 lines | 500 |
| Subdirectory CLAUDE.md | <100 lines | 150 |

## What's included

```
skills/claude-ops/
├── SKILL.md                    # Routing, scope + classification, decomposition, size targets
├── reference/
│   ├── creating-rules.md       # Topic leaves, paths-gating, split-on-overflow, INDEX
│   ├── creating-skills.md      # Skill structure, discovery vs invocation
│   ├── creating-agents.md      # Agent templates, isolation patterns
│   ├── creating-hooks.md       # Current hook contract, guard templates
│   ├── creating-claude-md.md   # Root vs subdirectory, prescriptive vs descriptive
│   ├── creating-memory.md      # Team-vs-personal scope, Tribe Test, git/non-git tree
│   ├── best-practices.md       # Anthropic's official skill authoring guidance
│   └── audit-checklist.md      # Budget, drain, scope-promotion, lifecycle — emits actions
├── templates/
│   ├── INDEX.md                # Routing/dedup index template
│   ├── leaf.md                 # Topic-owner rule leaf template
│   └── personal-memory-guard.sh# Warn-but-allow PreToolUse guard
└── scripts/
    └── inventory.sh            # Live inventory with an honest always-loaded budget
```

## License

Apache 2.0
