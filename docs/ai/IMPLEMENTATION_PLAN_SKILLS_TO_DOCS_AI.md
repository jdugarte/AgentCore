# Implementation Plan: Skills in `docs/ai/skills/` and Cross-IDE Rules

This plan covers (1) moving canonical skills from `.cursor/skills/` to `docs/ai/skills/`, and (2) using **thin adapters per IDE** that point to a single canonical rules file (`docs/ai/AGENTIC_GUILD_RULES.md`) so all code-generating agents get the same behavior.

---

## Part A: Role of `.cursorrules` and Injecting Rules Into All Agents

### Is `.cursorrules` only useful for Cursor?

**Yes.** `.cursorrules` is a **Cursor-specific** file. Only Cursor reads it (and Cursor is moving toward `.cursor/rules/*.mdc`). Other IDEs do not load `.cursorrules`; they use their own files:

| IDE           | Rules / instructions file(s)        |
|---------------|-------------------------------------|
| Cursor        | `.cursorrules` or `.cursor/rules/*.mdc` |
| Windsurf      | `.windsurf/rules/*.md`, `AGENTS.md`     |
| Cline         | `.clinerules/`                          |
| GitHub Copilot| `.github/copilot-instructions.md`, `AGENTS.md` |
| Claude Code   | `CLAUDE.md`                             |
| Antigravity   | System prompt; can use `AGENTS.md` if present |

So in this scheme, **`.cursorrules` is the Cursor adapter**: it holds the full agentic:guild OS rules for Cursor only.

### How do we inject the same rules into all agents?

Every code-generating agent needs the **same** rules (state machine, skills discovery, intent routing, memory, anchors). Two approaches:

---

#### Option 1: Full rules in each adapter (duplicated content)

- At sync/update time, write the **full content** of `AGENTIC_GUILD_RULES.md` into each IDE’s file (`.cursorrules`, AGENTS.md, CLAUDE.md, etc.).
- **Pro:** Whichever file the IDE loads, the agent immediately has the complete rules in context; no extra read step.
- **Con:** Same content in many files; updates require re-syncing every adapter.

---

#### Option 2: Thin adapters — one canonical rules file, pointers per IDE (recommended)

- **Canonical rules:** One file in the repo that every IDE can access, e.g. **`docs/ai/AGENTIC_GUILD_RULES.md`**. This file contains the full agentic:guild OS (state machine, skills discovery, intent routing, memory, anchors). It is synced from `templates/core/AGENTIC_GUILD_RULES.md` and lives in the repo so it’s versioned and discoverable.
- **Thin adapters:** Each IDE’s native file (`.cursorrules`, AGENTS.md, CLAUDE.md, `.windsurf/rules/agentic-guild.md`, `.clinerules/agentic-guild.md`, etc.) contains only a **short directive** that tells the agent to read and follow that canonical file before responding.

Example thin adapter content (same idea for every IDE, wording can be tuned per format):

```markdown
<!-- agentic:guild [START] -->
This project uses agentic:guild. You MUST read and follow the instructions in **docs/ai/AGENTIC_GUILD_RULES.md** before answering or generating code. All skills live at docs/ai/skills/<skill-name>/SKILL.md; the full rules file contains intent routing, state machine, and memory usage.
<!-- agentic:guild [END] -->
```

- **Pro:** Single source of truth; one file to update; no duplication; adapters stay tiny and easy to maintain.
- **Con:** The agent must (1) read the adapter file (which the IDE loads) and (2) follow the instruction to read `docs/ai/AGENTIC_GUILD_RULES.md`. If the IDE never loads the adapter, or the agent ignores the “read this file” step, the rules won’t apply. In practice, agents are good at following “read X and follow it” when that instruction is in their context.

**Recommendation:** Use **thin adapters** (Option 2). Put the full rules in **`docs/ai/AGENTIC_GUILD_RULES.md`** and add thin adapter files per IDE that reference it. Then:
- **`.cursorrules`** (and `.cursor/rules/agentic-guild.mdc`) = thin Cursor adapter pointing at `docs/ai/AGENTIC_GUILD_RULES.md`.
- **AGENTS.md**, **CLAUDE.md**, **.windsurf/rules/agentic-guild.md**, **.clinerules/agentic-guild.md** = same thin pointer, so every IDE delivers the same “read and follow the canonical rules” instruction.

---

## Part B: Implementation Plan (Skills → `docs/ai/skills/`)

### Goals

- Canonical skills location: **`docs/ai/skills/<skill-name>/SKILL.md`** (in repo, discoverable, versioned).
- All references to skill paths use **`docs/ai/skills/`** (no `.cursor/skills/` in templates or registry).
- **Canonical rules:** Full agentic:guild OS lives in **`docs/ai/AGENTIC_GUILD_RULES.md`** (synced from template, in repo). Paths in that file use `docs/ai/skills/`.
- **Thin adapters per IDE:** `.cursorrules`, AGENTS.md, CLAUDE.md, etc. contain only a short directive to “read and follow docs/ai/AGENTIC_GUILD_RULES.md” (and optionally skills path). No duplication of the full rules.
- Runtime-only data stays in `.agenticguild/` (sessions, state, config).

