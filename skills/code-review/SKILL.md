---
name: code-review
description: Conduct strict self-reviews of pull requests using the Kova code review checklist. Use when the user asks for a code review, mentions reviewing their branch, or wants to review code changes before sharing with the team.
---

# Code Review Skill

## Purpose

Run strict self-reviews of Kova code changes. **Do not duplicate checklist or output format here** — `docs/code_review_prompt.md` is the single source of truth for criteria, categories, and format. This skill defines when to run and how to scope the review.

## When to Use

- User asks for a code review, or to review their branch/PR/changes
- User says "review my code" or "review this branch"

## Scope (what to review)

- **Default:** Current git branch (`git branch --show-current`) vs `main`. Commands like "code review" or "review my code" use this without the user naming a branch.
- **Other branch:** If the user names a branch (e.g. "review branch feature-xyz"), compare that branch to `main`.
- **Base:** Always compare against `main` unless the user says otherwise.
- **Specific files:** If the user names files, focus the review on those files (still use the full checklist for them).

## Instructions

1. **Read** `docs/code_review_prompt.md` in full and use it as the checklist. Do not re-list its sections or criteria in your reply; apply them.
2. **Determine scope** from the section above (current branch vs main, or user-specified branch/files).
3. **Review the diff** (or the specified files) against every section of the prompt in order.
4. **Output** exactly as defined in the "Output Format" section of `docs/code_review_prompt.md` (categories, "Only list actionable items", Risk Level, Pre-Review Checklist). Do not invent new categories or skip any.

## Reference

- **Checklist, criteria, output format:** `docs/code_review_prompt.md`
- **General dev standards (kill list, quality tools):** `.cursorrules`

## Testing

- **Test setup:** Jest + jest-expo + React Native Testing Library; mocks in `__mocks__/expo-sqlite.js` and `__mocks__/expo-router.js`; tests in `**/__tests__/**/*.(test|spec).(ts|tsx)`. Scripts: `npm test`, `npm run test:coverage`.
- **In reviews:** When the PR adds or changes logic that could be tested, or adds/edits test files, ensure **`npm test`** is run and passes. Apply the "Quality gate" item in `docs/code_review_prompt.md` (run check + test when relevant).
