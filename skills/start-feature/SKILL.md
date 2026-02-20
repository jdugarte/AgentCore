---
name: start-feature
description: Enforces the "Plan -> Test -> Code" workflow for new features.
---

# Start Feature Skill

**Goal:** Prevent "Jumping to Code". Ensure we have a plan and tests first, broken down into manageable TDD loops.

## Workflow

### PHASE 1: Discovery & Specification
1.  **Mandatory Q&A**
    *   **Action:** Before writing any code or plans, ask the user clarifying questions about the feature.
    *   **Instruction:** Probe for edge cases, UI placement, data model changes, and offline sync implications. Do not stop asking until the requirements are crystal clear.

2.  **Hierarchical Implementation Plan**
    *   **Action:** Once discovery is complete, draft `implementation_plan.md`.
    *   **Instruction:** Break the feature down hierarchically into discrete **Steps** (e.g., Step 1: Hook, Step 2: Component, Step 3: Integration).
    *   **Pause:** Present the plan to the user. Wait for their explicit approval before proceeding to Phase 2.

### PHASE 2: The Iterative TDD Loop
*(Execute the following steps for **each** hierarchical Step defined in the plan, one at a time).*

3.  **Draft Tests (TDD)**
    *   **Action:** Write the failing tests (`.test.ts` or `.spec.tsx`) for the *current step only*.
    *   **Pause:** Stop and show the tests to the user. Ask: "Do these tests accurately reflect the spec?" Wait for approval (e.g., "tests are good").

4.  **Implementation**
    *   **Action:** Write the application code required to make the failing tests pass.
    *   *Command:* Run `npm test` and `npm run check`.
    *   **Instruction:** Fix any errors until green. 
    *   **Pause:** Stop and announce the step is complete. Wait for the user to say "Proceed to next step".

5.  **Repeat or Conclude**
    *   **Action:** If there are more steps in the plan, loop back to Action 3 for the next step. If all steps are done, announce the workflow is complete and recommend the `finish-branch` skill for final polish.

## Example Trigger within Chat
"Start a new feature for X", "I want to build Y", or "Run start feature workflow".
