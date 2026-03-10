# Agnostic agentic:guild — Cross-IDE analysis and feasibility

This document synthesizes three conversations (Antigravity/agentic IDE, Gemini, ChatGPT) about making agentic:guild work the same across agentic IDEs. It separates what is feasible from what is not, and recommends a path that fits your goals.

---

## 1. What each conversation concluded

### 1.1 Antigravity / agentic IDE conversation

**Root cause of “skills not found”**

- Antigravity’s built-in “skills” text does **not** define where to look for `SKILL.md`. It says “find the SKILL.md” without a path.
- The agent mixed up **workflows** (`{.agents,.agent,_agents,_agent}/workflows/`) with **skills** (`.cursor/skills/`), searched the wrong place, and concluded skills didn’t exist. So: **skills discovery gap**, not an Antigravity regression.

**Fixes applied**

- `SKILLS.md` at project root as a discoverable index.
- `AGENTIC_GUILD_RULES.md` updated with explicit skills path and “don’t confuse with workflows”.
- SYNC_REGISTRY updated so `SKILLS.md` is deployed.

**Later direction (own structure + stealth)**

- You can use **your own** folder structure; IDEs don’t have to natively “run” skills — the agent just needs to be **told** where to look (via text it reads).
- Proposed: **one canonical home** (e.g. `docs/ai/skills/` or `.agenticguild/skills/`) and **thin per-IDE adapter files** that point to it.
- **AGENTS.md** was presented as the “universal pointer” that many IDEs read.
- Stealth: keep agentic:guild **out of the repo** (opt-in install, `sync.sh`), use **`.git/info/exclude`** (not `.gitignore`) for adapter files so the repo stays unaware.

**Tension**

- Putting skills in **`.agenticguild/`** (gitignored/excluded) means: one home, clean repo, but every dev (and CI) must run `sync.sh`; skills are only found if the agent **reads an adapter first** (e.g. AGENTS.md, .cursor rules).

---

### 1.2 Gemini conversation

**Verdict**

- The “hub and spoke” design (one canonical location + thin adapters) is **sound and enterprise-grade**.
- **AGENTS.md** as universal pointer is endorsed; tools that don’t exist yet may still support it.
- **`.git/info/exclude`** for stealth is called “the most elegant part” — local, invisible to the team.

**“Can it be truly agnostic?”**

- **Yes**, in this sense: agents are LLMs reading text; if they read an adapter that says “skills are at `.agenticguild/skills/<name>/SKILL.md`”, they can follow that path. The IDE doesn’t need to natively understand the layout.

**Implementation advice**

- **Idempotency**: injection into existing files (e.g. AGENTS.md) must be idempotent (check for existing block before adding).
- **Eject path**: when the whole team adopts agentic:guild and wants to version skills, support moving skills from `.agenticguild/skills/` to something like `docs/ai/skills/` and updating pointers.
- **OS compatibility**: `sync.sh` should avoid GNU-only `sed`/`awk` so it works on macOS (BSD) and Linux.

---

### 1.3 ChatGPT conversation

**What it agreed with**

- Core idea (agentic:guild outside repo, `.agenticguild/`, adapters pointing to it, install via script) **can work**.
- Thin adapter files (e.g. `.cursor/rules/agentic.mdc`, `.windsurf/rules/agentic.md`, CLAUDE.md, AGENTS.md) with a short “skills live at X” blurb are a **good long-term strategy**.
- Using **`.git/info/exclude`** instead of `.gitignore` for locally-created adapter files is **correct** (repo stays unaware).

**Where it pushed back**

1. **“AGENTS.md is a universal standard that all IDEs read”**  
   ChatGPT said this is **not guaranteed**. Its table:
   - Cursor: **sometimes**
   - Windsurf: **yes**
   - Copilot: **sometimes**
   - Claude Code: **no** (uses CLAUDE.md)
   - Antigravity: **unknown / not guaranteed**
   - Cline: **not guaranteed**

