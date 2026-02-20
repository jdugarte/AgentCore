# AI Developer Protocols (AgentCore)

This repository serves as the "Global Brain" and meta-tooling environment for deploying, maintaining, and upgrading AI-assisted workflows across multiple projects (e.g., web applications, mobile apps, and backend services).

## The End Goal

We are building a centralized **AI Developer Protocol** that can be installed in any new or existing project. 
The ultimate goal is to distribute this as a CLI utility (e.g., via Homebrew) so you can execute commands like:

```bash
# Initialize AI workflows in a new project
ai-tools init django

# Update the local tools with the latest intelligence from the global brain
ai-tools update
```

## How to Start Exploring

### 1. Universal Skills (`/skills/`)
This directory contains the tech-agnostic Standard Operating Procedures (SOPs) for the AI. 
- `start-feature`: The Discovery and TDD Loop engine.
- `finish-branch`: The Code Review, BugBot, and PR closing engine.
- `harvest-rules`: The engine that extracts learnings and updates the rules.
- `status-check`: The context rehydrator.

### 2. Universal Playbooks (`/playbooks/`)
- `AI_DEVELOPER_PROTOCOL.md`: The 6-phase masterclass playbook to audit and refine documentation and AI rules in any project.
- `AI_WORKFLOW_PLAYBOOK.md`: The manual explaining exactly how to use the custom skills.
- `EXPECTED_PROJECT_STRUCTURE.md`: **Required reading for agents and maintainers.** Lists every file and folder the skills assume, how to create them, and what to do when something is missing. Synced projects get a copy at `docs/ai/EXPECTED_PROJECT_STRUCTURE.md`.

### 3. Synchronization (`sync.sh`)
While the Go CLI is being built, a starter Bash script `sync.sh` is provided. You can run this in any project to download the universal skills directly from your GitHub repository.

## Next Steps
See `specs/META_TOOL_SPEC.md` for the blueprint on building the Go CLI and Homebrew distribution.
