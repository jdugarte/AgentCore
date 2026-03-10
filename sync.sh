#!/bin/bash
# sync.sh
# Bootstraps agentic:guild OS in a new destination project.
# For projects already running agentic:guild, use the `update-agentic-guild` AI skill instead.
# Usage: ./sync.sh

REPO_URL="https://raw.githubusercontent.com/jdugarte/agentic-guild/main"
REGISTRY_URL="$REPO_URL/playbooks/SYNC_REGISTRY.md"
ADAPTER_REGISTRY_URL="$REPO_URL/playbooks/ADAPTER_REGISTRY.md"
STACK_REGISTRY_URL="$REPO_URL/playbooks/STACK_REGISTRY.md"
TMP_REGISTRY="/tmp/agenticguild_sync_registry.md"
TMP_ADAPTER_REGISTRY="/tmp/agenticguild_adapter_registry.md"
TMP_STACK_REGISTRY="/tmp/agenticguild_stack_registry.md"

STEALTH_MODE=false
STACK=""
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --stealth) STEALTH_MODE=true; shift ;;
        --stack=*) STACK="${1#--stack=}"; shift ;;
        *) shift ;;
    esac
done

if [ "$STEALTH_MODE" = true ]; then
  echo "🥷 Initializing agentic:guild Operating System in STEALTH MODE..."
else
  echo "🧠 Initializing agentic:guild Operating System..."
fi

# 1. Fetch the Sync Registry (single source of truth for all file mappings)
echo "📋 Fetching Sync Registry..."
curl -s "$REGISTRY_URL" > "$TMP_REGISTRY"
if [ ! -s "$TMP_REGISTRY" ]; then
  echo "❌ Failed to fetch SYNC_REGISTRY.md. Check your internet connection."
  exit 1
fi

# 2. Create necessary directories and stealth tracking
echo "📁 Building directory structure..."

if [ "$STEALTH_MODE" = true ]; then
  mkdir -p .git/info
  EXCLUDE_FILE=".git/info/exclude"
  touch "$EXCLUDE_FILE"
  echo "📝 Securing agentic:guild files in .git/info/exclude selectively (Stealth Mode)..."
  
  # Ensure the exclude file has the section header
  if ! grep -q "# agentic:guild (Stealth Mode)" "$EXCLUDE_FILE"; then
    {
      echo ""
      echo "# agentic:guild (Stealth Mode)"
      echo ".agenticguild/*"
    } >> "$EXCLUDE_FILE"
  fi
  
  # Write stealth config
  mkdir -p .agenticguild
  echo '{"stealth_mode": true}' > .agenticguild/config.json
else
  GITIGNORE_FILE=".gitignore"
  if [ -f "$GITIGNORE_FILE" ]; then
    if ! grep -q ".agenticguild/\*" "$GITIGNORE_FILE"; then
      echo "📝 Securing .agenticguild/ memory folder in .gitignore..."
      {
        echo ""
        echo "# agentic:guild Transient Memory"
        echo ".agenticguild/*"
        echo "!.agenticguild/.gitkeep"
      } >> "$GITIGNORE_FILE"
    fi
  else
    echo "📝 Creating .gitignore to secure .agenticguild/ memory..."
    {
      echo "# agentic:guild Transient Memory"
      echo ".agenticguild/*"
      echo "!.agenticguild/.gitkeep"
    } > "$GITIGNORE_FILE"
  fi
  
  # Ensure stealth mode is explicitly turned off if previously set
  mkdir -p .agenticguild
  echo '{"stealth_mode": false}' > .agenticguild/config.json
fi

# Helper function to create directory
function ensure_dir() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
  fi
}

ensure_dir .agenticguild/active_sessions
ensure_dir .agenticguild/completed_sessions

if [ "$STEALTH_MODE" = false ]; then
  ensure_dir docs/ai
  ensure_dir docs/ai/skills
  ensure_dir docs/core
  ensure_dir docs/features
  ensure_dir docs/audit
  ensure_dir docs/guides
  ensure_dir docs/core/ADRs
  ensure_dir .github
fi

# Ensure .gitkeep exists so the folder structure survives git
touch .agenticguild/.gitkeep
touch .agenticguild/active_sessions/.gitkeep
touch .agenticguild/completed_sessions/.gitkeep

