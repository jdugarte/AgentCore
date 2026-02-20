---
name: start-feature
description: Initiates the process of building a new feature. Enforces a strict QA discovery phase, implementation planning, and TDD loop. Use whenever the user asks to "start a feature", "build a new feature", or begins a major task.
---

# Start Feature Skill

## Purpose
To ensure that all new features in MedVentory are thoughtfully planned rather than hastily coded. This skill enforces a Q&A discovery phase, followed by drafting an `implementation_plan.md`, and finally looping through a Test-Driven Development (TDD) process.

## Instructions / Workflow

1. **Discovery (Q&A Phase)**
   - Do NOT write any code yet.
   - Ask clarifying questions about the feature's requirements, edge cases, UI/UX (based on Tamagui/iOS concepts in `.cursorrules`), and data model changes (Drizzle SQLite).
   - Wait for the user to answer.

2. **Planning**
   - Once requirements are clear, draft a hierarchical `docs/implementation_plan.md`.
   - The plan must break the feature down into discrete, testable steps.
   - **Schema Mapping:** If the feature requires adding or modifying database tables, explicitly state how those new columns map to the business logic outlined in `docs/core/SPEC.md`.
   - **Architectural Shift Check:** Assess the implementation plan. Are we introducing a new library, changing an architectural pattern, or making a major decision that future developers might question? If YES, automatically draft an ADR using `docs/core/ADRs/0000-ADR-TEMPLATE.md` and present it to the user.
   - Present the plan (and the ADR, if applicable) to the user and wait for explicit approval.

3. **Execution (The Iterative TDD Loop)**
   *(Execute the following steps for **each** hierarchical Step defined in the plan, one at a time).*

   **A) Draft Tests (TDD)**
   - Write the failing tests (`.test.ts` or `.spec.tsx`) for the *current step only*.
   - **Pause:** Stop and show the tests to the user. Ask: "Do these tests accurately reflect the spec?" Wait for approval.
   
   **B) Implementation**
   - Write the minimum application code required to make the failing tests pass.
   - Run the tests again to prove they pass.
   - Run `npm run lint` and `npm run typecheck` (or `npm run check`) to ensure strict TypeScript/linting rules from `.cursorrules` are met. Fix any errors until green.
   - **Pause:** Stop and announce the step is complete. Wait for the user to say "Proceed to next step".

   **C) Repeat or Conclude**
   - If there are more steps in the plan, loop back to Action A for the next step. If all steps are done, announce the workflow is complete and recommend the `finish-branch` skill for final polish.

## Halting
At any point during planning or execution, if the user's requirements change or a test fundamentally exposes a flaw in the plan, PAUSE and re-evaluate `implementation_plan.md` with the user before proceeding.
