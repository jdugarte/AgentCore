# Living Spec: agentic:guild MCP Server & Formal Engineering Framework

**Status:** Draft (living document)  
**Last updated:** 2026-04-21  
**Scope:** Define the MCP-backed `agentic:guild` runtime, the Go monobinary distribution model, configuration and memory, agent–server contracts, and phased implementation.  
**Audience:** Implementers, maintainers, and anyone extending skills or tooling.

---

## 0. Document charter

This spec is the **authoritative planning surface** for pivoting `agentic:guild` from Markdown-first guidance (rules, skills text, `sync.sh` injection) toward a **deterministic, MCP-enforced** engineering framework.

- **Normative language:** Sections marked **MUST** / **SHOULD** / **MAY** describe intended conformance for the MCP server and CLI unless explicitly deferred to a later revision.
- **Living sections:** [§9 Open questions](#9-open-questions) and [§10 Implementation roadmap](#10-implementation-roadmap) are expected to change as design tightens.
- **Related material:** Current human workflows and skill intent remain documented in [`playbooks/AI_WORKFLOW_PLAYBOOK.md`](../../playbooks/AI_WORKFLOW_PLAYBOOK.md). Older or parallel proposals: [`AGENTIC_GUILD_CONFIG_SPEC.md`](./AGENTIC_GUILD_CONFIG_SPEC.md), [`AI_TOOLS_CLI_SPEC.md`](./AI_TOOLS_CLI_SPEC.md).

---

## 1. Goals and non-goals

### 1.1 Goals

1. **Runtime enforcement:** Critical workflow steps (e.g. start-task, audit-compliance) are exposed as **MCP tools** so the model interacts through validated, logged operations—not only passive Markdown.
2. **IDE agnosticism:** One integration surface (MCP over stdio) instead of maintaining many IDE-specific rule injection paths as the primary control plane.
3. **Single distributable:** One **Go monobinary** implements both the human CLI and the MCP server, sharing types and validation.
4. **Observable, explainable runs:** State machines, events, metrics, and explain tools make behavior inspectable without inferring from chat.
5. **Flexible memory:** Default **hidden/global** storage with optional **repo-visible** mode for collaboration and CI, with explicit migration and safety considerations.

### 1.2 Non-goals (initial phases)

- Replacing every existing Markdown skill with Go on day one (incremental port is acceptable).
- Defining the full catalog of skills and every step transition in this document (that belongs in per-skill specs or generated docs).
- Mandating a specific LLM or IDE vendor beyond MCP conformance.

---

## 2. Background: why move beyond Markdown injection

The starter-kit model (injecting Markdown, adapter files like `.cursorrules` / `CLAUDE.md` / `AGENTS.md`) hit practical limits:

| Issue | Impact |
|--------|--------|
| **Suggestion vs constraint** | Text rules are easy to skip; there is no single runtime gate. |
| **IDE fragmentation** | Each environment loads different files; adapter matrix grows. |
| **Headless vs discoverability** | True “no repo footprint” conflicted with discoverable skills/docs unless the tree was polluted. |

MCP addresses the **enforcement** gap: tools are **invoked**; the server can **reject invalid transitions** and **persist state** outside chat.

---

## 3. Product shape: Go monobinary

### 3.1 Single binary, two modes

| Invocation | Role |
|------------|------|
| `agentic …` (CLI subcommands) | Human control plane: init, status, memory, doctor, etc. |
| `agentic mcp-server` (or equivalent) | JSON-RPC MCP server over stdio for IDEs/agents |

**Requirements**

- The CLI and MCP server **MUST** share core packages: configuration parsing, state machine, persistence, validation, and logging.
- Version string **SHOULD** be identical for both modes (`agentic version` matches MCP `initialize` metadata).

### 3.2 Distribution

- Target installation via package managers (e.g. Homebrew): `brew install agentic-guild` (exact formula name TBD).
- Release pipeline **SHOULD** align with existing Go release practice (e.g. GoReleaser) as sketched in [`AI_TOOLS_CLI_SPEC.md`](./AI_TOOLS_CLI_SPEC.md), whether the final product name is `ai-tools`, `agentic`, or a merged branding—see [§9](#9-open-questions).

---

## 4. Configuration anchor

### 4.1 Project anchor file

The runtime **MUST** resolve project configuration from **`.agenticguild/config.json`** at the repository root (exact discovery rules for monorepos: open, see [§9](#9-open-questions)).

### 4.2 Explicit environments (IDEs)

Instead of inferring IDE from `.cursor/` or `.windsurf/` trees, configuration **MUST** include an explicit list, e.g.:

```json
{
  "environments": ["cursor", "antigravity"]
}
```

**Implications**

- **Concurrent connections:** Multiple IDEs **MAY** attach to the same local MCP process; shared state updates apply to all clients.
- **Rule harvesting:** A `harvest-rules` tool **SHOULD** read `environments` and update all configured adapter surfaces in one coherent operation (when not in headless mode—see §6).

### 4.3 Governance modes

Configuration **SHOULD** support at least:

- **`governance_mode`:** e.g. `"strict"` requires architecture artifacts (`SPEC.md`, etc.) before certain transitions.
- **`headless`:** boolean; when true, relaxes **file-presence** gates while still enforcing agreed execution loops (e.g. TDD/CbC as configured).

Headless mode **SHOULD** support **custom context paths** (repo-local or global), for example:

```json
{
  "headless": true,
  "generation_rules_path": ".agenticguild/custom_generation_rules.md",
  "code_review_prompt_path": ".agenticguild/custom_code_review.md"
}
```

**Behavior (normative intent)**

- The MCP server **MAY** inject contents of those files into **tool result payloads** so rules enter context without relying on the IDE’s native file reads.
- In headless mode, `harvest-rules` **SHOULD** append to the configured local, git-ignored rules file rather than project-tracked docs.
- Paths **MAY** point to user-global directories (e.g. under `~/.agenticguild/`) for portable personal standards.

---

## 5. Memory and persistence

### 5.1 Modes

| Mode | Storage | Default |
|------|---------|---------|
| **Hidden / global** | e.g. `~/.agenticguild/state/<hash>/` where `<hash>` derives from the project’s absolute path | **Default** |
| **Repo** | `.agenticguild/active_sessions/`, `current_state.md`, etc. (legacy-compatible) | Opt-in |

Controlled by configuration, e.g. `"memory_mode": "repo"` vs default hidden behavior.

### 5.2 Requirements

- **Migration:** CLI command `agentic memory use [repo|local]` **SHOULD** safely migrate state between backends with clear backup/dry-run semantics (TBD in implementation).
- **Sanitization:** Repo mode **MUST** define a policy for redacting secrets from persisted logs/state before writes that could be committed (exact patterns TBD).
- **Concurrency:** Multiple IDE clients **MUST NOT** corrupt shared state; define locking or serial mutation model (TBD).

---

## 6. Headless mode (naming and semantics)

The term **Headless** replaces informal “stealth”: the framework runs with **reduced reliance on repo-tracked governance files**, not “invisible security.”

**Requirements**

- Headless **MUST** be declarative in `config.json` and **MUST** be distinguishable from strict governance in logs and `get_state` output.
- Custom rules paths **MUST** be validated (existence, permissions, size limits) to avoid accidental exfiltration or huge payloads.

---

## 7. CLI (human control plane)

The CLI provides **deterministic** operations without invoking an LLM.

### 7.1 v1 command catalog (from exploration)

| Command | Purpose |
|---------|---------|
| `agentic init` | Scaffold `.agenticguild/config.json`, project identity, optional MCP wiring in IDE configs |
| `agentic memory use [repo\|local]` | Toggle memory backend; migrate state |
| `agentic status` | Print current skill, phase, step from shared state |
| `agentic step` / `agentic explain` | Manual advance or explanation of last automated action |
| `agentic doctor` | Verify IDE/MCP connectivity, required files (e.g. `SPEC.md` when strict), memory paths |

Additional commands from the exploration doc (`agentic stats` for metrics) **SHOULD** align with [§8.5](#85-observability-and-metrics).

---

## 8. MCP server: runtime model

### 8.1 Global execution state machine

The server **MUST** implement a **global** session state machine with **explicit transitions** (invalid transitions rejected).

| State | Meaning |
|-------|---------|
| `IDLE` | No active skill execution |
| `RUNNING` | Skill executing |
| `WAITING` | Blocked on external input/confirmation |
| `ERROR` | Step failure |
| `COMPLETED` | Skill finished successfully |

**Transitions (baseline)**

- `IDLE → RUNNING`: skill start  
- `RUNNING → WAITING`: step needs input  
- `WAITING → RUNNING`: input received  
- `RUNNING → ERROR`: failure  
- `ERROR → RUNNING`: retry  
- `RUNNING → COMPLETED`: all steps success  
- `ANY → IDLE`: reset  

**Requirements**

- Transitions **MUST** be validated centrally.
- Current state **MUST** be queryable (tool such as `get_state`).
- Transition **MUST** emit persisted events (see §8.3).

### 8.2 Skills as (nested) state machines

Skills **SHOULD** be modeled as state machines, not only linear step lists:

- Declarative structure includes **states**, **transitions**, **terminal states**.
- Benefits: branching, conditional paths, retries, recovery.

The MCP server **MUST** enforce valid per-skill transitions in line with the global machine (exact composition rules TBD—see [§9](#9-open-questions)).

### 8.3 Event system

**Core events** (minimum set):

- `on_skill_started`, `on_step_started`, `on_step_completed`, `on_step_failed`, `on_skill_completed`, `on_error`

**Requirements**

- Events **MUST** include timestamps and metadata (skill id, step id, result summary).
- Events **MUST** be persisted for history/explain/debug.
- Events **SHOULD** be consumable by CLI and future UI (`agentic stats`, tail logs, etc.).

### 8.4 Agent–MCP contract

**Principles**

- The agent **MUST NOT** treat chat history as source of truth for framework state.
- The agent **MUST** use MCP tools for: current skill, step, next actions, history.

**Enforcement**

- The server **MAY** reject or flag tool calls inconsistent with state (policy per tool).
- Tool responses **SHOULD** be structured to guide the next legal action.

**Illustrative required flows**

- Before “what’s next?” → call `get_state`  
- Before continuing execution → call `get_current_step`  
- Before explaining behavior → call `get_history` / `explain_last_action`  

(System prompts and IDE rules **SHOULD** reinforce this; the server remains the authority.)

### 8.5 Tool execution result contract

All tools **MUST** return a consistent envelope, conceptually:

```json
{
  "success": true,
  "state_diff": {},
  "error": null,
  "message": "Human-readable summary"
}
```

**Rules**

- On failure: `success` false, `error` populated, and state **SHOULD** remain unmutated (atomicity preferred).
- All invocations **MUST** be logged to the event/history stream.

(MCP wire format may wrap this in standard `CallToolResult` content; the spec defines the **application-level** payload shape.)

### 8.6 Permissions and safety

**Categories (extensible)**

- `read_only`, `write_code`, `modify_files`, `run_shell`, `network_access` (future)

**Requirements**

- Each tool **MUST** declare required permissions.
- Server **MUST** validate permissions before execution.
- Configuration **SHOULD** allow disabling categories; sensitive operations **SHOULD** support explicit confirmation flows.
- **MAY** vary defaults by environment (local vs CI).

### 8.7 State schema versioning

Persisted state **MUST** include a version, e.g.:

```json
{
  "version": "1.0",
  "state": {}
}
```

**Requirements**

- Implement migrations where feasible; on mismatch, fail with a **clear** actionable error or run guided migration (TBD).

### 8.8 Observability and metrics

**Minimum**

- Timestamps on all events  
- Per-step duration  
- Categorized errors  

**Suggested aggregates**

- Steps per skill, average duration, error rate per skill, retries  

**Surfacing**

- CLI (`agentic stats` / `status`), logs, future dashboards  

### 8.9 Explainability

Explainability is **first-class**.

**Tools (examples)**

- `explain_last_action`, `explain_step`, `explain_state`

**Outputs SHOULD cover**

- What was done, why, which rules/constraints applied, what comes next.

---

## 9. Open questions

Use this section to track decisions that are intentionally unresolved in early drafts.

| ID | Topic | Question |
|----|--------|----------|
| OQ-1 | **Config file name** | This spec uses `.agenticguild/config.json`. [`AGENTIC_GUILD_CONFIG_SPEC.md`](./AGENTIC_GUILD_CONFIG_SPEC.md) discusses optional `agentic_guild.yml`. **Single anchor vs layered config?** Migration path from YAML if both exist? |
| OQ-2 | **CLI/binary naming** | Align with `ai-tools` vs new `agentic` branding; Homebrew formula and MCP command string. |
| OQ-3 | **Monorepo roots** | How is the anchor discovered when multiple packages share one git root? First `.agenticguild/`, nearest to cwd, or explicit `AGENTIC_GUILD_ROOT`? |
| OQ-4 | **Global vs per-skill state** | Exact rules when global state is `RUNNING` but a tool targets a different skill (queue, reject, or nested session). |
| OQ-5 | **Permission UX** | Where do confirmations render (IDE dialog vs CLI vs deferred queue)? |
| OQ-6 | **Sanitization** | Concrete redaction rules and opt-out for local-only debug. |
| OQ-7 | **Backward compatibility** | Support period for Markdown-only projects using `sync.sh` without MCP. |
| OQ-8 | **Tool catalog v1** | Minimal set to ship first (e.g. `get_state`, `start_skill`, `advance_step`, `reset`) vs parity with all playbook skills. |
| OQ-9 | **Generated docs** | Exact mapping from Go structs to `SKILL.md` and frequency (on build, on release, on `agentic doctor`). |
| OQ-10 | **Network** | Whether MCP server ever calls network by default (version check, skill download) vs strictly offline. |

---

## 10. Implementation roadmap

Phased plan for execution; adjust sequencing after resolving [§9](#9-open-questions).

### Phase 0 — Repository and decisions

1. Close **OQ-1, OQ-2, OQ-8** enough to start coding (config anchor name, binary name, MVP tool list).
2. Add a short **Architecture Decision Record** (ADR) in-repo for “MCP + Go monobinary” (optional but recommended).

### Phase 1 — Monobinary skeleton

1. Go module layout: `cmd/agentic`, `internal/mcp`, `internal/cli`, `internal/core` (names illustrative).
2. Cobra (or equivalent) CLI with `version`, `mcp-server`, stub `doctor`.
3. MCP stdio server: `initialize`, `tools/list`, `tools/call` plumbing with static mock tool.

### Phase 2 — Configuration and memory

1. Parse `.agenticguild/config.json`; defaults for missing keys.
2. Implement hidden hash-based store + repo mode; persistence API with version field.
3. `agentic init` scaffolds config; `agentic memory use` migration prototype.

### Phase 3 — State machine and events

1. Implement global state machine with validated transitions and logging.
2. Event journal on disk; `get_state`, `get_history` tools.
3. `agentic status` reads same store as MCP.

### Phase 4 — First real skill path

1. Encode **one** pilot skill as a nested state machine (suggest: narrow slice of “start-task” or an internal `echo` skill) end-to-end.
2. Tool result envelope + atomicity tests.
3. Wire explain tool for that skill only.

### Phase 5 — Permissions and safety

1. Declare permissions per tool; config toggles; reject unsafe calls in CI profile.
2. Define confirmation path for at least one sensitive category (even if stubbed).

### Phase 6 — IDE integration and harvesting

1. `agentic init` optional MCP snippet injection per `environments`.
2. `harvest-rules` behavior for strict vs headless modes; tests for multi-IDE file updates.

### Phase 7 — Observability and polish

1. Metrics aggregation; `agentic stats`.
2. Sanitization policy for repo mode (**OQ-6**).
3. Documentation generator: Go → Markdown projection for skills (**OQ-9**).

### Phase 8 — Migration and release

1. Migration guides from Markdown/sync workflow.
2. GoReleaser/Homebrew; version compatibility policy (**OQ-7**).
3. Expand tool catalog toward playbook parity.

---

## 11. Success criteria (initial)

The MCP pivot is **on track** when:

1. An IDE can complete a **guided** workflow using only MCP tools without reading `.agenticguild/current_state.md` for truth (file may still exist for humans).
2. Invalid operations are **rejected** with structured errors, not silent drift.
3. `agentic status` and MCP `get_state` **never disagree** on the same store.
4. A fresh install can run **`agentic init` + MCP attach** in under documented time with **documented** config keys.

---

## 12. References

- Exploration notes (source): user-provided `MCP_2.md` (April 2026 synthesis).
- [`playbooks/AI_WORKFLOW_PLAYBOOK.md`](../../playbooks/AI_WORKFLOW_PLAYBOOK.md) — current skill intents and workflows.
- [`specs/proposals/AGENTIC_GUILD_CONFIG_SPEC.md`](./AGENTIC_GUILD_CONFIG_SPEC.md) — centralized config discussion.
- [`specs/proposals/AI_TOOLS_CLI_SPEC.md`](./AI_TOOLS_CLI_SPEC.md) — prior Go CLI sketch.

---

*Maintainers: update **Last updated**, **Status**, and [§9](#9-open-questions) as decisions land; keep [§10](#10-implementation-roadmap) aligned with actual milestones.*
