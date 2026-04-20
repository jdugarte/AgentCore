# process-feedback (lite — Cline / Llama 8B)

Interrupt handler: user pastes CI/lint/review text.

## Rules

- Fix **small** issues without asking. **Pause** only if change is a large multi-file redesign.
- No `git commit` / `git push` / `git merge`.
- If the message **already contains** error/log output (see CRITICAL table hints: tracebacks, `error:`, `FAIL`, etc.), **do not** ask the user to paste again. If they only said “process feedback” with **no** error text, ask **one** short line: paste the output.

## Step 1 — Fix + log

1. Parse feedback; locate files; apply fixes (batch edits per file when safe).  
2. Append each fixed item to `.agenticguild/review_ledger.md`: **Issue / Cause / Fix** (create file if missing).  
3. Short success message; say “Resuming previous task…” and continue the prior workflow if obvious from `current_state.md`; else ask one line what to resume. `[PAUSE]`
