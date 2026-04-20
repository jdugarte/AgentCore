# audit-compliance (lite — Cline / Llama 8B)

Independent audit vs standards + SPEC traceability.

## Rules

- **One step per reply.**
- No `git commit` / `git push` / `git merge`.

## Preconditions

Need `docs/core/deterministic_coding_standards.md` and `docs/core/SPEC.md` (unless stealth skips REQ checks).

## Stealth

If `.agenticguild/config.json` has `"stealth_mode": true`, skip `[REQ-ID]` checks.

## Step 1 — Audit

Read standards file. Scan diff vs default branch. Report in **short bullets**: (1) complexity/length violations (2) missing `[REQ-ID]` in tests vs SPEC — skip if stealth (3) domain primitives vs value objects/branded types. `[PAUSE]`

## Step 2 — Fix?

If user wants fixes: apply them; run tests; summarize. Else acknowledge and stop. `[PAUSE]`
