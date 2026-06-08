<!--
  TEMPLATE for `.claude/rules/INDEX.md` — a routing + dedup map, NOT loaded as instructions.
  Purpose: let the router find which leaf already owns a topic (so it appends/updates instead
  of spawning a near-duplicate), and let humans navigate. Native discovery already LOADS the
  rules — this index never needs to be loaded itself; keep it out of the always-loaded set.

  Regenerate on every split/merge from each leaf's `description` + `paths` frontmatter.
  One row per leaf:  file  |  loads-when (paths glob, or "always")  |  one-line topic it owns.
  Copy the table below, delete these comments and the example rows.
-->

# Rules Index

| Leaf | Loads when | Owns |
|------|-----------|------|
| `troubleshooting-ecs.md` | `infra/ecs/**` | ECS deploy/runtime failures and their fixes |
| `mistakes-auth.md` | `**/auth/**` | Auth pitfalls an agent must never repeat |
| `project-conventions.md` | always | Project-wide constraints that genuinely resist path-scoping |
