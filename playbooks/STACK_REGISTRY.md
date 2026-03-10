# agentic:guild Stack Registry

This file tells sync.sh **which stack-specific rules template** to use when the user's environment matches a known stack (Rails, Django, React Native, etc.). It is the single source of truth for:

- **Stack id** — used with `sync.sh --stack=rails` (or auto-detected).
- **Detection hint** — how to auto-detect the stack (e.g. presence of a file).
- **Template path** — upstream path to the stack rules file (generic name, not .cursorrules).

Sync.sh uses this to copy the right **stack rules** into the project (e.g. `docs/ai/STACK_RULES.md`) so the agent gets both the core agentic:guild OS and stack-specific conventions. The core rules live in `AGENTIC_GUILD_RULES.md`; stack rules are an optional addendum.

## Format

Table between `STACK_REGISTRY [START]` and `STACK_REGISTRY [END]`. Columns: Stack id | Detection file (project root) | Upstream template path.

- **Stack id:** Value for `--stack=<id>` (e.g. `rails`, `django`, `react-native`).
- **Detection file:** If this file exists in the project root, the stack can be auto-detected (e.g. `Gemfile` for Rails). Leave empty or use a placeholder if detection is not supported.
- **Upstream template path:** Path in the agentic-guild repo to the stack rules (e.g. `templates/stacks/rails/STACK_RULES.md`).

## Behavior

- **With `--stack=<id>`:** Sync.sh fetches the row for that id and downloads the template to `docs/ai/STACK_RULES.md` (merge or overwrite; see strategy in SYNC_REGISTRY if we add it there, or overwrite by default for stack so updates apply).
- **Auto-detect (optional):** If sync.sh is run without `--stack=`, it can look at the project root for each detection file in order; first match wins. Then fetch the corresponding template to `docs/ai/STACK_RULES.md`.
- **No stack:** If no `--stack=` and no auto-detect, skip copying stack rules. Only core rules and adapters are applied.

<!-- STACK_REGISTRY [START] -->
| Stack id     | Detection file   | Upstream template path                          |
|:-------------|:-----------------|:------------------------------------------------|
| rails        | Gemfile          | templates/stacks/rails/STACK_RULES.md           |
| django       | requirements.txt | templates/stacks/django/STACK_RULES.md          |
| react-native | package.json     | templates/stacks/react-native/STACK_RULES.md    |
<!-- STACK_REGISTRY [END] -->
