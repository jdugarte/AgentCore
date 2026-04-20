# code-review (lite — Cline / Llama 8B)

## Rules

- **One step per reply.**
- No `git commit` / `git push` / `git merge` — suggest `git commit -m "..."` as text only.
- If the user matched **code review** freeze phrases (CRITICAL table in `.clinerules/agentic-guild.md`), **do not** ask which files to review first — use **branch diff vs default branch**. If diff is empty, state that in one line; only then offer to review a user-named path.

## Preconditions

If `docs/ai/code_review_prompt.md` missing, stop; offer sync/templates.

## Step 1 — Review

Read `docs/ai/code_review_prompt.md`. Read branch diff vs default branch. Output numbered issues in **three buckets**: MUST FIX / SHOULD FIX / NICE. Keep list **≤ 12 items** total for 8B. Ask which numbers to fix (or “all” / “none”). `[PAUSE]`

## Step 2 — Fix

Apply chosen fixes only. Run tests/linter commands from `code_review_prompt.md` if listed. Report pass/fail briefly. Suggest commit message in a code block. Ask if another pass. `[PAUSE]`
