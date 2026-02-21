
# --- AGENTCORE PR DRAFT PROTECTION START ---
# Prevent accidental commitment of AI-generated PR drafts.
if git diff --cached --name-only | grep -q ".cursor/pr-draft.md"; then
  echo "❌ ERROR: You are trying to commit '.cursor/pr-draft.md'."
  echo "This file is a temporary AI draft and should not be committed."
  echo "Please unstage it: git restore --staged .cursor/pr-draft.md"
  exit 1
fi
# --- AGENTCORE PR DRAFT PROTECTION END ---
