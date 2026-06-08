# Scope: Team (Committed) vs Personal (Memory)

The default home for knowledge is the **git-tracked repo**, where the whole team's agent harness
compounds over time. Personal machine-local memory (`~/.claude/projects/.../memory/`,
`CLAUDE.local.md`) is the rare exception — invisible to teammates, never committed. Reach for it
last, not first.

## The Tribe Test

> **"Would a new teammate's agent session benefit from this?"** → Yes = team knowledge → commit it.

Apply it to every fact before considering memory.

## Default committed; personal only by whitelist

Send a fact to PERSONAL scope **only** if it matches one of these:

1. local credentials, secrets, or sandbox URLs
2. single-machine tooling/workflow ergonomics (your shell aliases, your editor)
3. an individual preference that contradicts **no** team convention
4. ephemeral personal scratch

Everything else is team knowledge → route it to a committed artifact.

## Where team knowledge actually goes (usually NOT memory)

The four "memory types" that legacy setups dumped into per-user auto-memory almost always belong
in the committed repo instead:

| Legacy "memory type" | Tribe Test | Real home |
|---|---|---|
| **user** — role / preferences / expertise | usually personal | personal memory — the one genuinely common personal case (unless it's a *team* role fact) |
| **feedback** — "corrected/confirmed my approach" | usually **TEAM** | a path-scoped rule, or a **hook** if mechanizable. *"Don't mock the DB — prior prod incident"* is team-safety canon, **not** a personal note. |
| **project** — goals / deadlines / decisions | **TEAM** | `docs/decisions/<n>-<slug>.md` for rationale; root or `<dir>/CLAUDE.md` for standing facts |
| **reference** — where to find external info | **TEAM** if the system is shared | committed `CLAUDE.md` or a rule (e.g. "pipeline bugs → Linear project INGEST") |

Only the genuinely-personal residue stays in machine-local memory.

## Ambiguity → ask, with Team as the default

If a fact could honestly be either, ask `[Team (committed) — default]` vs
`[Personal (this machine only)]`, each with its one-line consequence. Clear cases decide with no prompt.

Before the first write into a committed file, preview the target and scan the index/`MEMORY.md`
for a near-duplicate — never silently commit a secret or a personal note into a shared repo.

## Git-repo vs non-git directory

Detect first: `git rev-parse --show-toplevel`.

- **In a git repo** → committed-default applies; team artifacts resolve under the repo root;
  personal exceptions go to `CLAUDE.local.md` (gitignored) or auto-memory.
- **In a non-git directory** (e.g. `~/IdeaProjects`) → there is no committed layer, so do **not**
  silently write "team" knowledge to an untracked place. Ask: **global (`~/.claude/…`) vs
  project-local**. (Honors the standing rule that non-git dirs prompt for scope.)

## If memory really is the answer

Auto-memory persists at `~/.claude/projects/.../memory/` with a `MEMORY.md` index (one line per
entry, <150 chars, max 200 lines). Use it only for the personal residue above, and only for
knowledge NOT derivable from code, commands, or git.

## What memory is NOT for

- Code patterns, conventions, architecture → committed `CLAUDE.md` or a rule
- File paths, project structure → Glob/Grep finds them
- Git history, recent changes → `git log` / `git blame`
- Debugging solutions → the fix lives in the code or a topic rule
- Anything already in a committed file → don't duplicate