2. **Discovery is heuristic, not standardized**  
   Agents often **search the filesystem** for names like AGENTS.md, CLAUDE.md, README.md, `docs/`, `.ai/`, `agents/`, `skills/`. They don’t strictly follow a single standard.

3. **Skills in `.agenticguild/` (ignored/excluded) = discovery risk**  
   Many agents **scan the repo** but **do not scan ignored/excluded directories**. So:
   - If skills live only in `.agenticguild/skills/`, the agent may **never see them** unless it first reads a file that points there (e.g. AGENTS.md, .cursor rules).
   - If that file isn’t loaded or the agent doesn’t read it, **skills are never discovered**.

4. **ChatGPT’s recommended layout**  
   - **Canonical skills in repo**: `docs/ai/skills/<skill>/SKILL.md` (discoverable by heuristic scan).
   - **Runtime-only in `.agenticguild/`**: sessions, state, cache, config (untracked).
   - **AGENTS.md** (and other adapters) say: “Skills are stored in: `docs/ai/skills/<skill>/SKILL.md`.”
   - Result: agents can find skills by scanning **or** by reading the pointer; versioning and reproducibility are straightforward.

---

## 2. What “truly agnostic” can and cannot mean

### 2.1 What you cannot guarantee

- **Identical behavior in every IDE**  
  Each IDE decides what to load (`.cursorrules`, `.cursor/rules/`, AGENTS.md, CLAUDE.md, etc.), in what order, and whether the agent is instructed to read them. You can’t control that. So “behaves the same in every agentic IDE” in the strict sense is **not achievable** without every vendor adopting the same contract.

- **Universal discovery without pointers**  
  There is **no single, guaranteed** “all IDEs read this” file or folder. AGENTS.md is widely supported but not universal; Cursor is “sometimes”; Claude Code uses CLAUDE.md. So “one file that every IDE always loads” is **not** a safe assumption.

- **Invisible skills that every agent finds**  
  If skills live only in an ignored/excluded directory (e.g. `.agenticguild/skills/`), any agent that doesn’t read your pointer file(s) will not discover them. So “skills outside repo and always discovered” is **inconsistent** — you have to choose between “outside repo” and “discoverable by heuristic scan”.

### 2.2 What you can achieve

- **Same semantics, different entry points**  
  agentic:guild’s **behavior** (state machine, skills, memory, intent routing) can be the same everywhere. The **entry point** is what varies: Cursor gets it via `.cursor/rules/` or `.cursorrules`, Windsurf via `.windsurf/rules/` or AGENTS.md, Claude via CLAUDE.md, etc. So “same rules and skills, different adapter per IDE” is **feasible**.

- **Wide coverage via multiple pointers**  
  You can’t rely on one file alone, but you **can** put the same instructions in several places (AGENTS.md, CLAUDE.md, .cursor/rules/agentic.mdc, .windsurf/rules/agentic.md, etc.). Whichever file an IDE loads, the agent gets the same “where skills live” and “how to run agentic:guild” info. That’s **feasible** and improves the chance it works in many IDEs.

- **Discoverable skills when they’re in the tree**  
  If skills live in a **non-ignored** path that agents often scan (e.g. `docs/ai/skills/`, or a top-level `skills/`), many agents will find them even if they never read your pointer file. So “skills in repo at a common convention” is **feasible** and increases robustness.

- **Stealth for “install” and adapters**  
  You can keep **installation** and **adapter files** invisible to the repo using `.git/info/exclude` and inject-or-create logic in `sync.sh`. That’s **feasible** and matches your “repo stays clean, opt-in” goal.

---

## 3. Tension: stealth vs discoverability

| Goal | Skills in repo (e.g. `docs/ai/skills/`) | Skills outside repo (e.g. `.agenticguild/skills/`) |
|------|----------------------------------------|----------------------------------------------------|
| Repo has zero agentic:guild content | ❌ Skills are in tree | ✅ Only pointers/adapters, if any |
| Heuristic discovery (agent scans repo) | ✅ Agents often look in `docs/`, `skills/` | ❌ Ignored/excluded dirs often not scanned |
| No `sync.sh` required to have skills | ✅ Clone = skills present | ❌ Every dev (and CI) must run `sync.sh` |
| Team can version and customize skills | ✅ Normal git workflow | ⚠️ Only if you “eject” to a tracked path |
| Single canonical home for “everything” | ⚠️ Split: skills in repo, runtime in .agenticguild/ | ✅ One folder for skills + runtime |

