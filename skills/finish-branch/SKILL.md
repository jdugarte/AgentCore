---
name: finish-branch
description: Handles the completion of a branch, PR creation, and CI/Bot feedback loops. Use when the user asks to "finish this branch", "open a PR for this", or complete their work on a feature.
---

# Finish Branch Skill

## Required files / Pre-flight

Before running this skill, check that these exist:

- `docs/ai/code_review_prompt.md` (for Phase 1 code review)
- `docs/core/SPEC.md` (for Phase 4 traceability audit)
- `templates/hre/jpl_standards.md` (Compliance reference)

**If any required file is missing:** Tell the user and point them to the Expected Project Structure document.

## Purpose
This skill orchestrates the aerospace-grade verification pipeline. It handles local checks, enforces compliance with JPL standards, and performs a final traceability audit before PR creation.

## Execution Rule (Critical)

**Always start with Phase 1, Step 1.** Do not skip to Phase 2 or Phase 3 unless the user explicitly says to skip the code review. Every time the user invokes "finish this branch", perform the **Interactive Local Review** first.

## Workflow

### PHASE 1: Local Code Review & Compliance
1.  **Interactive Local Review**
    *   **Action:** Trigger `code-review` skill using `docs/ai/code_review_prompt.md`.
    *   **Output:** List the findings clearly for the user. 
    *   **Instruction:** Ask the user WHICH specific points they would like you to fix.

2.  **Compliance Audit (JPL Standards)**
    *   **Action:** Trigger `audit-compliance` skill.
    *   **Checks:** Cyclomatic complexity (<10), function length (<60 lines), and assertion density (Pre/Post conditions).
    *   **Output:** If violations occur, the AI MUST propose refactors to achieve compliance.

3.  **Implementation & Pre-Flight Checks**
    *   **Action:** Implement requested fixes/refactors.
    *   **Command:** Execute project's pre-flight/lint and test suite commands.

4.  **Iterative Review Loop (The "Recursive Clean")**
    *   **Decision:** If any application code was modified in Step 3, you **MUST** loop back to Step 1 (**Interactive Local Review**) to ensure the new changes haven't introduced regressions or new HRE violations.
    *   **Instruction:** Explicitly ask the user: "I've applied the fixes. Shall I perform a final follow-up review to ensure everything is perfect, or proceed to the remote BugBot loop?"
    *   **Exit Condition:** Proceed to Phase 2 only when the user says "Proceed" or if no changes were needed in Step 3.

### PHASE 2: Remote Async Review & Testing
4.  **The BugBot Loop**
    *   **Action:** Instruct user to commit, push, and WAIT for BugBot feedback. **NEVER** commit or push for the user.
    *   **Instruction:** Pause. Tell user to paste feedback here. Fix issues, test, push again.

5.  **Test Gap Analysis & Edge Cases**
    *   **Action:** Review fixes. Ask if tests are needed for new late-stage edge cases.

### PHASE 3: Traceability & Final Spackle
6.  **Traceability Audit**
    *   **Action:** Scan all tests for `[REQ-ID]` tags.
    *   **Requirement:** Every `REQ-ID` listed in `implementation_plan.md` MUST have at least one passing test.
    *   **Output:** Alert the user if requirements are "untraced" (lack tests).

7.  **Documentation Sync**
    *   **Action 1 (Schema):** If DB schema modified, trigger `sync-schema-docs`, PAUSE for review.
    *   **Action 2 (General Docs):** Check if `SPEC.md` or other docs need updates.

8.  **Rule Harvesting**
    *   **Action:** Trigger `harvest-rules` skill to codify new patterns.

9.  **PR Description**
    *   **Action:** Trigger `pr-description-clipboard` skill. Ensure the draft mentions the `[REQ-ID]` and ADRs.

10. **Merge**
    *   **Action:** Tell user branch is ready for merge in GitHub UI.
