# Meta-Tool Specification: `ai-tools`

**Goal:** Build a Homebrew-distributable CLI utility written in Go (Golang) to initialize, manage, and upgrade AI Agent capabilities across multiple development projects.

## Why Go?
1. **Zero Dependencies**: Single executable binary for the end user.
2. **Cross-Platform**: Easy compilation for macOS and Linux.
3. **Ecosystem**: Robust CLI support via `Cobra` and automated releases via `GoReleaser`.

## CLI Architecture

The CLI acts as a bridge between Local Projects and the AgentCore "Global Brain."

### 1. `ai-tools init <stack>`
Initialization process for new or existing projects.
- Creates `.cursor/skills/` and `docs/ai/` structures.
- Downloads **Universal Playbooks** and **Skills**.
- Deploys stack-specific `.cursorrules` templates.
- Links the project to the `AgentCore` versioning system.

### 2. `ai-tools status`
Ecosystem health check.
- Compares local skill versions against the latest Global Brain version.
- Displays a changelog of available improvements and protocol shifts.

### 3. `ai-tools update`
Non-destructive synchronization.
- Updates **Universal Skills** and **Playbooks**.
- **Crucial Rule:** Does *not* overwrite project-specific customizations in local documentation or rules.

## Development Roadmap

1. **Skeleton**: Setup `main.go` using `spf13/cobra`.
2. **Connectivity**: Implement `init` using Go's `net/http` to fetch from the master repository.
3. **Verification**: Test against various project stacks (Rails, Django, Go).
4. **Distribution**: Configure `goreleaser` for macOS/Linux builds and Homebrew Tap generation.
5. **Transition**: Upgrade the current `sync.sh` to recommend migrating to the Go-based CLI.
