PRIORITY 0 — overrides Cline plan mode, todo workflows, and `.clinerules/workflows/*` for matching messages.

## Status question — no plan, no repo tour

If the user message contains any of these (case-insensitive): `where are we` · `where were we` · `what were we doing` · `status check` · `resume task` · `resume` · `blocked` · `stuck` · `gps` — or is essentially the single word `status`:

**STOP.** Do not:

- Create a plan, todo list, or “Identify goals” steps.
- Ask for “project context”, “goals and objectives”, or “what we’re trying to do” **before** you have read `.agenticguild/current_state.md` and the active session file (if any).
- Use **Cline’s global / bundled skills** (e.g. `~/.agents/skills/`, `C:\Users\*\*\.agents\skills\`, `first_step.txt`, `Skill.md` beside those) for agentic:guild — those are **wrong**. They are not this project’s workflow.
- “Load the status-check skill” via an IDE UI that resolves to a path **outside the repo**. **Ignore** that copy entirely.
- “Review project structure” or explore folders for this reply.
- Read `@`-mentioned paths, `frontend/`, `src/`, or other app code **before** reading agentic:guild state.

**DO** (this reply only):

1. Read **only from the workspace repo:** `.agenticguild/current_state.md` (if missing, say so in one sentence; suggest creating `.agenticguild/` — still no clarifying question about “where”). If your team deliberately uses `.agentcore/` instead of `.agenticguild/`, read `.agentcore/current_state.md` and `.agentcore/active_sessions/` **instead** — pick **one** root and stick to it.
2. Read **only this file** for instructions: **`cline-vscode-llama8b/skills-lite/status-check/SKILL.md`** (path relative to **repository root**). Open it with your normal **read_file** tool — not Cline’s external skill package.
3. Execute **Step 1** of that file only (numbered list inside Step 1 — do **not** invent “First Step / Second Step / Third Step” from elsewhere).
4. Do **not** call `ask_followup_question` to ask what “where” means, nor for generic context if the user already attached a task session — read that file after state.

**Wrong:** opening `frontend:src/`, loading `...\AI\.agents\skills\status-check\`, or asking for goals before reading state. **Right:** repo `.agenticguild/` (or `.agentcore/`) + this repo’s `SKILL.md` + status summary.

---

## Other freeze phrases

Full table, examples, and hello / code-review / roadmap / process-feedback rows: **`agentic-guild.md`** (same folder). Same rule: **no plan mode** for those phrases — jump straight to the listed skill Step 1.