# 4. Download files according to the Sync Registry
echo "📥 Syncing files from registry..."
in_sync_block=false
while IFS= read -r line; do
  # Detect block markers
  if [[ "$line" == *"SYNC_REGISTRY [START]"* ]]; then in_sync_block=true; continue; fi
  if [[ "$line" == *"SYNC_REGISTRY [END]"* ]]; then in_sync_block=false; continue; fi
  if ! $in_sync_block; then continue; fi

  # Skip header and separator rows
  [[ "$line" != \|* ]] && continue
  [[ "$line" == *"Upstream Source"* ]] && continue
  [[ "$line" == *"---"* ]] && continue

  # Parse columns
  IFS='|' read -r _ source dest strategy _ <<< "$line"
  source=$(echo "$source" | xargs)
  dest=$(echo "$dest" | xargs)
  strategy=$(echo "$strategy" | xargs)
  [ -z "$source" ] && continue

  # In stealth, do not create docs/ai/AGENTIC_GUILD_RULES.md; we write it under .agenticguild/ instead
  if [ "$STEALTH_MODE" = true ] && [ "$dest" = "docs/ai/AGENTIC_GUILD_RULES.md" ]; then
    continue
  fi

  # Ensure parent directory exists
  ensure_dir "$(dirname "$dest")"

  if [ "$strategy" == "init" ]; then
    if [ ! -f "$dest" ]; then
      echo "   📄 Initializing $dest..."
      curl -s "$REPO_URL/$source" > "$dest"
      if [ "$STEALTH_MODE" = true ]; then
        if ! grep -q "^$dest$" "$EXCLUDE_FILE"; then echo "$dest" >> "$EXCLUDE_FILE"; fi
      fi
    else
      echo "   ⏩ Skipping $dest (already exists)"
    fi
  else
    if [ "$STEALTH_MODE" = true ] && [ -f "$dest" ]; then
      echo "   🛡️  Stealth Mode: Skipping $dest (already exists) to avoid dirtying tracked files."
    else
      echo "   📥 Syncing $dest..."
      curl -s "$REPO_URL/$source" > "$dest"
      if [ "$STEALTH_MODE" = true ]; then
        if ! grep -q "^$dest$" "$EXCLUDE_FILE"; then echo "$dest" >> "$EXCLUDE_FILE"; fi
      fi
    fi
  fi
done < "$TMP_REGISTRY"

# 5. IDE adapters (skip entirely in stealth — see 5a for stealth alternative)
if [ "$STEALTH_MODE" = true ]; then
  echo "🥷 Stealth: skipping IDE adapter creation (no files outside .agenticguild/)."
  # Write canonical rules and paste-in pointer under .agenticguild/ only
  echo "   📥 Writing .agenticguild/AGENTIC_GUILD_RULES.md..."
  curl -s "$REPO_URL/templates/core/AGENTIC_GUILD_RULES.md" > .agenticguild/AGENTIC_GUILD_RULES.md
  if [ -s .agenticguild/AGENTIC_GUILD_RULES.md ]; then
    {
      echo "Paste this line into your IDE's rules / custom instructions (once) to enable agentic:guild:"
      echo ""
      echo "Read and follow the instructions in .agenticguild/AGENTIC_GUILD_RULES.md before answering or generating code. Skills at docs/ai/skills/<skill-name>/SKILL.md (or see SKILLS.md in project root)."
      echo ""
    } > .agenticguild/PASTE_INTO_IDE.txt
    echo "   📄 See .agenticguild/PASTE_INTO_IDE.txt for the one-line pointer to paste into your IDE."
  fi
else
  echo "⚙️  Configuring IDE adapters (from Adapter Registry)..."
  THIN_ADAPTER=$(curl -s "$REPO_URL/templates/core/AGENTIC_GUILD_ADAPTER.md")
  if [ -n "$THIN_ADAPTER" ]; then
    curl -s "$ADAPTER_REGISTRY_URL" > "$TMP_ADAPTER_REGISTRY"
    in_block=false
    while IFS= read -r line; do
      if [[ "$line" == *"ADAPTER_REGISTRY [START]"* ]]; then in_block=true; continue; fi
      if [[ "$line" == *"ADAPTER_REGISTRY [END]"* ]]; then in_block=false; continue; fi
      if ! $in_block; then continue; fi
      [[ "$line" != \|* ]] && continue
      [[ "$line" == *"Adapter path"* ]] && continue
      [[ "$line" == *"---"* ]] && continue
      IFS='|' read -r _ adapter_path _ <<< "$line"
      adapter_path=$(echo "$adapter_path" | xargs)
      [ -z "$adapter_path" ] && continue
      parent_dir=$(dirname "$adapter_path")
      [ -n "$parent_dir" ] && [ "$parent_dir" != "." ] && ensure_dir "$parent_dir"
      if [ ! -f "$adapter_path" ]; then
        echo "   📄 Creating $adapter_path with thin adapter..."
        echo "$THIN_ADAPTER" > "$adapter_path"
      elif ! grep -q "agentic:guild \[START\]" "$adapter_path" 2>/dev/null; then
        echo "   ⚙️  Prepending thin adapter to $adapter_path..."
        { echo "$THIN_ADAPTER"; cat "$adapter_path"; } > "${adapter_path}.tmp" && mv "${adapter_path}.tmp" "$adapter_path"
      else
        echo "   ✅ Thin adapter already present in $adapter_path."
      fi
    done < "$TMP_ADAPTER_REGISTRY"
    rm -f "$TMP_ADAPTER_REGISTRY"
  else
    echo "   ⚠️  Failed to fetch thin adapter template. Skipping IDE adapter injection."
  fi
