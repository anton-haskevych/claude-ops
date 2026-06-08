# Audit Checklist

Run with `/claude-ops audit`. For **every** finding, emit a CONCRETE ACTION
(split / scope / promote / archive / drain) — not just an observation.

## Size & budget — run inventory first

`bash ${CLAUDE_SKILL_DIR}/scripts/inventory.sh` computes the *real* always-loaded set (root
`CLAUDE.md` + every no-`paths:` rule), so the budget can't lie as rules are decomposed.

- [ ] Always-loaded total — target <150, hard 200. → over: scope rules with `paths:`, or move content to `docs/`.
- [ ] Individual rule / leaf — target <40, hard 50; ~5–8 entries. → over: **SPLIT** by topic into sibling leaves, regen `INDEX.md`.
- [ ] Root `CLAUDE.md` — target <80, hard 100. → over: move subsystem detail into a `<dir>/CLAUDE.md`.

## God-file drain (the monolith check)

- [ ] Any always-loaded `common-mistakes.md` / `troubleshooting.md` / catch-all rule accumulating
      unrelated cases? → **DRAIN** (see procedure below). These are debt, not canonical files.

## Path-scoping opportunities

- [ ] Content in unconditional rules that only applies to specific directories? → add `paths:` and move to a topic leaf.
- [ ] Root `CLAUDE.md` content that belongs in a subdirectory `CLAUDE.md`? → move it.

## Scope promotion (team knowledge trapped in personal memory)

- [ ] Memory entries that pass the Tribe Test (a teammate's agent would benefit)? → **PROMOTE** to a
      committed rule / `CLAUDE.md` / `docs/decisions/` ADR. **Opt-in, per-entry confirmed** — never
      silently move a teammate's personal files across the git boundary.
- [ ] Memory entries duplicating committed content? → delete the memory copy.

## Staleness & lifecycle

- [ ] Referenced commands / file paths that no longer exist? → update, or archive the rule.
- [ ] Rules about removed/refactored features? → **ARCHIVE**: physically *move* the leaf to
      `.claude/archive/rules/` (a `status:` field does NOT unload it), regen `INDEX.md`.
- [ ] Specs with outdated progress? (check `progress.md` files)

## Completeness

- [ ] Recent features/bugfixes with undocumented constraints? → add a `paths:`-scoped topic leaf,
      or a hook if mechanically checkable.
- [ ] New directories without a `CLAUDE.md`?
- [ ] Hook scripts still match what `settings.json` references?

## Report format

```
## Claude Code Infrastructure Audit

**Health: [GREEN | YELLOW | RED]**

### Size Budget (from inventory.sh)
| File | Lines | Target | Status |
|------|-------|--------|--------|

### Actions (ordered, each concrete)
- [ ] SPLIT   <file> → <leaves>            (over 50 lines / 8 entries)
- [ ] SCOPE   <file>: add paths: <glob>    (unconditional but subsystem-specific)
- [ ] PROMOTE <memory entry> → <committed home>   (confirm)
- [ ] ARCHIVE <file> → .claude/archive/    (stale)
- [ ] DRAIN   <god-file>: <n> blocks → hooks/leaves   (confirm each)
```

## Draining an existing god-file (manual procedure)

No automated migration — drain deliberately, file by file:

1. Read the fat file whole.
2. For each H2 block pick a bucket: **mechanically-checkable** → a hook · **subsystem-scoped** →
   a `paths:` topic leaf · **unscopable residue** → a small unconditional leaf.
3. Create the target, move the content, infer each leaf's `paths:` glob.
4. Leave a one-line stub pointer in the source (or delete it) — **human-confirm before deleting**.
5. Regenerate `INDEX.md`.
