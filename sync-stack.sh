#!/bin/bash
# sync-stack.sh
# Installs only stack-specific rules into the project (docs/ai/STACK_RULES.md).
# Use this to add or update stack rules without re-running the full sync.sh.
# Usage: ./sync-stack.sh <stack_id>
# Example: ./sync-stack.sh rails
# Valid stack ids are defined in playbooks/STACK_REGISTRY.md (e.g. rails, django, react-native).

REPO_URL="https://raw.githubusercontent.com/jdugarte/agentic-guild/main"
STACK_REGISTRY_URL="$REPO_URL/playbooks/STACK_REGISTRY.md"
TMP_STACK_REGISTRY="/tmp/agenticguild_stack_registry.md"

if [ -z "$1" ]; then
  echo "Usage: $0 <stack_id>"
  echo "Example: $0 rails"
  echo "Valid stack ids are in playbooks/STACK_REGISTRY.md (e.g. rails, django, react-native)."
  exit 1
fi

STACK="$1"

echo "📚 Fetching Stack Registry..."
curl -s "$STACK_REGISTRY_URL" > "$TMP_STACK_REGISTRY"
if [ ! -s "$TMP_STACK_REGISTRY" ]; then
  echo "❌ Failed to fetch STACK_REGISTRY. Check your internet connection."
  exit 1
fi

in_block=false
valid_ids=""
stack_template=""
while IFS= read -r line; do
  if [[ "$line" == *"STACK_REGISTRY [START]"* ]]; then in_block=true; continue; fi
  if [[ "$line" == *"STACK_REGISTRY [END]"* ]]; then in_block=false; continue; fi
  if ! $in_block; then continue; fi
  [[ "$line" != \|* ]] && continue
  [[ "$line" == *"Stack id"* ]] && continue
  [[ "$line" == *"---"* ]] && continue
  IFS='|' read -r stack_id _ template_path <<< "$line"
  stack_id=$(echo "$stack_id" | xargs)
  template_path=$(echo "$template_path" | xargs)
  [ -z "$stack_id" ] && continue
  valid_ids="${valid_ids:+$valid_ids, }$stack_id"
  if [ "$stack_id" = "$STACK" ] && [ -n "$template_path" ]; then
    stack_template="$template_path"
  fi
done < "$TMP_STACK_REGISTRY"
rm -f "$TMP_STACK_REGISTRY"

if [ -z "$stack_template" ]; then
  echo "❌ Invalid stack id: $STACK"
  echo "Valid stack ids: $valid_ids (see playbooks/STACK_REGISTRY.md)."
  exit 1
fi

mkdir -p docs/ai
STACK_RULES=$(curl -s "$REPO_URL/$stack_template")
if [ -z "$STACK_RULES" ]; then
  echo "❌ Failed to fetch stack template: $stack_template"
  exit 1
fi

echo "📥 Writing docs/ai/STACK_RULES.md from $stack_template..."
echo "$STACK_RULES" > docs/ai/STACK_RULES.md
echo "✅ Stack rules for '$STACK' installed at docs/ai/STACK_RULES.md"
