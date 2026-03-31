# Audit Checklist

Run with `/claude-ops audit`. Check each item and produce the report at the end.

## Size & Budget

- [ ] Root `CLAUDE.md` line count (target: <80, limit: 100)
- [ ] Unconditional rules total lines (target: <150 combined with root, limit: 200)
- [ ] Individual rule files (target: <40 each, limit: 50)
- [ ] Skill descriptions — run `/context` to check budget utilization

## Path-Scoping Opportunities

- [ ] Any content in unconditional rules that only applies to specific directories?
- [ ] Any root CLAUDE.md content that could move to a subdirectory CLAUDE.md?
- [ ] Any rule that could be split into path-scoped pieces?

## Staleness

- [ ] Do all referenced commands still work? (e.g., `pnpm api:regen`, `pnpm build:backend`)
- [ ] Do all referenced file paths still exist?
- [ ] Any rules about features/patterns that were removed or refactored?
- [ ] Any specs with outdated progress? (check `progress.md` files)

## Completeness

- [ ] Recent features with undocumented patterns or conventions?
- [ ] Recent bug fixes that should be in `common-mistakes.md` or `troubleshooting.md`?
- [ ] New directories without a `CLAUDE.md`? (check `packages/db/`, `e2e/`, etc.)
- [ ] Hook scripts still match what `settings.json` references?
- [ ] Memory entries that should be rules or CLAUDE.md content instead?

## Duplication

- [ ] Same instruction appearing in multiple files?
- [ ] Rules that overlap with subdirectory CLAUDE.md content?
- [ ] Memory entries that duplicate CLAUDE.md content? (check MEMORY.md)

## Report Format

```
## Claude Code Infrastructure Audit

**Health: [GREEN|YELLOW|RED]**

### Size Budget
| File | Lines | Target | Status |
|------|-------|--------|--------|
| ... | ... | ... | OK/WARN/OVER |

### Findings
1. [Finding with specific file and line reference]
2. ...

### Recommended Actions
- [ ] [Specific action to take]
```
