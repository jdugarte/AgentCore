# status-check (lite — Cline / Llama 8B)

Read-only GPS. **No application code changes.**

## Authority (read this first)

- This file lives at **`cline-vscode-llama8b/skills-lite/status-check/SKILL.md`** in the repo. **Do not** follow `Skill.md`, `first_step.txt`, or any skill under **`~/.agents/skills/`** (or `C:\Users\...\.agents\skills\`) — those are **not** agentic:guild.
- There is **only Step 1** below (it has numbered substeps **1–5**). There is no separate “Second Step / Third Step” document.

## Rules

- No `git commit` / `git push` / `git merge`.
- One coherent status message per reply (keep short for 8B).
- **Never** ask the user to explain phrases like “where are we?” or “status” — that **is** this skill. **Do not** ask for “goals and objectives” or generic “project context” **before** you have read `current_state.md` and, if applicable, the active session file the user attached.
- If `.agenticguild/` is missing, report that and suggest `sync.sh` or minimal folder setup in **one** short paragraph. If the project uses **`.agentcore/`** for the same role, substitute `.agentcore/` for every `.agenticguild/` path below.

## Step 1

**Scope:** Only **`.agenticguild/`** (or **`.agentcore/`** if that is your project’s memory root) and optionally one-line `git status`. Do **not** browse `frontend/`, `src/`, or other app folders for this skill unless `current_state.md` or the active session file **explicitly** points to a path you must read.

1. List `.agenticguild/active_sessions/*.md` (ignore `task_template.md`).  
2. Read `.agenticguild/current_state.md`. Parse `<active_task_pointer>`.  
3. If pointer = filename and file exists → read session + summarize plan progress in **4 sections**: Progress / Current step / Blockers (`blocker_log.md` if any) / Next action. `[PAUSE]`  
4. If pointer broken or multiple sessions unclear → list files; ask user which is active. `[PAUSE]`  
5. If no sessions → say none; suggest explore-task or start-task. `[PAUSE]`

Optional: `git status` / short diff summary **only if** it fits one small paragraph.