So:

- **Maximum stealth** (nothing agentic in repo) ⇒ skills in `.agenticguild/` ⇒ discovery **depends entirely** on the agent reading an adapter (AGENTS.md, .cursor rules, etc.). If the IDE doesn’t load that file or the agent doesn’t read it, skills stay hidden.
- **Maximum discoverability** ⇒ skills in repo at something like `docs/ai/skills/` ⇒ agents can find them by scanning **or** by pointer. Stealth is reduced (skills are in the repo).

You have to choose the tradeoff; you can’t have both “skills never in repo” and “every agent finds them without reading our pointer.”

---

## 4. Feasibility by approach

### 4.1 Single universal file (e.g. “everyone reads AGENTS.md”)

- **Feasibility**: **Partial.**  
  AGENTS.md is read by many IDEs but not all (Cursor “sometimes”, Claude Code uses CLAUDE.md, Antigravity unknown). Relying on **only** AGENTS.md is fragile.

### 4.2 Multiple thin adapters (AGENTS.md + CLAUDE.md + .cursor/rules/ + .windsurf/rules/ + …)

- **Feasibility**: **High.**  
  Each IDE has a preferred file; you put a short pointer in each. Same text: “Skills at X. Run sync.sh if missing.” New IDE = one more small adapter. This is the **hub-and-spoke** model; all three conversations support it.

### 4.3 Skills in `.agenticguild/` only (fully outside repo)

- **Feasibility**: **Works only when the pointer is read.**  
  Discovery is **conditional**: the agent must load one of your adapter files. If it doesn’t (or the IDE doesn’t load it), skills are invisible. Fine for “opt-in, stealth” where you accept that some IDEs might not find skills until the user ensures the pointer is present.

### 4.4 Skills in repo at `docs/ai/skills/` (or similar)

- **Feasibility**: **High.**  
  Fits common heuristics (docs/, ai/, skills/). Works with or without pointer files. Aligns with ChatGPT’s “safest” layout and with the Antigravity thread’s “own structure” idea (you still own the layout; it’s just in-repo). Stealth is lower (skills are committed).

### 4.5 Hybrid: skills in repo + runtime in `.agenticguild/`

- **Feasibility**: **High.**  
  Skills: `docs/ai/skills/` (discoverable, versioned). Runtime: `.agenticguild/` (sessions, state, config — gitignored). Adapters point to `docs/ai/skills/`. You get discoverability, versioning, and a single “runtime” home; you give up “zero agentic content in repo.”

---

## 5. What makes sense and what doesn’t

**Makes sense**

- **Thin adapters per IDE** that only say where skills live and how to install. Maintainable and future-proof.
- **`.git/info/exclude`** for adapter files created by `sync.sh` so the repo doesn’t need to know about agentic:guild.
- **Inject-or-create** for adapters: if the file exists (e.g. AGENTS.md), inject a block; if not, create and exclude. Idempotent injection.
- **Explicit skills path and anti-confusion** in rules (e.g. “skills at X; do not use workflow paths for skills”). That’s what fixed the Antigravity confusion.
- **SKILLS.md** at project root as a fallback index so any agent that finds it can resolve skill paths.
- **Eject path**: when the team wants to adopt agentic:guild and version skills, move from `.agenticguild/skills/` to e.g. `docs/ai/skills/` and update pointers.

**Does not make sense (or is fragile)**

- **Relying on “AGENTS.md is universal.”** Treat it as one of several entry points, not the only one.
- **Assuming “same behavior in every IDE”** without per-IDE adapters. Behavior can be the same *given* the agent has read your rules; which file delivers those rules is IDE-dependent.
- **Expecting heuristic discovery of skills inside an ignored/excluded directory.** If it’s ignored, most agents won’t scan it; discovery then depends on pointer files.

