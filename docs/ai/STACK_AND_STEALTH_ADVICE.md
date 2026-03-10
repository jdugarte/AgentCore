# Stack validation, separate stack install, and stealth mode

This doc answers: (1) how stack ids are validated, (2) whether stack rules can be installed separately from the main engine, and (3) how stealth mode behaves with the new adapters.

---

## 1. Stack id validation — validate and abort

**Recommendation (implemented):** When the user passes `--stack=<id>`, sync.sh **validates** the id against `playbooks/STACK_REGISTRY.md` and **aborts** if the id is not in the registry.

- **Why abort:** If the user explicitly asked for a stack, they expect that stack to be applied. Continuing without it would be misleading (e.g. they think they have Rails rules but a typo meant nothing was applied).
- **Behavior:** sync.sh fetches STACK_REGISTRY, parses all rows to build the list of valid ids, and looks up `--stack=<id>`. If there is no matching row, it prints:  
  `Invalid --stack=<id>. Valid stack ids: rails, django, react-native (see playbooks/STACK_REGISTRY.md).`  
  and exits with status 1. If the registry cannot be fetched, it also exits 1 so we never guess.
- **Adding stacks:** Add a row to STACK_REGISTRY; no code change in sync.sh. The valid-id list is derived from the registry at run time.

---

## 2. Separating stack rules from the main install

**Recommendation:** Treat stack rules as an **optional add-on** and support installing them **separately** from the core agentic:guild install.

- **Option A — Keep `--stack=` in sync.sh (current):** One command does everything: `sync.sh --stack=rails`. Simple for users who want stack rules from day one.
- **Option B — Separate script (recommended as well):** Provide **`sync-stack.sh`** (or `install-stack-rules.sh`) that *only* installs stack rules: fetches STACK_REGISTRY, validates the id, fetches the template, writes `docs/ai/STACK_RULES.md`. No skills, no adapters, no .agenticguild. Users can run it after sync.sh or in a repo that already has agentic:guild.

**Why separate is useful:**

- **Clear separation of concerns:** Core install = engine + adapters + canonical rules. Stack install = one file (STACK_RULES.md) with stack-specific conventions.
- **Optional and repeatable:** Some users never want stack templates; others want to add or change stack rules later without re-running the full sync.
- **Stealth and stacks:** If stack rules are separate, you can choose whether to run the stack installer in a given repo (and whether to track `docs/ai/STACK_RULES.md` or exclude it in stealth).

**Usage:**

- **All-in-one:** `sync.sh --stack=rails` (validates id, then applies stack as today).
- **Separate:** `sync.sh` (core only), then later `sync-stack.sh rails` (or `curl ... sync-stack.sh | bash -s -- rails`). Same registry and validation; sync-stack.sh just does the stack step.

The repo now includes **`sync-stack.sh`** for the separate flow. sync.sh still accepts `--stack=` for convenience.

---

## 3. Stealth mode: no adapter files

**Issue:** A "varied thin adapters" scheme (creating .cursorrules, AGENTS.md, CLAUDE.md, etc.) clashes with stealth: even if we exclude those files, we create many new files in the project tree. So the varied-adapters approach wrecks the stealth goal.

**Recommendation (implemented): In stealth mode, create zero adapter files.**

- **Adapters:** Do not create or modify any IDE adapter file when `--stealth` is set. The adapter loop is skipped entirely.
- **Canonical rules:** In stealth, the full rules are written to **`.agenticguild/AGENTIC_GUILD_RULES.md`** (not to docs/ai/). The registry row for docs/ai/AGENTIC_GUILD_RULES.md is skipped in stealth.
- **One-time pointer:** sync.sh writes **`.agenticguild/PASTE_INTO_IDE.txt`** with a single line the user can paste into their IDE's rules (once). Everything stays under `.agenticguild/`, which is already excluded.

**Result:** No new files outside .agenticguild/. The user adds one line from PASTE_INTO_IDE.txt to their IDE once. Stealth remains feasible.
| Mode   | Adapter files | Canonical rules | How the agent gets rules |
|--------|----------------|------------------|---------------------------|
| Normal | Created per ADAPTER_REGISTRY | docs/ai/AGENTIC_GUILD_RULES.md | Each adapter points to the canonical file |
| Stealth| None | .agenticguild/AGENTIC_GUILD_RULES.md | User pastes line from .agenticguild/PASTE_INTO_IDE.txt into IDE once |

**Stack rules in stealth:** If `--stack=` is used with `--stealth`, stack rules can be written to `.agenticguild/STACK_RULES.md` (excluded) instead of docs/ai/. (Optional refinement.)

Optional future refinement: in stealth mode, when `--stack=` is used, write STACK_RULES.md to a path that is excluded (e.g. `.agenticguild/STACK_RULES.md`) and have the thin adapter say “if present, also read .agenticguild/STACK_RULES.md” so stack rules stay out of the tree. For now, stack rules go to docs/ai/STACK_RULES.md as a single, documented place.