### Phase 1: Move skills to `docs/ai/skills/` and update paths

**1.1 SYNC_REGISTRY**

- Change every skill row from:
  - `skills/.../SKILL.md` → `.cursor/skills/.../SKILL.md`
- To:
  - `skills/.../SKILL.md` → `docs/ai/skills/.../SKILL.md`
- No new rows required if the rest of the registry stays as-is.

**1.2 Template: `templates/core/AGENTIC_GUILD_RULES.md`**

- In `<skills_discovery>`: replace `.cursor/skills/` with `docs/ai/skills/`.
- In `<onboarding>`: replace `.cursor/skills/hello/SKILL.md` with `docs/ai/skills/hello/SKILL.md`.
- In `<intent_routing>`: replace every `Read \`.cursor/skills/...\`` with `Read \`docs/ai/skills/...\``.
- Keep the “do not search workflows” rule as-is.

**1.3 Template: `templates/core/SKILLS.md`**

- Replace all `.cursor/skills/` with `docs/ai/skills/`.
- Update the “IDE Compatibility” note to say the canonical location is `docs/ai/skills/` and that Cursor gets intent routing via `.cursorrules` (or project rules file).

**1.4 `sync.sh`**

- Ensure `docs/ai` and `docs/ai/skills` exist before registry sync:
  - Call `ensure_dir docs/ai` and `ensure_dir docs/ai/skills` (e.g. where you currently ensure `docs/ai`, `docs/core`, etc., and only when not in stealth if you today skip creating docs in stealth).
- Stop creating `.cursor/skills` if nothing is deployed there anymore (optional: keep `ensure_dir .cursor/skills` only if you still have other `.cursor/` content that needs the parent; otherwise remove to avoid empty dir).

**1.5 Skills that reference paths**

- **`skills/update-agentic-guild/SKILL.md`**  
  - Update the check and merge logic: replace “.cursor/skills/” with “docs/ai/skills/”.  
  - Keep handling of `.cursorrules` (and in Phase 2, other adapter files) as today.

- **`skills/harvest-rules/SKILL.md`**  
  - It writes to `.cursorrules` and `docs/core/SYSTEM_ARCHITECTURE.md`. No change to skill **paths**; keep writing to `.cursorrules` for Cursor. (Phase 2 may add “also update AGENTS.md / CLAUDE.md” if those hold full rules.)

- **`skills/sync-docs/SKILL.md`**  
  - It references `.cursorrules` for project config and conventions. No path change for skills; optional: add a note that project rules may also live in `docs/ai/AGENTIC_GUILD_RULES.md` for non-Cursor IDEs.

- **Any other skill** that hardcodes `.cursor/skills/` or `.cursorrules`  
  - Grep the repo for `.cursor/skills` and `.cursorrules` and replace skill paths with `docs/ai/skills/`; keep `.cursorrules` where it means “Cursor’s rules file”.

**1.6 Playbooks / docs**

- **`playbooks/EXPECTED_PROJECT_STRUCTURE.md`**: Update any table or text that says skills live under `.cursor/skills/` to `docs/ai/skills/`.
- **`playbooks/AI_WORKFLOW_PLAYBOOK.md`**: Same if it mentions skill paths.
- **`README.md`**: Update “inject into .cursorrules” and any mention of `.cursor/skills/` to `docs/ai/skills/` for skills; clarify that .cursorrules is for Cursor and that full rules are injected there (and in Phase 2, into other IDE files).

**1.7 Canonical rules file in repo (required for thin adapters)**

- Add to SYNC_REGISTRY:
  - `templates/core/AGENTIC_GUILD_RULES.md` → `docs/ai/AGENTIC_GUILD_RULES.md` (merge).
- This file is the **single source of truth** for the full agentic:guild OS. All thin adapters point the agent to this file. Ensure paths inside it use `docs/ai/skills/`.

---

### Phase 2: Thin adapters per IDE (point to `docs/ai/AGENTIC_GUILD_RULES.md`)

**2.1 Canonical rules file**

- Phase 1 already adds `templates/core/AGENTIC_GUILD_RULES.md` → `docs/ai/AGENTIC_GUILD_RULES.md` to the registry. The full rules live only there.

**2.2 Thin adapter content (single template)**

- Create a small template, e.g. `templates/core/AGENTIC_GUILD_ADAPTER.md`, containing only the pointer text (see Part A, Option 2). sync.sh and update-agentic-guild inject this block into each adapter file.

**2.3 Adapter list**

- Adapter paths are in **`playbooks/ADAPTER_REGISTRY.md`**. For each path, sync.sh creates or prepends only the **thin** block from `templates/core/AGENTIC_GUILD_ADAPTER.md`. No full rules in adapter files.

**2.4 Stealth mode: no adapter files**

