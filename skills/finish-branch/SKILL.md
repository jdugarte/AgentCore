---
name: finish-branch
description: Handles the completion of a branch, PR creation, and CI/Bot feedback loops. Use when the user asks to "finish this branch", "open a PR for this", or complete their work on a feature.
---

# Finish Branch Skill

## Required files / Pre-flight

Before running this skill, check that these exist:

- `docs/ai/code_review_prompt.md` (for Phase 1 code review)
- Optionally: `docs/core/SPEC.md`, `docs/core/ADRs/` (for Phase 3 doc sync and ADR mentions)

**If `docs/ai/code_review_prompt.md` is missing:** Tell the user and point them to the Expected Project Structure document (`docs/ai/EXPECTED_PROJECT_STRUCTURE.md` in your project after sync, or `playbooks/EXPECTED_PROJECT_STRUCTURE.md` in AgentCore). Do not invent review criteria. **If the user explicitly asks you to create it,** you may do so by following the "How to create" instructions in that document (e.g. copy from the right stack template into `docs/ai/code_review_prompt.md`). You may still guide the user through manual review and PR drafting; skip steps that depend on the missing file and list what they need to add for full workflow support.

## Purpose
This skill orchestrates the end-of-branch workflow. It handles the local checks, creates the PR draft, and most importantly, manages the async loop of waiting for remote CI checks and GitHub bot reviews by explicitly pausing for user feedback.

## Execution Rule (Critical)

**Always start with Phase 1, Step 1.** Do not skip to Phase 2 or Phase 3 unless the user explicitly says to skip the code review (e.g. "skip the review" or "BugBot is happy, do Phase 3 only"). Every time the user invokes "finish this branch", perform the **Interactive Local Review** first: run the review, list findings, and ask which to fix. Only after the user responds (with fixes to apply or "none" / "skip") may you proceed.

## Workflow

### PHASE 1: Local Code Review & Polish
1.  **Interactive Local Review**
    *   **Action:** Trigger `code-review` skill using `docs/ai/code_review_prompt.md`.
    *   **Output:** List the findings clearly for the user. 
    *   **Instruction:** Ask the user WHICH specific points they would like you to fix. Wait for their instructions before writing any code.

2.  **Implementation & Pre-Flight Checks**
    *   **Action:** Implement the changes the user requested.
    *   *Command:* Execute the project's primary pre-flight/lint check command (as defined in the project's documentation or `.cursorrules`).
    *   *Command:* Execute the project's test suite command (e.g., `npm test`, `rspec`).
    *   **Instruction:** Fix any linter, type, or test errors natively required by this tech stack until the build is perfectly clean.

### PHASE 2: Remote Async Review & Testing
3.  **The BugBot Loop**
    *   **Action:** Instruct the user to explicitly review all changes, commit them, push the branch to GitHub, and WAIT for the BugBot review email. **CRITICAL RULE: NEVER commit or push on the user's behalf. At most, you may suggest a commit message for their uncommitted changes.**
    *   **Instruction:** Pause execution. Tell the user to paste BugBot's feedback here. If there are issues, fix them, run the relevant verification commands (linters/tests), ask the user to commit/push again, and WAIT.
    *   **Exit Condition:** The user explicitly tells you "BugBot is happy" or that there are no more issues.

4.  **Test Gap Analysis & Edge Cases**
    *   **Action:** Once BugBot is satisfied, review all changes made during Phase 1 and 2.
    *   **Instruction:** Determine if these late-stage fixes uncovered edge cases or reduced code coverage. If they did, ask the user if they'd like tests written to cover them.

### PHASE 3: Final Spackle (Docs & PR)
5.  **Documentation Sync**
    *   **Action 1 (Schema):** Check if the database schema file (e.g., `db/schema.ts`, `db/schema.rb`, or equivalent database schema file) was modified. If so, announce you are generating schema docs, trigger the `sync-schema-docs` skill, and PAUSE for the user to review/commit.
    *   **Action 2 (General Docs):** Check if `docs/core/SPEC.md` or any other architectural, UI, or feature plans in the `docs/` folder need updates based on the final, reviewed state of the code in this branch.
    *   **Instruction:** Explicitly advise the user on which specific documents (if any) are now out-of-date or drifting because of their code changes, and ask if they would like you to update them.

6.  **Rule Harvesting**
    *   **Action:** Trigger `harvest-rules` skill to codify any lessons learned or new patterns into `.cursorrules`.

7.  **PR Description**
    *   **Action:** Trigger `pr-description-clipboard` skill. Draft the PR description (which automatically checks for new ADRs) and copy it to the clipboard.

8.  **Merge**
    *   **Action:** Tell the user the branch is officially finished and ready to be merged via the GitHub UI.
