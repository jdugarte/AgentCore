# sync-docs (lite — Cline / Llama 8B)

Update docs from **diff + active session** (synthesize; do not paste raw session).

## Rules

- **One step per reply.**
- No `git commit` / `git push` / `git merge`.

## Preconditions

Need `docs/core/SYSTEM_ARCHITECTURE.md` and `docs/core/SPEC.md`.

## Routing (keep in head)

- Domain / entities → `SPEC.md`  
- Decisions → `docs/core/ADRs/`  
- Stack/boundaries → `SYSTEM_ARCHITECTURE.md`, `.cursorrules`  
- Conventions → `.cursorrules`  
- Schema meaning → `SCHEMA_REFERENCE.md` if project uses it  

## Step 1 — Plan

Read diff. If active session file exists, read it. List **≤ 6** doc updates you recommend (file + one line each). Ask “proceed?” `[PAUSE]`

## Step 2 — Apply

Apply approved edits only. Summarize what changed. `[PAUSE]`

For **8B**: do **one doc file per reply** if updates are large; tell user you will continue next turn.