---

## 6. How far you can take “agnostic agentic:guild”

**You can:**

1. **Define one canonical layout** (e.g. `docs/ai/skills/` in repo, or `.agenticguild/skills/` out of repo) and document it in AGENTIC_GUILD_RULES and SKILLS.md.
2. **Support many IDEs** via thin, per-IDE adapter files that point to that layout and mention `sync.sh` if needed.
3. **Keep installation and adapters stealthy** with `.git/info/exclude` and inject-or-create, so the repo stays clean for non-users.
4. **Get “same behavior” across IDEs** in the sense: once an agent has loaded your rules (from any adapter), the state machine, skills, and intent routing are the same.
5. **Improve robustness** by putting skills in a discoverable path (e.g. `docs/ai/skills/`) so agents can find them even when they don’t load your pointer file.

**You cannot:**

1. **Force every IDE to load the same file** or to “see” ignored/excluded directories.
2. **Guarantee identical behavior in every IDE** without each IDE exposing some way to load your instructions (hence the need for adapters).
3. **Have both “skills never in repo” and “agents always discover skills without reading our pointer.”** You choose stealth vs discoverability.

---

## 7. Recommended direction (synthesis)

- **Short term (current state)**  
  - Keep **SKILLS.md** and **AGENTIC_GUILD_RULES** with explicit path and anti-workflow confusion.  
  - Keep skills where they are today (e.g. `.cursor/skills/` in SYNC_REGISTRY) and ensure **all** references (including adapters) use that path until you decide to move.

- **If you want maximum discoverability and portability**  
  - Move **canonical skills** to **`docs/ai/skills/`** (in repo, versioned).  
  - Keep **runtime** in **`.agenticguild/`** (sessions, state, config — gitignored).  
  - Add **AGENTS.md** (and other adapters) that say: “Skills at `docs/ai/skills/<skill>/SKILL.md`.”  
  - Use **thin per-IDE adapters** (Cursor, Windsurf, Cline, CLAUDE.md, etc.) that point to the same path.  
  - Treat **AGENTS.md as one of several** entry points, not the only one.

- **If you want maximum stealth (nothing agentic in repo)**  
  - Put skills in **`.agenticguild/skills/`** and accept that **discovery depends on the agent reading an adapter**.  
  - Use **`.git/info/exclude`** for any adapter files created by `sync.sh`.  
  - Provide **multiple** adapters (AGENTS.md, CLAUDE.md, .cursor, .windsurf, …) to maximize the chance at least one is loaded.  
  - Plan an **eject** path to `docs/ai/skills/` when the team wants to version skills.

- **Implementation details (all three conversations)**  
  - **Idempotent** injection when merging into existing AGENTS.md / rules.  
  - **OS-safe** `sync.sh` (BSD and GNU).  
  - **Eject** command or playbook to move skills from `.agenticguild/skills/` to `docs/ai/skills/` and update pointers when the team adopts agentic:guild.

---

## 8. Summary table

| Question | Answer |
|----------|--------|
| Can agentic:guild behave the same in every agentic IDE? | **Yes**, for the part under your control: same rules and skills; **entry point** (which file is loaded) varies by IDE. |
| Is there a single file every IDE reads? | **No.** AGENTS.md is common but not universal; use multiple adapters. |
| Can we use our own folder structure? | **Yes.** Use one canonical path and point to it from every adapter. |
| Skills in repo vs outside repo? | **In repo** (e.g. `docs/ai/skills/`) = better discovery and versioning. **Outside** (`.agenticguild/skills/`) = stealth but discovery only via pointer. |
| Is the “thin adapters + one canonical location” design sound? | **Yes.** All three conversations support it. |
| Should we use .git/info/exclude for stealth? | **Yes.** For adapter files created by install; keeps repo unaware. |
| What’s the main risk of “skills outside repo”? | Agents that don’t read your pointer **never see** skills (ignored dirs often not scanned). |

This gives you a single reference to align implementation and docs with what’s actually feasible across IDEs.
