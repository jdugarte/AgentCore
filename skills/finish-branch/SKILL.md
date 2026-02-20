---
name: finish-branch
description: Handles the completion of a branch, PR creation, and CI/Bot feedback loops. Use when the user asks to "finish this branch", "open a PR for this", or complete their work on a feature.
---

# Finish Branch Skill

## Purpose
This skill orchestrates the end-of-branch workflow. It handles the local checks, creates the PR draft, and most importantly, manages the async loop of waiting for remote CI checks and GitHub bot reviews by explicitly pausing for user feedback.

## Workflow

### PHASE 1: Local Code Review & Polish
1.  **Interactive Local Review**
    *   **Action:** Trigger `code-review` skill using `docs/ai/code_review_prompt.md`.
    *   **Output:** List the findings clearly for the user. 
    *   **Instruction:** Ask the user WHICH specific points they would like you to fix. Wait for their instructions before writing any code.

2.  **Implementation & Pre-Flight Checks**
    *   **Action:** Implement the changes the user requested.
    *   *Command:* `npm run check` (Runs lint, typescript checks, format, prune, coverage)
    *   *Command:* `npm test`
    *   **Instruction:** Fix any typescript/lint errors until the build is perfectly clean.

### PHASE 2: Remote Async Review & Testing
3.  **The BugBot Loop**
    *   **Action:** Instruct the user to explicitly review all changes, commit them, push the branch to GitHub, and WAIT for the BugBot review email. Do NOT push on their behalf.
    *   **Instruction:** Pause execution. Tell the user to paste BugBot's feedback here. If there are issues, fix them, run `npm run check`, ask the user to commit/push again, and WAIT.
    *   **Exit Condition:** The user explicitly tells you "BugBot is happy" or that there are no more issues.

4.  **Test Gap Analysis & Edge Cases**
    *   **Action:** Once BugBot is satisfied, review all changes made during Phase 1 and 2.
    *   **Instruction:** Determine if these late-stage fixes uncovered edge cases or reduced code coverage. If they did, ask the user if they'd like tests written to cover them.

### PHASE 3: Final Spackle (Docs & PR)
5.  **Documentation Sync**
    *   **Action:** Check if `db/schema.ts` was modified. If so, announce you are generating schema docs, trigger the `sync-schema-docs` skill, and PAUSE for the user to review/commit. Ask if `docs/core/SPEC.md` or any architectural plans need updates based on the final, reviewed state of the code.

6.  **Rule Harvesting**
    *   **Action:** Trigger `harvest-rules` skill to codify any lessons learned or new patterns into `.cursorrules`.

7.  **PR Description**
    *   **Action:** Trigger `pr-description-clipboard` skill. Draft the PR description (which automatically checks for new ADRs) and copy it to the clipboard.

8.  **Merge**
    *   **Action:** Tell the user the branch is officially finished and ready to be merged via the GitHub UI.
