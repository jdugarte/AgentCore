---
name: status-check
description: Rehydrates full context so the user can seamlessly resume work on a feature, even in a brand new chat session after a long gap.
---

# Status Check Skill

**Goal:** Provide a comprehensive status report that reconstructs the exact state of the project, allowing the user to jump between features and chats agilely.

## Instructions for the Agent (Rehydrating Context)

When invoked, you MUST investigate the following to reconstruct the exact state of the project:
1.  **The Plan:** Read `implementation_plan.md` to identify the hierarchical steps and overall goal.
2.  **The Code & Tests:** Check the codebase against the plan. Which steps are already implemented? Are there failing tests (`npm test`)? Is the linter happy (`npm run check`)?
3.  **The Polish State:** Is the code waiting for a BugBot review on GitHub? Has a PR been drafted?

## Determine the Current Status

Based on your context gathering, pinpoint exactly WHO is blocking progress and WHERE you are in the workflow:

*   **Discovery Phase:** "Waiting on User (Gathering requirements for the Implementation Plan)"
*   **TDD Loop:** "Executing Step [X] of [Y]: [Task Name]."
    *   *If tests exist but fail:* "Waiting on AI (Need to write implementation code to pass tests)."
    *   *If code exists but tests fail/missing:* "Waiting on AI (Need to write tests)."
    *   *If both pass:* "Waiting on User (Ready to proceed to Step [X+1])."
*   **Local Code Review:** "Waiting on User (Code review findings presented, awaiting selection of fixes)."
*   **Remote Polish (BugBot):** "Waiting on BugBot (Paused: awaiting remote async review or user to say 'BugBot is happy')."
*   **Final Polish:** "Waiting on AI/User (Drafting PR, checking test gaps, harvesting rules)."

## Output Template

> **📍 Macro Status:** [e.g., Phase 2: The TDD Loop / Phase 3: Final Polish]
> **📝 Micro Status:** [e.g., Step 2 of 3 - Building the Modal UI]
> **🚦 Blocker:** [e.g., Waiting on User to approve tests]
>
> **Summary of where we left off:**
> [Brief 2-3 sentence summary of the last completed action and the current state of the codebase. Explicitly mention if tests are passing or failing].
>
> **Suggested Next Action:**
> [Specific recommendation, e.g., "Would you like me to write the tests for Step 2 now?" or "Please paste the BugBot review when ready."]

## Example Trigger via Chat
"Status check", "Where are we?", "Context resume"
