#!/bin/bash
# sync.sh
# Quickly downloads the universal AI Skills and Playbooks from the AgentCore Global Brain.
# Usage: ./sync.sh

REPO_URL="https://raw.githubusercontent.com/jesus/AgentCore/main"

echo "🧠 Initializing Local Agent Brain..."

# Create necessary directories
mkdir -p .cursor/skills/{start-feature,finish-branch,harvest-rules,status-check,code-review}
mkdir -p docs/ai
mkdir -p docs/core/ADRs

# Download Playbooks and expected structure
echo "📥 Syncing Playbooks..."
curl -s "$REPO_URL/playbooks/AI_DEVELOPER_PROTOCOL.md" > docs/ai/AI_DEVELOPER_PROTOCOL.md
curl -s "$REPO_URL/playbooks/AI_WORKFLOW_PLAYBOOK.md" > docs/ai/AI_WORKFLOW_PLAYBOOK.md
curl -s "$REPO_URL/playbooks/EXPECTED_PROJECT_STRUCTURE.md" > docs/ai/EXPECTED_PROJECT_STRUCTURE.md

# Download ADR template (so start-feature can draft ADRs)
curl -s "$REPO_URL/templates/adr/0000-ADR-TEMPLATE.md" > docs/core/ADRs/0000-ADR-TEMPLATE.md

# Download Universal Skills
echo "📥 Syncing Master Skills..."
curl -s "$REPO_URL/skills/start-feature/SKILL.md" > .cursor/skills/start-feature/SKILL.md
curl -s "$REPO_URL/skills/finish-branch/SKILL.md" > .cursor/skills/finish-branch/SKILL.md
curl -s "$REPO_URL/skills/status-check/SKILL.md" > .cursor/skills/status-check/SKILL.md
curl -s "$REPO_URL/skills/harvest-rules/SKILL.md" > .cursor/skills/harvest-rules/SKILL.md
curl -s "$REPO_URL/skills/code-review/SKILL.md" > .cursor/skills/code-review/SKILL.md

echo "✅ Sync complete. Local AI workflows are up-to-date with AgentCore."
