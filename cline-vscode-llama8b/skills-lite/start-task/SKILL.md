# start-task (lite — Cline / Llama 8B)

Implements work with **TDD** and session file `.agenticguild/active_sessions/task_<slug>.md`.

## Rules

- **One step per reply** (except auto-transitions noted below).
- No `git commit` / `git push` / `git merge`.
- **Plans live in the session file** — not long plan dumps in chat.
- Read `.agenticguild/current_state.md` before coding.

## Preconditions

Need `docs/core/SYSTEM_ARCHITECTURE.md` and `docs/core/SPEC.md` or stop and offer templates/sync.

## Step 1 — Task + class

If user gave a task: match `docs/ROADMAP.md` if it exists; else ask classification: Feature / Bugfix / Refactor / Chore. `[PAUSE]`

## Step 2 — Session + plan on disk

Ensure `task_<slug>.md` exists; set `<active_task_pointer>`. Write `<implementation_plan>` with pending steps in file. Confirm **on disk**. Ask approval. `[PAUSE]`

## Step 3 — Approve plan

On approval: if plan invalid, fix file and re-ask. Else go to execution. `[PAUSE]` or auto to Step 4.

## Step 4 — Feature only: types gate

If Feature: ensure `## Domain Model` in session (value objects / branded types). Approve with user. Update file. `[PAUSE]`  
Bugfix/Refactor/Chore: skip to Step 5.

## Step 5 — TDD micro-loop (repeat)

1. Read session from disk; pick next `status="pending"` step.  
2. **One step only:** write **failing test** (add `[REQ-ID]` from SPEC unless stealth — see config).  
3. `[PAUSE]`  
4. Next reply: implement **minimal** code to pass; enforce: functions ≤60 lines, cyclomatic ≤10, no raw primitives for domain concepts; follow `SYSTEM_ARCHITECTURE.md`. If `.cursor/templates/CbC_GENERATION_PROMPT.md` exists, read it; else apply those constraints from memory.  
5. Mark step `complete` in session file. Run linters/tests if known. `[PAUSE]`

## Step 6 — Done

When no pending steps: suggest **finish-branch**. `[PAUSE]`

## Stealth

Read `.agenticguild/config.json`. If `"stealth_mode": true`, do not announce; **omit `[REQ-ID]`** in tests.
