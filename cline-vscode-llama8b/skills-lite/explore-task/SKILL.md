# explore-task (lite — Cline / Llama 8B)

Discovery only — **no app code or tests**. Plans go **on disk** in `.agenticguild/active_sessions/task_<slug>.md`.

## Rules

- **One step per reply.**
- No `git commit` / `git push` / `git merge`.
- Never put the full `<implementation_plan>` only in chat — write it in the session file.

## Preconditions

If `docs/core/SYSTEM_ARCHITECTURE.md` is missing, stop and ask user to add it or run project sync.

## Step A — Session

Read `.agenticguild/current_state.md`. If `<active_task_pointer>` names a file that exists, read that session; summarize in **5 bullets**; ask what to explore next. `[PAUSE]`

If no session: ask what they want to build or fix. `[PAUSE]`

## Step B — After user answers (first time)

Create `task_<kebab-slug>.md` under `.agenticguild/active_sessions/`. Set `current_state.md` `<active_task_pointer>` to that filename. Add notes and a `## Domain Model` section when entities appear. `[PAUSE]`

## Step C — Loop

Each reply: update session file with new decisions; ask if spec is complete. When user says ready: add `<implementation_plan>` with `<step id="N" status="pending">...</step>` (TDD-friendly). Say **file was written on disk**. `[PAUSE]`

## Step D — Handoff

Validate plan start lines: Bugfix → failing test first; Refactor → green baseline first; Feature → test-first steps. Then tell user to run **start-task** for execution. `[PAUSE]`
