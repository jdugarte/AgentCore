#!/bin/bash
# sync.sh
# Quickly downloads the universal AI Skills and Playbooks from the AgentCore Global Brain.
# Usage: ./sync.sh

REPO_URL="https://raw.githubusercontent.com/jesus/AgentCore/main"

echo "🧠 Initializing Local Agent Brain..."

# Create necessary directories
mkdir -p .cursor/skills/{start-feature,finish-branch,harvest-rules,status-check,code-review}
mkdir -p docs/ai

# Download Playbooks
echo "📥 Syncing Playbooks..."
curl -s "$REPO_URL/playbooks/AI_DEVELOPER_PROTOCOL.md" > docs/ai/AI_DEVELOPER_PROTOCOL.md
curl -s "$REPO_URL/playbooks/AI_WORKFLOW_PLAYBOOK.md" > docs/ai/AI_WORKFLOW_PLAYBOOK.md

# Download Universal Skills
echo "📥 Syncing Master Skills..."
curl -s "$REPO_URL/skills/start-feature/SKILL.md" > .cursor/skills/start-feature/SKILL.md
curl -s "$REPO_URL/skills/finish-branch/SKILL.md" > .cursor/skills/finish-branch/SKILL.md
curl -s "$REPO_URL/skills/status-check/SKILL.md" > .cursor/skills/status-check/SKILL.md
curl -s "$REPO_URL/skills/harvest-rules/SKILL.md" > .cursor/skills/harvest-rules/SKILL.md
curl -s "$REPO_URL/skills/code-review/SKILL.md" > .cursor/skills/code-review/SKILL.md

echo "✅ Sync complete. Local AI workflows are up-to-date with AgentCore."
