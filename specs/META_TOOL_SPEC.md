# Meta-Tool Specification (`ai-tools`)

**Goal:** Build a Homebrew-distributable CLI utility written in Go (Golang) to initialize, manage, and upgrade AI Agent capabilities across multiple development projects with varying tech stacks (Rails, Django, React Native, Go).

## Why Go?
1. Single executable binary, zero dependencies for the user.
2. Cross-platform compilation (macOS/Linux).
3. Easily distributed via Homebrew (`brew tap jesus/ai-tools && brew install ai-tools`).
4. Great CLI ecosystem (`Cobra` framework).

## CLI Architecture

The CLI acts as a bridge between the Local Project and the "Global Brain" (this AgentCore repository).

### 1. `ai-tools init <stack>`
**E.g., `ai-tools init django`**
- Checks if a `.cursor/skills` folder exists, creates it if not.
- Downloads the **Universal Playbooks** into `docs/ai/`.
- Downloads the **Universal Skills** into `.cursor/skills/`.
- Downloads the Stack-Specific starting template from `AgentCore/templates/django/.cursorrules` to the project root.
- Leaves an `.ai-version` tracking file in the project directory.

### 2. `ai-tools status`
- Reaches out to the GitHub REST API or parses the `main` branch of `AgentCore`.
- Compares the active project's `.ai-version` against the Global Brain latest version.
- Prints a changelog of what has evolved in the Universal Skills (e.g., "status-check now includes E2E test tracking").

### 3. `ai-tools update`
- Re-downloads the **Universal Skills** and **Universal Playbooks**.
- *Critically:* Does NOT touch the project's local `.cursorrules`, so project-specific fuel is never lost.
- Updates the local `.ai-version`.

## Go Development Roadmap
1. Set up a `main.go` using `spf13/cobra`.
2. Write an `init` command that uses Go's `net/http` outputting to local disk.
3. Test locally against a dummy Django project.
4. Implement `goreleaser` to build distributions for macOS and automatically generate a Homebrew Formula in a `homebrew-ai-tools` tap.
5. Upgrade the `sync.sh` script currently being used to instead recommend `brew install ai-tools`.
