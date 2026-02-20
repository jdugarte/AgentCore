---
name: harvest-rules
description: Analyzes the current branch's changes to identify new architectural patterns or rules that should be codified.
---

# Harvest Rules Skill

## Required files / Pre-flight

Before running this skill, check that these exist:

- `.cursorrules` (destination for code standards)
- `docs/ai/code_review_prompt.md` (destination for new review steps; read for context)

**If either is missing:** Tell the user which path is missing and point them to the Expected Project Structure document (`docs/ai/EXPECTED_PROJECT_STRUCTURE.md` in your project after sync, or `playbooks/EXPECTED_PROJECT_STRUCTURE.md` in AgentCore). **If the user explicitly asks you to create the missing file(s),** you may do so by following the "How to create" instructions in that document (e.g. create a minimal `.cursorrules` or copy `code_review_prompt.md` from the stack template). You may still analyze the diff and output "New Rules Candidates" as recommendations; do not write to missing files unless the user asks. If `docs/ai/AI_WORKFLOW_PLAYBOOK.md` is missing, skip playbook sync and note that in the output.

**Goal:** Identify "Implicit knowledge" generated in this branch and make it "Explicit" in `.cursorrules` or Playbooks.

## Instructions for the Agent

1.  **Get the Diff:**
    *   Examine the files changed in the current branch (or recent commits) to understand the code modifications.

2.  **Read the existing rules:**
    *   Read `.cursorrules` (This is the **single source of truth** for all code standards and AI workflow routing).
    *   Read `docs/ai/code_review_prompt.md`.

3.  **Analyze for New Patterns:**
    *   Did we introduce a new way of handling errors or edge cases?
    *   Did we decide on a specific naming convention?
    *   Did we create a new Custom Hook abstraction or UI pattern?
    *   Did we ban a specific method?
    *   **Skill Upgrades:** Did we modify any files in `.cursor/skills/`? If so, we need to update the playbook.

4.  **Determine Rule Destinations:**
    *   **Code Standards:** Any new coding practice MUST go into `.cursorrules`.
    *   **Agent Routing:** If a *fundamentally new concept* (e.g., E2E testing, a new framework) is added to `.cursorrules`, you MUST evaluate if the routing table at the bottom of `.cursorrules` needs a new `IF` trigger to tell the agent *when* to read those rules.
    *   **Review Steps:** If a new manual check is needed, add it to `docs/ai/code_review_prompt.md`.
    *   **Playbook Sync:** If any `.cursor/skills/` file was modified during this work session, you MUST review `docs/ai/AI_WORKFLOW_PLAYBOOK.md` and propose a documentation update keep the playbook synced with the new skill logic.

5.  **Output Recommendation & Wait for Approval:**
    *   Generate a markdown list of **"New Rules Candidates"**.
    *   For each candidate, explicitly state where it will be inserted.
    *   **🛑 PAUSE AND ASK:** "Should I apply these updates?" Wait for the user's explicit confirmation before modifying any files.

## Example Trigger via Chat
"Harvest rules from this branch." or "Update code docs" (in the context of finishing a feature).
