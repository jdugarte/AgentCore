# Proposal: Localization Bridge (Multi-Language Support)

**Status**: Draft / Future Feature
**Goal**: Enable AgentCore projects to operate in any language while maintaining a single English codebase for the framework's core logic.

## Context
Standardizing AI workflows in English is great for development speed but can be a barrier for non-English speaking teams or teams building applications for localized markets. LLMs are naturally polyglot; we should leverage this to bridge the gap.

## Proposed Strategy: "English for Rules, Local for Output"
Technical playbooks and skill instructions are kept in English for maintainability. The **Agent's output** (SOPs, PRs, and Specs) adapts to the team's language via project configuration.

## Proposed Changes

### 1. Framework Initialization
- **`sync.sh` update**: Add a language selection mechanism (e.g., `./sync.sh --lang es`).
- **Config Storage**: Record the primary language in `docs/ai/AGENT_CONFIG.json` or a similar configuration artifact.

### 2. AI Communication Protocol
- **`COMMUNICATION_PROTOCOL.md`**: A new playbook instructing the AI to:
  - Detect the target language from config.
  - Conduct all discovery Q&A in the target language.
  - Generate all markdown artifacts (`SPEC.md`, `implementation_plan.md`, etc.) in the target language.
  - Maintain technical English for code while providing localized explanations.

### 3. Localization Routing
- **`.cursorrules` Integration**: Add a high-priority rule to check the communication protocol before starting any task.

### 4. Documentation Utility Skills
- **`localize-docs` Skill**: A utility to scan the `docs/` folder and translate existing templates (like `SPEC.md`) into the project's primary language as a one-time bootstrap.

## Implementation Steps
1. [ ] Implement language detection in `sync.sh`.
2. [ ] Draft the global `COMMUNICATION_PROTOCOL.md`.
3. [ ] Update stack templates (`.cursorrules`) to respect localization.
4. [ ] Build the `localize-docs` skill for legacy/template translation.
