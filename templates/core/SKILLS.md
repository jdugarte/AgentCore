# agentic:guild Skills Index

> **For AI Agents:** This file is your discovery index for all available skills in this project.
> Skills are located at `docs/ai/skills/<skill-name>/SKILL.md`.
> Before starting any task, search this index for relevant skills and read them using `view_file`.

## Skills Directory

All skill files live under `docs/ai/skills/`. Each skill is a folder containing a `SKILL.md` file.

| Skill | Path | Trigger phrases |
|:------|:-----|:----------------|
| `hello` | `docs/ai/skills/hello/SKILL.md` | "who are you", "what is agentic:guild", "how do I start" |
| `explore-task` | `docs/ai/skills/explore-task/SKILL.md` | "explore task", "brainstorm", "figure out requirements" |
| `start-task` | `docs/ai/skills/start-task/SKILL.md` | "start task", "begin task", "implement feature" |
| `finish-branch` | `docs/ai/skills/finish-branch/SKILL.md` | "finish branch", "open a PR", "complete task" |
| `status-check` | `docs/ai/skills/status-check/SKILL.md` | "status check", "where are we", "blocked" |
| `code-review` | `docs/ai/skills/code-review/SKILL.md` | "code review", "review my changes" |
| `process-feedback` | `docs/ai/skills/process-feedback/SKILL.md` | "process feedback", "fix errors", "lint errors" |
| `harvest-rules` | `docs/ai/skills/harvest-rules/SKILL.md` | "harvest rules", "update docs" |
| `audit-compliance` | `docs/ai/skills/audit-compliance/SKILL.md` | "audit compliance", "run audit" |
| `sync-docs` | `docs/ai/skills/sync-docs/SKILL.md` | "sync docs", "sync project docs" |
| `pr-description` | `docs/ai/skills/pr-description/SKILL.md` | "PR description", "draft PR" |
| `roadmap-manage` | `docs/ai/skills/roadmap-manage/SKILL.md` | "roadmap", "manage roadmap", "add to roadmap" |
| `roadmap-consult` | `docs/ai/skills/roadmap-consult/SKILL.md` | "roadmap status", "what's pending", "roadmap consult" |
| `update-agentic-guild` | `docs/ai/skills/update-agentic-guild/SKILL.md` | "update agentic:guild", "sync agentic guild" |

## Routing Protocol

If you are an AI agent and the user's intent matches any skill above:
1. Use `view_file` to read the corresponding `SKILL.md`
2. Follow its state machine exactly — do not improvise
3. Never execute more than one `<step>` per response
4. Always pause and await user confirmation between steps

## Note on IDE Compatibility

This project uses `docs/ai/skills/` as the canonical skill location. This path is recognized by:
- **Cursor** (via `.cursorrules` intent routing)
- **Any agentic IDE** that can read this file and use `view_file` to load `SKILL.md` files

If your IDE uses a different skill convention, read the SKILL.md files directly — the path above is always valid.
