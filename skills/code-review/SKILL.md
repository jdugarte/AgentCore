---
name: code-review
description: Trigger a strict self-review of current project code changes. Use when the user asks for a code review, to review their branch/PR, or to review code before sharing. The actual review criteria and output format are in docs/ai/code_review_prompt.md — this skill only defines when to run and what to review (scope).
---

# Code Review Skill

## Required files / Pre-flight

Before running this skill, check that this file exists:

- `docs/ai/code_review_prompt.md` (review criteria and output format; required)

**If it is missing:** Do not invent review criteria or output format. Tell the user that the code-review skill requires `docs/ai/code_review_prompt.md` and point them to the Expected Project Structure document (`docs/ai/EXPECTED_PROJECT_STRUCTURE.md` in your project after sync, or `playbooks/EXPECTED_PROJECT_STRUCTURE.md` in AgentCore) for how to create it (copy from `templates/<stack>/code_review_prompt.md`). **If the user explicitly asks you to create it,** you may do so by copying or adapting the appropriate stack template from that document (e.g. `templates/rails/code_review_prompt.md`, `templates/django/code_review_prompt.md`, or `templates/react-native/code_review_prompt.md`) into `docs/ai/code_review_prompt.md`. Do not proceed with the review until the file exists.

## Purpose

This skill **triggers** a code review. It does not define how to review: **all review criteria, categories, output format, and instructions** come from **`docs/ai/code_review_prompt.md`**. When the user asks for a code review, you must read that document in full and follow it for the actual review.

## When to Use

- User asks for a code review, or to review their branch / PR / changes
- User says e.g. "review my code", "review this branch", "code review"

## Scope (what to review)

- **Default:** Changes on the current branch vs `main`. Use `git branch --show-current`; if the user does not name a branch, review the current branch.
- **Named branch:** If the user names a branch (e.g. "review branch feature-xyz"), review that branch vs `main`.
- **Base:** Compare against `main` unless the user specifies another base.
- **Specific files:** If the user names files or paths, restrict the review to those files; still apply the full checklist from `docs/ai/code_review_prompt.md` to them.

## What You Must Do When Invoked

1. **Read** `docs/ai/code_review_prompt.md` in full. Use it as the single source of truth for:
   - Context & stack
   - All project-specific review criteria defined in the prompt (e.g., architecture, type safety, UI standards, etc.)
   - Pre-Review Execution Instructions (e.g., Running terminal commands like `npm run check`) 
   - Output format exactly as requested.
2. **Determine scope** from the section above (current or named branch vs main, optional file focus).
3. **Execute Pre-Flight Checks:** Run the required terminal commands (e.g., project-specific linters and test suites) indicated in `docs/ai/code_review_prompt.md` BEFORE generating text. Feed any failures into the final review payload.
4. **Run the review** by applying every relevant section of the prompt to the in-scope code and the terminal outputs. Do not add or remove categories; follow the prompt’s output rules (omit empty headers, no praise, etc.).
5. **Produce output** exactly as specified in the "Output Format" section of `docs/ai/code_review_prompt.md`, including Risk Level and Pre-Review Checklist.

## References

- **Review criteria, categories, output format:** `docs/ai/code_review_prompt.md` (read in full when performing a review)
- **General project standards:** `.cursorrules`
