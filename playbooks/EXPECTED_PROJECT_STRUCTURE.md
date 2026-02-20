# Expected Project Structure (AgentCore Framework)

Skills and playbooks in this framework assume a consistent set of files and folders. **If your project is missing some of these, the agent will warn you and may not be able to run the skill correctly.** Do not rely on the agent to guess or invent the contents of missing files.

This document lists every referenced path, its purpose, and **how to create it**.

---

## Quick setup

1. **Run `sync.sh`** (from AgentCore repo or after copying it into your project root). This creates:
   - `.cursor/skills/` (with universal skills)
   - `docs/ai/` (with playbooks and, if you add it, `AI_WORKFLOW_PLAYBOOK.md`)
2. **Copy stack-specific files** from AgentCore `templates/<your-stack>/` (e.g. `code_review_prompt.md` → `docs/ai/code_review_prompt.md`).
3. **Create the core docs** listed below that are not created by sync or by skills.

---

## Paths and how to create them

### Created by `sync.sh` (or `ai-tools init`)

| Path | Purpose | How to create |
|------|---------|----------------|
| `.cursor/skills/start-feature/SKILL.md` | Start-feature workflow | Run `sync.sh` — downloads from AgentCore |
| `.cursor/skills/finish-branch/SKILL.md` | Finish-branch workflow | Run `sync.sh` |
| `.cursor/skills/status-check/SKILL.md` | Status-check workflow | Run `sync.sh` |
| `.cursor/skills/harvest-rules/SKILL.md` | Harvest-rules workflow | Run `sync.sh` |
| `.cursor/skills/code-review/SKILL.md` | Code-review workflow | Run `sync.sh` |
| `docs/ai/AI_DEVELOPER_PROTOCOL.md` | 6-phase audit playbook | Run `sync.sh` |
| `docs/ai/AI_WORKFLOW_PLAYBOOK.md` | Manual for custom skills | Run `sync.sh` (when available from AgentCore) |
| `docs/ai/EXPECTED_PROJECT_STRUCTURE.md` | This document | Run `sync.sh` (copies this file into your project) |
| `docs/core/ADRs/` | Folder for Architectural Decision Records | Run `sync.sh` — creates folder |
| `docs/core/ADRs/0000-ADR-TEMPLATE.md` | Template for new ADRs (used by start-feature when drafting ADRs) | Run `sync.sh` — downloads from AgentCore |

### Stack-specific (copy from AgentCore templates)

| Path | Purpose | How to create |
|------|---------|----------------|
| `docs/ai/code_review_prompt.md` | Review criteria and output format for code-review skill | Copy from `AgentCore/templates/<stack>/code_review_prompt.md` (e.g. `templates/rails/`, `templates/django/`, or `templates/react-native/`) into `docs/ai/`. Adapt to your project. |

### Core documentation (you create or generate)

| Path | Purpose | How to create |
|------|---------|----------------|
| `docs/core/SPEC.md` | Business logic, domain glossary, semantic meaning of data | Create manually. One source of truth for what the app does and how entities relate. Use Phase 4 of `AI_DEVELOPER_PROTOCOL.md` to add a domain glossary. |
| `docs/core/SCHEMA_REFERENCE.md` | Mapping of DB schema to business logic (tables/columns → SPEC) | **Generated** by the `sync-schema-docs` skill when your schema changes. Do not create by hand; run the skill after creating/editing `docs/core/SPEC.md` and your DB schema. |

### Created by skills at runtime (no need to create beforehand)

| Path | Purpose | How to create |
|------|---------|----------------|
| `docs/implementation_plan.md` | Current feature plan (steps, TDD checklist) | Created by **start-feature** when you approve the plan. |
| `.cursor/pr-draft.md` | Draft PR title and description | Created by **pr-description-clipboard** when you run it. Optional: add to `.gitignore`. |

### Optional / project-specific

| Path | Purpose | How to create |
|------|---------|----------------|
| `.github/PULL_REQUEST_TEMPLATE.md` | PR description template | Create in your repo if you want a standard PR template. **pr-description-clipboard** uses it if present. |
| `.cursorrules` | Project rules and AI routing | Create or adapt per project. Referenced by harvest-rules and general agent behavior. |

### Schema sources (referenced by sync-schema-docs; paths vary by stack)

| Typical path | Purpose |
|--------------|--------|
| `db/schema.rb` (Rails) / `db/schema.ts` / `prisma/schema.prisma` | Raw DB schema. **sync-schema-docs** reads this and `docs/core/SPEC.md` to generate `docs/core/SCHEMA_REFERENCE.md`. |

---

## If something is missing

- **Agent behavior:** Skills that depend on a file will instruct the agent to **check for that file first**. If it is missing, the agent must **not** assume or invent its contents. It must **tell you** which path is missing and point you to this document (or to `docs/ai/EXPECTED_PROJECT_STRUCTURE.md` in your project after sync).
- **Your action:** Use the "How to create" column above to add the missing file or folder, then re-run the skill.
- **Agent may create on request:** If you explicitly ask the agent to **create** or **generate** the missing file, it may do so by following the "How to create" instructions in this document (e.g. creating directories, copying from stack templates, or creating a minimal version as specified). The agent should only create files when you have asked it to; it will not create them automatically just because they are missing.

---

## Summary checklist (minimal for full skill support)

- [ ] `.cursor/skills/` populated (run `sync.sh`)
- [ ] `docs/ai/` exists with playbooks and `code_review_prompt.md` (sync + copy from templates)
- [ ] `docs/core/SPEC.md` exists (business logic and glossary)
- [ ] `docs/core/ADRs/` exists and contains `0000-ADR-TEMPLATE.md` (copy from AgentCore templates)
- [ ] `docs/ai/code_review_prompt.md` present and tailored to your stack (from `templates/<stack>/`)

After that, `docs/implementation_plan.md` and `docs/core/SCHEMA_REFERENCE.md` are created by skills when you use them.
