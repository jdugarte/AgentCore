---
name: finish-branch
description: Orchestrates the "Verification & Polish" phase of the development lifecycle.
---

# Finish Branch Skill

**Goal:** Execute Verification & Polish safely, accommodating unpredictable loops and user-driven decisions.

## Workflow

### PHASE 1: Local Code Review & Polish
1.  **Interactive Local Review**
    *   **Action:** Trigger `code-review` skill using `docs/code_review_prompt.md`.
    *   **Output:** List the findings clearly for the user. 
    *   **Instruction:** Ask the user WHICH specific points they would like you to fix. Wait for their instructions before writing any code.

2.  **Implementation & Pre-Flight Checks**
    *   **Action:** Implement the changes the user requested.
    *   *Command:* `npm run check` (Runs lint, typescript checks, format, prune, coverage)
    *   *Command:* `npm test`
    *   **Instruction:** Fix any typescript/lint errors until the build is perfectly clean.

### PHASE 2: Remote Async Review & Testing
3.  **The BugBot Loop**
    *   **Action:** Instruct the user to commit, push the branch to GitHub, and WAIT for the BugBot review email.
    *   **Instruction:** Pause execution. Tell the user to paste BugBot's feedback here. If there are issues, fix them, run `npm run check`, ask the user to push again, and WAIT.
    *   **Exit Condition:** The user explicitly tells you "BugBot is happy" or that there are no more issues.

4.  **Test Gap Analysis & Edge Cases**
    *   **Action:** Once BugBot is satisfied, review all changes made during Phase 1 and 2.
    *   **Instruction:** Determine if these late-stage fixes uncovered edge cases or reduced code coverage. If they did, ask the user if they'd like tests written to cover them.

### PHASE 3: Final Spackle (Docs & PR)
5.  **Documentation Sync**
    *   **Action:** Ask the user if `docs/SPEC.md` or any architectural plans need updates based on the final, reviewed state of the code.

6.  **Rule Harvesting**
    *   **Action:** Trigger `harvest-rules` skill to codify any lessons learned or new patterns into `.cursorrules`.

7.  **PR Description**
    *   **Action:** Trigger PR description skill. Draft a PR description explaining the WHY and copy it to the clipboard.

## Example Trigger via Chat
"Finish this branch", "Run the finish branch workflow", or "Let's wrap up this PR."
