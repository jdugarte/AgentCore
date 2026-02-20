---
name: code-review
description: Trigger a strict self-review of current project code changes. Use when the user asks for a code review, to review their branch/PR, or to review code before sharing. The actual review criteria and output format are in docs/ai/code_review_prompt.md — this skill only defines when to run and what to review (scope).
---

# Code Review Skill

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
