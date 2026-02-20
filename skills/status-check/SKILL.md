---
name: status-check
description: Rehydrates project context regarding the active feature. Use when the user asks "where are we at", "what's next", or if progress is blocked and you need to figure out who is blocking progress.
---

# Status Check Skill

## Purpose
To quickly rehydrate context during a long-running task, especially when picking up after a break or when an async process (like CI/CD or another developer's review) has halted momentum. It pinpoints exactly what has been done and *Who* is blocking progress.

## Instructions / Workflow

1. **Rehydrate Implementation Plan**
   - Look for `docs/implementation_plan.md` in the workspace. Read it explicitly.
   - Compare the plan's checklist against the files currently modified in the active branch (`git status`, `git diff main --name-status`).

2. **Assess Codebase & Tests**
   - Check if there are failing unit tests (`npm test`) or failing TS/Lint checks (`npm run check`) for the active files.
   - If there are local failures, compile a summary of the failing files/lines.

3. **Identify the Blocker ("Who is blocking?")**
   - **The AI / Developer (You):** If there are failing tests, uncommitted code, or unchecked boxes in the `implementation_plan.md` that you can directly address.
   - **The User:** If you are waiting for requirements clarification, approval on a plan, or manual UI verification.
   - **Remote Bots / CI:** If the PR is submitted but pipeline checks failed or remote reviews are pending.

4. **Report to User**
   - Print out a concise summary using the following Output Template:

   > **📍 Macro Status:** [e.g., Phase 2: The TDD Loop / Phase 3: Final Polish]
   > **📝 Micro Status:** [e.g., Step 2 of 3 - Building the Modal UI]
   > **🚦 Blocker:** [e.g., Waiting on User to approve tests]
   >
   > **Summary of where we left off:**
   > [Brief 2-3 sentence summary of the last completed action and the current state of the codebase. Explicitly mention if tests are passing or failing].
   >
   > **Suggested Next Action:**
   > [Specific recommendation, e.g., "Would you like me to write the tests for Step 2 now?" or "Please paste the BugBot review when ready."]