fi

# 5b. Optional: copy stack-specific rules (--stack=rails|django|react-native)
if [ -n "$STACK" ]; then
  echo "📚 Applying stack rules for: $STACK..."
  curl -s "$STACK_REGISTRY_URL" > "$TMP_STACK_REGISTRY"
  if [ ! -s "$TMP_STACK_REGISTRY" ]; then
    echo "   ❌ Failed to fetch STACK_REGISTRY. Cannot validate stack id."
    rm -f "$TMP_STACK_REGISTRY"
    exit 1
  fi
  valid_ids=""
  stack_template=""
  in_block=false
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
  if [ -z "$stack_template" ]; then
    echo "   ❌ Invalid --stack=$STACK. Valid stack ids: $valid_ids (see playbooks/STACK_REGISTRY.md)."
    rm -f "$TMP_STACK_REGISTRY"
    exit 1
  fi
  rm -f "$TMP_STACK_REGISTRY"
  ensure_dir docs/ai
  STACK_RULES=$(curl -s "$REPO_URL/$stack_template")
  if [ -n "$STACK_RULES" ]; then
    echo "   📥 Writing docs/ai/STACK_RULES.md from $stack_template..."
    echo "$STACK_RULES" > docs/ai/STACK_RULES.md
  else
    echo "   ⚠️  Failed to fetch stack template: $stack_template"
    exit 1
  fi
fi

# 7. Git Hook Installation
if [ "$STEALTH_MODE" = true ]; then
  echo "⚓ Skipping Git Hook installation in stealth mode to avoid disrupting team workflows."
else
  echo "⚓ Installing Git Hooks..."
  PRE_COMMIT_LOGIC=$(curl -s "$REPO_URL/templates/git-hooks/pre-commit-logic.sh")
  if [ -n "$PRE_COMMIT_LOGIC" ]; then
    HOOK_FILE=".git/hooks/pre-commit"
    if [ -f "$HOOK_FILE" ]; then
      if ! grep -q "AGENTIC-GUILD PRE-COMMIT" "$HOOK_FILE"; then
        echo "   📝 Appending safety check to existing pre-commit hook..."
        echo "$PRE_COMMIT_LOGIC" >> "$HOOK_FILE"
      else
        echo "   ✅ agentic:guild pre-commit hook already present."
      fi
    else
      if [ -d ".git/hooks" ]; then
        echo "   🆕 Creating new pre-commit hook..."
        { echo "#!/bin/bash"; echo "$PRE_COMMIT_LOGIC"; } > "$HOOK_FILE"
        chmod +x "$HOOK_FILE"
      else
        echo "   ⚠️  .git/hooks directory not found. Are you in the root of a git repository?"
      fi
    fi
  else
    echo "   ⚠️  Failed to fetch pre-commit hook logic. Skipping git hook installation."
  fi
fi

# Cleanup
rm -f "$TMP_REGISTRY"

echo "🚀 Sync complete. agentic:guild Operating System is online."
echo ""
echo "✅ agentic:guild installed."
if [ "$STEALTH_MODE" = true ]; then
  echo "🥷 Stealth: no adapter files were created. Add the line from .agenticguild/PASTE_INTO_IDE.txt to your IDE's rules (once) to enable agentic:guild."
  echo "Then ask: \"Who are you?\" or \"What is agentic:guild?\""
else
  echo "To see your new engineer in action, type this into your AI assistant right now:"
  echo "  \"Who are you?\" or \"What is agentic:guild?\""
  if [ -z "$STACK" ]; then
    echo ""
    echo "Optional: run with --stack=rails, --stack=django, or --stack=react-native to add stack-specific rules to docs/ai/STACK_RULES.md."
  fi
fi
