---
name: start-feature
description: Initiates the process of building a new feature. Enforces a strict QA discovery phase, implementation planning, and TDD loop. Use whenever the user asks to "start a feature", "build a new feature", or begins a major task.
---

# Start Feature Skill

## Required files / Pre-flight

Before running this skill, check that these exist in the project:

- `docs/core/SPEC.md` (business logic; required for REQ-ID mapping and ADR context)
- `docs/core/ADRs/0000-ADR-TEMPLATE.md` (only if you will draft an ADR; optional for planning)

**If any required file is missing:** Do not assume or invent its contents. Tell the user which path is missing and point them to the Expected Project Structure document (`docs/ai/EXPECTED_PROJECT_STRUCTURE.md`).

## Purpose
To ensure that all new features are thoughtfully planned with Aerospace-grade traceability and Cloud-native resiliency. This skill enforces a Q&A discovery phase, failure mode analysis, and a strict TDD loop.

## Instructions / Workflow

1. **Discovery & Resiliency (Q&A Phase)**
   - Do NOT write any code yet.
   - **Traceability:** Ask the user which `[REQ-ID]` from `SPEC.md` this feature fulfills. If none exist, suggest creating one.
   - **Chaos Engineering:** Ask clarifying questions about requirements and **Failure Modes**. (e.g., "What happens if this API times out?" or "How does the UI degrade offline?").
   - **Output:** Generate `docs/features/<feature_name>/failure_matrix.md` detailing these scenarios.
   - Wait for the user to answer.

2. **Planning & Contracts**
   - Draft a hierarchical `docs/implementation_plan.md`.
   - **REQ-ID Binding:** List the `[REQ-ID]` at the top of the plan.
   - **Boundary Contracts:** For every new service or critical function, explicitly define **Preconditions** (input state) and **Postconditions** (output state).
   - **Schema Mapping:** Map DB changes to business logic in `SPEC.md`.
   - **Architectural Shift Check:** If YES, draft an ADR using the template.
   - Present the plan to the user and wait for explicit approval.

3. **Execution (The Iterative TDD Loop)**
   *(Execute for each step in the plan)*

   **A) Draft Tests (TDD)**
   - Write failing tests. **Mandatory:** Tag every `it`/`test` block with the `[REQ-ID]`.
   - **Pause:** Show tests to the user. Ask: "Do these tests accurately reflect the spec?"

   **B) Implementation**
   - Write minimum code to pass.
   - **Pre-Flight:** Run linters/type checkers until green.
   - **Pause:** Announce completion. Wait for "Proceed".

   **C) Repeat or Conclude**
   - Loop or recommend `finish-branch`.

## Halting
At any point, if requirements change or tests expose flaws, PAUSE and re-evaluate with the user.
