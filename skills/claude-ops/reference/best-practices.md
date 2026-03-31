# Skill Authoring Best Practices

Distilled from Anthropic's official docs. This is the upstream source of truth.

Sources: [Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices), [Extend Claude with skills](https://code.claude.com/docs/en/skills)

## Core Principles

**Concise is key.** The context window is shared. Claude is already smart — only add what it doesn't already know. Challenge each piece: "Does Claude really need this explanation?"

**Progressive disclosure.** SKILL.md is the overview + navigation. Reference files load on-demand. Keep SKILL.md under 500 lines. Move detailed docs to separate files. Keep references one level deep from SKILL.md — no nested chains.

**Description is critical.** Claude uses it to choose the right skill from 100+ available. Write in third person. Include both what the skill does AND when to use it. Be specific with key terms.

## Skill Structure

```
my-skill/
├── SKILL.md              # Overview + navigation (loaded when triggered)
├── reference/            # Detailed docs (loaded as needed)
│   ├── topic-a.md
│   └── topic-b.md
├── examples/
│   └── sample.md
└── scripts/
    └── helper.sh         # Executed, not loaded into context
```

## Content Types

**Reference content** — conventions, patterns, knowledge. Runs inline alongside conversation. Example: API design patterns, coding standards.

**Task content** — step-by-step workflows. Often uses `context: fork` for isolation. Often `disable-model-invocation: true` to prevent auto-triggering. Example: deploy, commit, send-message.

## Prescriptive vs Descriptive (project-specific learning)

This distinction applies to ALL agent infrastructure, not just skills:

- **Prescriptive** ("must/must not do X") → path-scoped rule (`.claude/rules/<name>.md` with `paths:`)
- **Descriptive** ("how this works") → subdirectory CLAUDE.md

If content contains constraints, commands to follow, or things to avoid — it's a rule. If it explains architecture, layers, or how a subsystem is organized — it's a CLAUDE.md.

## Degrees of Freedom

Match specificity to fragility:

- **High freedom** (text instructions) — multiple approaches valid, context-dependent. Code review, writing style.
- **Medium freedom** (pseudocode/templates) — preferred pattern exists, some variation OK.
- **Low freedom** (exact scripts) — fragile operations, consistency critical. DB migrations, deployments.

## Anti-Patterns

- **Over-explaining.** Don't explain what PDFs are. Don't teach Claude how libraries work.
- **Too many options.** Provide a default, not a menu. "Use pdfplumber. For scanned PDFs, use pytesseract instead."
- **Deeply nested references.** SKILL.md → advanced.md → details.md loses context. Keep one level deep.
- **Vague descriptions.** "Helps with documents" → Claude can't select it. "Extract text and tables from PDF files, fill forms. Use when working with PDFs or document extraction." → Claude knows when.
- **Time-sensitive info.** "Before August 2025, use the old API" — will rot. Use "Current method" / "Old patterns" sections instead.
- **Inconsistent terminology.** Pick one term: "API endpoint", not mixing "URL", "route", "path".

## Checklist Before Shipping a Skill

- [ ] Description includes what + when, written in third person
- [ ] SKILL.md under 500 lines, reference material in separate files
- [ ] No unnecessary explanations (Claude already knows common concepts)
- [ ] References are one level deep from SKILL.md
- [ ] Consistent terminology throughout
- [ ] Examples are concrete, not abstract
- [ ] Workflows have clear steps with feedback loops where appropriate
- [ ] Tested with real usage scenarios
