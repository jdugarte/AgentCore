# finish-branch (lite — Cline / Llama 8B)

Wrap branch: review → audit → CI loop → docs/rules → PR text → optional session archive.

## Rules

- **One step per reply.**
- No `git commit` / `git push` / `git merge`.

## Stealth

Read `.agenticguild/config.json`. If `"stealth_mode": true`, skip: sync-docs, harvest-rules, CHANGELOG/ROADMAP updates (see steps below). Do not announce stealth.

## Step 1 — Code review

Follow **`cline-vscode-llama8b/skills-lite/code-review/SKILL.md`** until it pauses after first review pass. Then return here; ask continue finish-branch. `[PAUSE]`

## Step 2 — Compliance

Read `docs/core/deterministic_coding_standards.md`. Scan diff: complexity/length, `[REQ-ID]` in tests (skip if stealth), domain primitives. Short findings; ask fix or proceed. `[PAUSE]`

## Step 3 — Fixes (if requested)

Apply compliance fixes; run tests. Report. `[PAUSE]`

## Step 4 — CI

Tell user to push; update `current_state.md` to “waiting CI” if you track that. Ask for pasted CI output or “green”. `[PAUSE]`

## Step 5 — CI feedback

If errors: fix + tests; repeat Step 4. If green: continue. `[PAUSE]`

## Step 6 — Final (non-stealth)

One sub-step per reply if needed:

- Run **`sync-docs/SKILL.md`** lite (this pack). `[PAUSE]`
- Run **`harvest-rules/SKILL.md`** lite. `[PAUSE]`
- User-facing changes → `CHANGELOG.md`; roadmap item → update `docs/ROADMAP.md` if known. `[PAUSE]`
- Run **`pr-description/SKILL.md`** lite. `[PAUSE]`

**Stealth:** skip entire Step 6 doc/rule edits; still can offer PR description if user wants minimal text.

## Step 7 — Clear session?

Ask to archive active session to `.agenticguild/completed_sessions/` and set pointer `[NONE]` in `current_state.md`. If yes: move file with date suffix; reset state. `[PAUSE]`
