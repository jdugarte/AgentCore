---
name: pr-description-clipboard
description: Drafts a PR description from the repo template and branch/diff, then copies it to the clipboard. Use when the user wants to prepare a PR description, draft a PR, copy PR description to clipboard, or redact a PR description.
---

# PR Description → Clipboard

## Required files / Pre-flight

- `.github/PULL_REQUEST_TEMPLATE.md` is **optional**. If missing, draft a reasonable structure from branch/diff; do not assume a specific template.
- `.cursor/pr-draft.md` will be **created** by this skill; ensure `.cursor/` exists (e.g. from running `sync.sh`).

**If `.cursor/` does not exist:** Tell the user to run `sync.sh` or create `.cursor/` so the draft can be written. **If the user explicitly asks you to create it,** you may create the `.cursor/` directory (e.g. `mkdir -p .cursor`) so the draft can be written to `.cursor/pr-draft.md`. You may still output the draft in chat for them to copy manually.

## Purpose

Draft a pull request description using the project template (`.github/PULL_REQUEST_TEMPLATE.md`), fill in what can be inferred (branch name, base, summary of changes), then copy the result to the clipboard so the user can paste it into GitHub/GitLab.

## When to Use

- User asks to "redact a PR description", "draft a PR description", "prepare PR description and copy to clipboard", or similar.
- User wants a PR description in the clipboard for the current branch.

## Instructions

1. **Gather context**
   - Current branch: `git branch --show-current`
   - Base branch: `main` (unless the user specifies another).
   - Changed files vs base: `git diff main --name-only` (or `git diff origin/main --name-only` if that’s the remote).

2. **Read the template**
   - Open `.github/PULL_REQUEST_TEMPLATE.md` and use it as the output structure.

3. **Fill the template**
   - **PR title:** Short title derived from branch name or changes (e.g. from `feature/phase-3-price` → "PR: Phase 3 – Price intelligence").
   - **Branch:** Value from step 1.
   - **Base:** `main`.
   - **Summary:** 1–2 sentences describing what this PR does and why, inferred from changed files and recent work.
   - **What’s in this PR:** Bullet list of main changes, new files, and config updates (from the file list and repo knowledge).
   - **ADR Check:** Check `git diff main --name-only` to see if a new `docs/core/ADRs/*.md` file was added in this branch. If so, append to the description: *"**Architectural Decision:** This PR includes a new ADR. Please review `docs/core/ADRs/00XX-title.md` for context."*
   - **How to test:** Keep the template steps; add 1–2 steps specific to this PR if obvious.
   - **Checklist:** Leave the checkboxes as in the template (unchecked).
   - **Follow-ups / PENDING:** Leave placeholder or "None" unless something is known.

4. **Write draft to a file**
   - Write the PR title at the very top of `.cursor/pr-draft.md` (e.g. `Title: <PR Title>`), followed by a blank empty line, and then the rest of the filled markdown description below it. This ensures the user has both the title and the description ready to use.
5. **Copy to clipboard**
   - Run the appropriate command for the OS so the contents of `.cursor/pr-draft.md` are in the clipboard:
     - **macOS:** `pbcopy < .cursor/pr-draft.md`
     - **Windows (PowerShell):** `Get-Content .cursor/pr-draft.md -Raw | Set-Clipboard`
     - **Linux (if xclip installed):** `xclip -selection clipboard < .cursor/pr-draft.md`
   - If the command fails (e.g. `xclip` not installed), tell the user the draft is in `.cursor/pr-draft.md` and they can copy it manually.

6. **Confirm**
   - Tell the user the PR description was drafted and copied to the clipboard, and that the draft is also in `.cursor/pr-draft.md` if they want to edit before pasting.

## Notes

- Prefer inferring from branch name and changed files; avoid making up details. If something is unclear, leave a short `<!-- TODO: ... -->` in the draft.
- The template uses `main` as base; if the project uses another default branch, use that instead.
- `.cursor/pr-draft.md` can be added to `.gitignore` if the project prefers not to commit draft files.
