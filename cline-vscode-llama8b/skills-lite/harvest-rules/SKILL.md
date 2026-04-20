# harvest-rules (lite — Cline / Llama 8B)

Propose new rules from diff + optional `review_ledger.md` + active session.

## Rules

- **One step per reply.**
- No `git commit` / `git push` / `git merge`.

## Preconditions

Need `docs/core/SYSTEM_ARCHITECTURE.md` and `docs/core/SPEC.md`.

## Step 1 — Candidates

Read `review_ledger.md` if present. Read `current_state.md` + active session if pointer set. Read diff vs default branch. Propose **≤ 10** candidates as: `target_file → rule text`. Skip duplicates vs `SYSTEM_ARCHITECTURE.md` and `.cursorrules`. `[PAUSE]`

## Step 2 — Write

After user approves: write approved lines to `.cursorrules` and/or `SYSTEM_ARCHITECTURE.md` as agreed. Confirm files touched. `[PAUSE]`
