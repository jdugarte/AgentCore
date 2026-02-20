---
name: start-feature
description: Initiates the process of building a new feature. Enforces a strict QA discovery phase, implementation planning, and TDD loop. Use whenever the user asks to "start a feature", "build a new feature", or begins a major task.
---

# Start Feature Skill

## Required files / Pre-flight

Before running this skill, check that these exist in the project:

- `docs/core/SPEC.md` (business logic; required for schema mapping and ADR context)
- `docs/core/ADRs/0000-ADR-TEMPLATE.md` (only if you will draft an ADR; optional for planning)

**If any required file is missing:** Do not assume or invent its contents. Tell the user which path is missing and point them to the Expected Project Structure document (`docs/ai/EXPECTED_PROJECT_STRUCTURE.md` in your project after sync, or `playbooks/EXPECTED_PROJECT_STRUCTURE.md` in AgentCore) for how to create it. **If the user explicitly asks you to create the missing file(s),** you may do so by following the "How to create" instructions in that document (e.g. create `docs/core/SPEC.md` with a minimal structure, or ensure `docs/core/ADRs/0000-ADR-TEMPLATE.md` is present via sync/template). You may still run discovery and draft `docs/implementation_plan.md` if the user confirms; for schema mapping or ADR drafting, pause until the file exists or the user skips that step.

## Purpose
To ensure that all new features in the current project are thoughtfully planned rather than hastily coded. This skill enforces a Q&A discovery phase, followed by drafting an `implementation_plan.md`, and finally looping through a Test-Driven Development (TDD) process.

## Instructions / Workflow

1. **Discovery (Q&A Phase)**
   - Do NOT write any code yet.
   - Ask clarifying questions about the feature's requirements, edge cases, UI/UX, and data model changes (based on the project's `.cursorrules` or equivalent architecture docs).
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
   - **Pre-Flight Checks:** Run the project's static analysis commands (e.g., linters, type checkers, formatters) as defined by the project's `.cursorrules` or toolchain (e.g., `npm run check`, `bundle exec rubocop`). Fix any errors until green.
   - **Pause:** Stop and announce the step is complete. Wait for the user to say "Proceed to next step".

   **C) Repeat or Conclude**
   - If there are more steps in the plan, loop back to Action A for the next step. If all steps are done, announce the workflow is complete and recommend the `finish-branch` skill for final polish.

## Halting
At any point during planning or execution, if the user's requirements change or a test fundamentally exposes a flaw in the plan, PAUSE and re-evaluate `implementation_plan.md` with the user before proceeding.
