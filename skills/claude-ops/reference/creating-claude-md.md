# Creating CLAUDE.md Files

CLAUDE.md files are **descriptive** — they explain how a subsystem works. Architecture, commands, layers, patterns.

## Root CLAUDE.md

- Universal essentials only — commands, architecture pointers, key integration points
- Always loaded, every session
- Target: under 80 lines, hard limit 100

## Subdirectory CLAUDE.md (e.g., `backend/CLAUDE.md`)

- Loaded on-demand when Claude reads files in that directory
- Domain-specific patterns, testing conventions, subsystem architecture
- Don't duplicate root — reference it
- Target: under 100 lines, hard limit 150

## When to Use CLAUDE.md (not a Rule)

Ask: "Is this explaining how something works?"
- **Yes** → CLAUDE.md (descriptive)
- **No, it's telling agents what they must/must not do** → path-scoped rule (prescriptive)

Examples of CLAUDE.md content: "this subsystem uses hexagonal architecture", "commands: `bun test`", "file layout: machines in src/, adapters in src/adapters/"

Examples that should be rules instead: "never use haiku", "always clear API key", "never hand-edit generated files"

## Conventions

- Don't duplicate root content in subdirectory files
- Include commands for the subsystem (build, test, lint)
- Include architecture overview (layers, key files)
- Point to specs for design context
