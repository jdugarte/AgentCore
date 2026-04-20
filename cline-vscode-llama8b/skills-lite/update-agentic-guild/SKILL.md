# update-agentic-guild (lite — Cline / Llama 8B)

Prefer **`sync.sh`** from a shell when possible — less error-prone on 8B.

## Rules

- **One step per reply.**
- No `git commit` / `git push` / `git merge`.

## Step 1 — Safety

Check for uncommitted changes under `docs/ai/`, `docs/core/`, `skills/`, `.cursorrules`. If dirty, stop: user should stash/commit first. `[PAUSE]`

## Step 2 — Fetch

Remove stale `.agenticguild/tmp_update` if present. Run:  
`git clone --depth 1 https://github.com/jdugarte/agentic-guild.git .agenticguild/tmp_update`  
Tell user when clone done. `[PAUSE]`

## Step 3 — Merge (manual discipline)

Compare `tmp_update` with project: skills, templates, playbooks. **One directory at a time** — propose copy list; wait for user “yes” before overwriting. Track conflicts in a short list; resolve in a later reply. `[PAUSE]`

## Step 4 — Cleanup

After success: remove `tmp_update` (or keep until user confirms). Suggest commit message for any updated files. `[PAUSE]`

**Note:** Full upstream skill has more phases; on 8B, **stopping after each file group** avoids context loss.
