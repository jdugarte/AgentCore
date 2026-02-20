---
name: harvest-rules
description: Analyzes the current branch's changes to identify new architectural patterns or rules that should be codified.
---

# Harvest Rules Skill

**Goal:** Identify "Implicit knowledge" generated in this branch and make it "Explicit" in `.cursorrules` and conditionally in `.agent/rules/rules.md`.

## Instructions for the Agent

1.  **Get the Diff:**
    *   Examine the files changed in the current branch (or recent commits) to understand the code modifications.

2.  **Read the existing rules:**
    *   Read `.cursorrules` (This is the **single source of truth** for all code standards).
    *   Read `.agent/rules/rules.md` (This is strictly an IF/THEN routing table for the AI).
    *   Read `docs/code_review_prompt.md`.

3.  **Analyze for New Patterns:**
    *   Did we introduce a new way of handling errors or edge cases?
    *   Did we decide on a specific naming convention?
    *   Did we create a new Custom Hook abstraction or Tamagui UI pattern?
    *   Did we ban a specific method?
    *   **Skill Upgrades:** Did we modify any files in `.cursor/skills/`? If so, we need to update the playbook.

4.  **Determine Rule Destinations:**
    *   **Code Standards:** Any new coding practice MUST go into `.cursorrules`.
    *   **Agent Routing:** If a *fundamentally new concept* (e.g., E2E testing, a new framework) is added to `.cursorrules`, you MUST evaluate if `.agent/rules/rules.md` needs a new `IF` trigger to tell the agent *when* to read those rules.
    *   **Review Steps:** If a new manual check is needed, add it to `docs/code_review_prompt.md`.
    *   **Playbook Sync:** If any `.cursor/skills/` file was modified during this work session, you MUST review `docs/AI_WORKFLOW_PLAYBOOK.md` and propose a documentation update to keep the playbook synced with the new skill logic.

5.  **Output Recommendation & Wait for Approval:**
    *   Generate a markdown list of **"New Rules Candidates"**.
    *   For each candidate, explicitly state where it will be inserted.
    *   **🛑 PAUSE AND ASK:** "Should I apply these updates?" Wait for the user's explicit confirmation before modifying any files.

## Example Trigger via Chat
"Harvest rules from this branch." or "Update code docs" (in the context of finishing a feature).
