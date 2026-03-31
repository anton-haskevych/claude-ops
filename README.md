# claude-ops

Agent infrastructure guide for Claude Code.

> "If a new agent session started right now with zero context, would it know how to do what I just did?"

Claude Code gives you rules, skills, agents, hooks, memory, and CLAUDE.md files. **claude-ops** helps you decide which one to use, create it correctly, and keep your infrastructure healthy over time.

## What it does

| You say | claude-ops does |
|---------|----------------|
| "Where should this knowledge go?" | Runs the classification process — filters, classifies, checks existing files |
| "Create a new skill" | Loads the skill authoring guide with checklist, structure, and conventions |
| "Create a rule / hook / agent / CLAUDE.md / memory" | Targeted reference for each artifact type |
| `/claude-ops audit` | Runs the full audit checklist: size budgets, staleness, duplication, completeness |
| `/claude-ops` (no args) | Shows live inventory of your project's infrastructure |

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

## The classification table

The core decision framework. When you have knowledge to place:

**Step 1: Filter.** Can a future session learn this from code, commands, or git history? If yes, skip it.

**Step 2: Classify.** Find the FIRST matching row:

| Ask this question | Type | Where |
|---|---|---|
| "An agent should NEVER do this" | Mistake | `.claude/rules/common-mistakes.md` |
| "When X breaks, here's the fix" | Troubleshooting | `.claude/rules/troubleshooting.md` |
| "You must/must not do X when working here" | Constraint | `.claude/rules/<name>.md` with `paths:` |
| "This applies everywhere in the project" | Universal rule | Root `CLAUDE.md` |
| "This is how a subsystem works" | Architecture | `<dir>/CLAUDE.md` |
| "This is a multi-step workflow that recurs" | Skill | `.claude/skills/<name>/SKILL.md` |
| "This must happen mechanically, no exceptions" | Guard | Hook in `.claude/settings.json` |
| "The agent needs to reach a system it can't" | Integration | `.mcp.json` |
| "This is about user role, preferences, expertise" | User context | Auto-memory (`user` type) |
| "The user corrected or confirmed my approach" | Feedback | Auto-memory (`feedback` type) |
| "This is about project goals, deadlines, decisions" | Project context | Auto-memory (`project` type) |
| "This is where to find info in an external system" | Reference | Auto-memory (`reference` type) |
| "Background context, rarely needed" | Reference docs | `docs/` (not auto-loaded) |

**Step 3: Check existing files.** Add to an existing file before creating a new one.

## Litmus test

For every line in a config file: **"Would removing this cause Claude to make mistakes?"**

Yes → keep. No → cut or move to `docs/`.

## Size targets

| File type | Target | Hard limit |
|-----------|--------|------------|
| Root `CLAUDE.md` | <80 lines | 100 |
| Individual rule | <40 lines | 50 |
| Always-loaded total (root + unconditional rules) | <150 lines | 200 |
| Skill SKILL.md | <500 lines | 500 |
| Subdirectory CLAUDE.md | <100 lines | 150 |

## What's included

```
skills/claude-ops/
├── SKILL.md                    # Routing, classification table, litmus test, size targets
├── reference/
│   ├── creating-rules.md       # Path-scoped rules, conventions, templates
│   ├── creating-skills.md      # Skill structure, discovery vs invocation
│   ├── creating-agents.md      # Agent templates, isolation patterns
│   ├── creating-hooks.md       # Hook lifecycle, script conventions
│   ├── creating-claude-md.md   # Root vs subdirectory, prescriptive vs descriptive
│   ├── creating-memory.md      # Memory types, what memory is NOT for
│   ├── best-practices.md       # Anthropic's official skill authoring guidance
│   └── audit-checklist.md      # Size budgets, staleness, completeness, duplication
└── scripts/
    └── inventory.sh            # Live infrastructure inventory with line counts
```

## License

Apache 2.0
