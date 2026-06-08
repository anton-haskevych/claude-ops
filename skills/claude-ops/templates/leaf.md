---
description: <one line — what this leaf owns. Used to build INDEX.md and to dedup at write time.>
paths:
  - "<subsystem>/**"
# ^ The `paths:` block makes this rule load ONLY when Claude reads a matching file (on-demand,
#   zero always-loaded cost). PREFER it. Omit the whole block ONLY for a true always-on rule
#   that cannot be scoped to any path — and keep those minimal, they spend budget every session.
---

# <Topic> — <constraints | troubleshooting>

- <entry: a single constraint ("never …") or a fix ("when X breaks → do Y")>
- <entry>

<!--
  Budget: target <40 lines / hard 50; ~5–8 entries. When an append would exceed either cap,
  SPLIT this leaf by sub-topic into sibling leaves in this same directory, give each its own
  `paths:` glob, leave a one-line pointer here (or delete this file), and regenerate INDEX.md.
  One topic per file. Never let this grow into a god-file.
-->
