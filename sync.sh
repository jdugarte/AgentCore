#!/bin/bash
# sync.sh
# Quickly downloads the universal AI Skills and Playbooks from the AgentCore Global Brain.
# Usage: ./sync.sh

REPO_URL="https://raw.githubusercontent.com/jdugarte/AgentCore/main"

echo "🧠 Initializing Local Agent Brain..."

# Create necessary directories
mkdir -p .cursor/skills/{start-feature,finish-branch,harvest-rules,status-check,code-review}
mkdir -p docs/{ai,core,ui,features,audit,guides}
mkdir -p docs/core/ADRs
mkdir -p .github
mkdir -p docs/.agent-core-templates

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
curl -s "$REPO_URL/skills/audit-compliance/SKILL.md" > .cursor/skills/audit-compliance/SKILL.md

# Download GitHub PR Template
echo "📥 Syncing GitHub Templates..."
curl -s "$REPO_URL/templates/pr/PULL_REQUEST_TEMPLATE.md" > .github/PULL_REQUEST_TEMPLATE.md

# Download HRE Compliance Standards
echo "📥 Syncing HRE Standards..."
mkdir -p docs/ai/hre
curl -s "$REPO_URL/templates/hre/jpl_standards.md" > docs/ai/hre/jpl_standards.md

# Download Documentation Templates (as starting points)
echo "📥 Syncing Documentation Templates..."
curl -s "$REPO_URL/templates/core/SPEC.md" > docs/.agent-core-templates/SPEC.md
curl -s "$REPO_URL/templates/ui/ui_roadmap_and_inventory.md" > docs/.agent-core-templates/ui_roadmap_and_inventory.md

# Initialize Core Docs if missing and cleanup
if [ ! -f "docs/core/SPEC.md" ]; then
    echo "📄 Initializing docs/core/SPEC.md from template..."
    cp docs/.agent-core-templates/SPEC.md docs/core/SPEC.md
    rm docs/.agent-core-templates/SPEC.md
fi

if [ ! -f "docs/ui/ui_roadmap_and_inventory.md" ]; then
    echo "📄 Initializing docs/ui/ui_roadmap_and_inventory.md from template..."
    cp docs/.agent-core-templates/ui_roadmap_and_inventory.md docs/ui/ui_roadmap_and_inventory.md
    rm docs/.agent-core-templates/ui_roadmap_and_inventory.md
fi

# Cleanup template directory if empty
if [ -z "$(ls -A docs/.agent-core-templates)" ]; then
    rmdir docs/.agent-core-templates
fi

# Smart Git Hook Installation
echo "⚓ Installing Git Hooks..."
curl -s "$REPO_URL/templates/git-hooks/pre-commit-logic.sh" > .cursor/pre-commit-logic.sh

HOOK_FILE=".git/hooks/pre-commit"
if [ -f "$HOOK_FILE" ]; then
    if ! grep -q "AGENTCORE PR DRAFT PROTECTION" "$HOOK_FILE"; then
        echo "📝 Appending safety check to existing pre-commit hook..."
        cat .cursor/pre-commit-logic.sh >> "$HOOK_FILE"
    else
        echo "✅ Safety check already present in pre-commit hook."
    fi
else
    echo "🆕 Creating new pre-commit hook..."
    echo "#!/bin/bash" > "$HOOK_FILE"
    cat .cursor/pre-commit-logic.sh >> "$HOOK_FILE"
    chmod +x "$HOOK_FILE"
fi

echo "✅ Sync complete. Local AI workflows are up-to-date with AgentCore."
