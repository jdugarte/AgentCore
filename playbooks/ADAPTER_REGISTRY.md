# agentic:guild Adapter Registry

This file is the **single source of truth** for which IDE/tool adapter files agentic:guild creates or injects into. It is consumed by:

- **`sync.sh`** — fetches this file and injects the thin adapter content (pointer to `docs/ai/AGENTIC_GUILD_RULES.md`) into each listed path. No hardcoded adapter list in the script.
- **`update-agentic-guild` skill** — can read this to know which adapter files to update when the thin-block template or canonical rules change.

When new agentic IDEs or tools adopt a standard (e.g. a new rules file location), add a row here; the next sync will apply the thin adapter to that path without changing sync.sh.

## Format

| IDE / Tool   | Adapter path (project-relative)   | Notes |
|:-------------|:----------------------------------|:------|
| Cursor       | .cursorrules                     | Legacy; Cursor also supports .cursor/rules/*.mdc |
| Cursor (new) | .cursor/rules/agentic-guild.mdc  | Preferred for Cursor when using .cursor/rules/ |
| AGENTS.md    | AGENTS.md                        | Cross-IDE standard; many tools read this |
| Claude Code  | CLAUDE.md                        | Claude Code native instructions file |
| Windsurf     | .windsurf/rules/agentic-guild.md | Windsurf rules directory |
| Cline        | .clinerules/agentic-guild.md     | Cline project rules |

## Injection behavior

- **Thin adapter:** Each path receives the same short directive: read and follow `docs/ai/AGENTIC_GUILD_RULES.md`; skills at `docs/ai/skills/<name>/SKILL.md`. Content comes from `templates/core/AGENTIC_GUILD_ADAPTER.md`.
- If the file does not exist: create it with the thin content; in stealth mode, add to `.git/info/exclude`.
- If the file exists but does not contain the marker block: inject the block (prepend or marked section). Idempotent: do not duplicate.
- Parent directories (e.g. `.cursor/rules/`, `.windsurf/rules/`, `.clinerules/`) are created as needed.

## Adding or changing adapters

Edit the table above (between the block markers). Keep the header row and use `|`-separated columns. sync.sh parses lines between `ADAPTER_REGISTRY [START]` and `ADAPTER_REGISTRY [END]`.

<!-- ADAPTER_REGISTRY [START] -->
| IDE / Tool   | Adapter path (project-relative)   | Notes |
|:-------------|:----------------------------------|:------|
| Cursor       | .cursorrules                     | Legacy Cursor rules file |
| Cursor (new) | .cursor/rules/agentic-guild.mdc  | Cursor .cursor/rules/ convention |
| AGENTS.md    | AGENTS.md                        | Cross-IDE standard |
| Claude Code  | CLAUDE.md                        | Claude Code instructions |
| Windsurf     | .windsurf/rules/agentic-guild.md | Windsurf rules |
| Cline        | .clinerules/agentic-guild.md     | Cline project rules |
<!-- ADAPTER_REGISTRY [END] -->
