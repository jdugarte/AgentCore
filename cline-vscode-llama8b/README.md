# Cline (VS Code) + Llama 3.1 8B — agentic:guild pack

Compressed rules and skills for **Cline** with small local models. Full XML skills in `skills/` remain the source of truth; this pack is easier for 8B context and reasoning limits.

## Install in a project

1. Copy the whole `cline-vscode-llama8b` folder to your **repository root** (keep the name `cline-vscode-llama8b` or update paths below).
2. Copy **the entire** `cline-vscode-llama8b/.clinerules/` folder into your **project root** as `.clinerules/` (merge with existing rules). You must include **`000-CRITICAL-FREEZE-PHRASES.md`** — it sorts first and stops Cline **Plan mode** from turning “where are we?” into a project-structure survey.
3. In **`.clinerules/agentic-guild.md`**, if you renamed the pack folder, set `SKILL_PACK_ROOT` to match (default: `cline-vscode-llama8b/skills-lite`).

Cline loads rules from `.clinerules` automatically when enabled for the workspace.

**Conflicts:**

- **Cline Plan mode** often builds a todo (“Identify goals”, “Review structure”) and ignores long rules. For agentic:guild, use **Act / normal mode** for status questions, or turn off plan-first behavior if your Cline version allows it — **`000-CRITICAL-FREEZE-PHRASES.md`** is written to override that when loaded.
- **`.clinerules/workflows/*.md`** — remove or narrow templates that always start a “new task” plan.
- **`@folder` in the prompt** — don’t attach unrelated paths when asking “where are we?”; the model may prioritize them over rules.

The **CRITICAL** table in **`agentic-guild.md`** plus **`000-CRITICAL-FREEZE-PHRASES.md`** take precedence when the user’s message matches a freeze row.

### If Cline still asks for “goals” or reads `~/.agents/skills/`

Cline may **register a different `status-check`** under your user directory (e.g. `C:\Users\…\.agents\skills\status-check\` with `first_step.txt`). That is **not** agentic:guild. Fixes:

1. Re-copy **`000-CRITICAL-FREEZE-PHRASES.md`** — it now forbids using those global skill paths.
2. Open the skill with **read_file** on **`cline-vscode-llama8b/skills-lite/status-check/SKILL.md`** in the repo, not Cline’s “load skill” UI if it resolves outside the project.
3. Disable or remove the conflicting global skill pack if your Cline version allows it.

### `.agenticguild` vs `.agentcore`

Canonical agentic:guild memory is **`.agenticguild/`**. If sessions live under **`.agentcore/`**, either rename to `.agenticguild/` and update pointers, or rely on the **status-check** / **000-CRITICAL** wording that allows `.agentcore/` as a substitute — but **use one root only**, or `current_state.md` and sessions will disagree.

## Paths

- **Lite skills (use with Cline + 8B):** `cline-vscode-llama8b/skills-lite/<skill>/SKILL.md`
- **Canonical skills (full state machines):** `skills/<skill>/SKILL.md` in agentic-guild, or `docs/ai/skills/` after `sync.sh` in a consumer project
- **Project rules file:** still `.cursorrules` for Cursor only; Cline uses `.clinerules` here

## Llama 8B usage tips

- Run **one skill step per reply**; do not batch whole workflows.
- Read **one** `SKILL.md` at a time from `skills-lite/`.
- Keep chat outputs **short**; put plans in `.agenticguild/active_sessions/` files on disk.