- When `--stealth` is set, do **not** create or modify any adapter files. Skip the adapter loop. Write rules to `.agenticguild/AGENTIC_GUILD_RULES.md` and one-line pointer to `.agenticguild/PASTE_INTO_IDE.txt`. Skip registry row for `docs/ai/AGENTIC_GUILD_RULES.md`.

**2.5 sync.sh (normal mode)**

- Fetch thin adapter template and ADAPTER_REGISTRY. For each adapter path: if file does not exist, create with thin content; if exists and lacks `agentic:guild [START]`, prepend thin block. Idempotent; OS-portable.

**2.6 update-agentic-guild skill**

- The skill updates the **canonical** file `docs/ai/AGENTIC_GUILD_RULES.md` from upstream (in stealth, `.agenticguild/AGENTIC_GUILD_RULES.md`). Adapter files are only updated if the thin-block template changes; in stealth the skill does not create or modify adapter files.

**2.7 harvest-rules / sync-docs**

- Keep writing harvested rules to `.cursorrules` for Cursor. Optionally add in the thin adapter for other IDEs: "For project conventions, also read docs/core/SYSTEM_ARCHITECTURE.md (and .cursorrules if present)."
---

### Checklist summary

| Item | Phase | Action |
|------|--------|--------|
| SYNC_REGISTRY: skill destinations | 1 | `.cursor/skills/*` → `docs/ai/skills/*` |
| AGENTIC_GUILD_RULES.md template | 1 | All `.cursor/skills/` → `docs/ai/skills/` |
| SKILLS.md template | 1 | All `.cursor/skills/` → `docs/ai/skills/` |
| sync.sh: ensure_dir | 1 | `docs/ai`, `docs/ai/skills`; drop or keep `.cursor/skills` as needed |
| update-agentic-guild skill | 1 | Paths to `docs/ai/skills/`, .cursorrules handling unchanged |
| harvest-rules, sync-docs | 1 | Paths/docs only; still write to .cursorrules |
| EXPECTED_PROJECT_STRUCTURE, PLAYBOOK, README | 1 | Mention `docs/ai/skills/` and role of .cursorrules |
| AGENTIC_GUILD_RULES → docs/ai/ | 1 | Registry merge row (canonical rules file) |
| templates/core/AGENTIC_GUILD_ADAPTER.md | 2 | Thin pointer template for all adapters |
| sync.sh: .cursorrules | 2 | Inject thin block instead of full rules |
| sync.sh: AGENTS.md, CLAUDE.md, etc. | 2 | Create/inject thin block per ADAPTER_REGISTRY (normal mode only) |
| Stealth mode | 2 | No adapter files; rules + PASTE_INTO_IDE.txt under .agenticguild/ only |
| update-agentic-guild: canonical file + adapters | 2 | Update docs/ai/AGENTIC_GUILD_RULES.md; adapters only if template changes |
| harvest-rules / sync-docs | 2 | Still write to .cursorrules; thin adapter can mention PROJECT_RULES or SYSTEM_ARCHITECTURE |

---

### Verification

- After Phase 1:
  - Run `sync.sh` in a test repo; confirm skills appear under `docs/ai/skills/` and not under `.cursor/skills/`.
  - Open `AGENTIC_GUILD_RULES` (in .cursorrules or template); confirm every skill path is `docs/ai/skills/...`.
  - Trigger a skill (e.g. “who are you?”) and confirm the agent reads `docs/ai/skills/hello/SKILL.md`.
- After Phase 2:
  - Confirm adapter files contain the **thin** block (pointer to `docs/ai/AGENTIC_GUILD_RULES.md` and skills path), not the full rules.
  - In stealth: confirm no adapter files were created; `.agenticguild/AGENTIC_GUILD_RULES.md` and `.agenticguild/PASTE_INTO_IDE.txt` exist.
  - In a non-Cursor IDE that reads AGENTS.md or CLAUDE.md, confirm the agent follows the same intent routing and skills paths.

### Rollback

- Revert SYNC_REGISTRY to `.cursor/skills/` destinations, revert template path changes, and re-run sync to repopulate `.cursor/skills/`. Any repo that already committed `docs/ai/skills/` can keep it and optionally remove `.cursor/skills/` or leave both during transition.

---

## Summary

- **Skills** live in **`docs/ai/skills/`**; SYNC_REGISTRY and all templates/rules point there.
- **Canonical rules** live in `docs/ai/AGENTIC_GUILD_RULES.md` (stealth: `.agenticguild/AGENTIC_GUILD_RULES.md`). Adapters get only a thin block. **Stealth:** no adapter files; user pastes line from `PASTE_INTO_IDE.txt` once.
- To **inject the same rules into all code-generating agents**, each adapter file gets only a thin block pointing at the canonical file (see above).

Phase 1 implements the move to `docs/ai/skills/` and path updates; Phase 2 adds thin adapters per ADAPTER_REGISTRY and stealth (no adapter files, paste-once pointer in .agenticguild/PASTE_INTO_IDE.txt).
