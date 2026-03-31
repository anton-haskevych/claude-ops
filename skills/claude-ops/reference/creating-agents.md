# Creating Agents

Agents live in `.claude/agents/<name>.md`. They run in isolated subagent context.

## Template

```markdown
---
name: agent-name
description: What this agent does and when to use it
tools: Read, Grep, Glob, Bash
model: sonnet
---

# Agent instructions here
```

## Frontmatter Fields

- `name` — kebab-case identifier
- `description` — what + when (same principles as skill descriptions)
- `tools` — restrict to minimum needed. Read-only agents: `Read, Grep, Glob`
- `model` — pick cheapest that works. `sonnet` for most tasks, `opus` for deep reasoning

## When to Use Agents

Agents benefit from **isolation** — separate context window, separate tool access:
- Research and exploration (read-only tools)
- Code review (focused evaluation without conversation history)
- Test generation
- Parallel work (multiple agents run concurrently)

## Locations

- **Project agents**: `.claude/agents/` — shared via git, available to all team members
- **User agents**: `~/.claude/agents/` — personal, not shared

## Dual-Use Pattern

Agent files can serve double duty — usable both manually (`/agent principal-engineer`) and programmatically (loaded by pipeline as `--append-system-prompt`). When loading for programmatic use, strip frontmatter with `gray-matter` — the frontmatter is metadata for Claude Code, not instruction content.
