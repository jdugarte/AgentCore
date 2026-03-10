# Stack-specific rules (generic naming)

Stack rules are **generic** files named `STACK_RULES.md`, not IDE-specific names like `.cursorrules`. Each stack (Rails, Django, React Native) has one template that can be copied into a project when the user runs `sync.sh --stack=<id>`.

- **rails** — `templates/stacks/rails/STACK_RULES.md`
- **django** — `templates/stacks/django/STACK_RULES.md`
- **react-native** — `templates/stacks/react-native/STACK_RULES.md`

The list of stacks and their upstream paths is in **`playbooks/STACK_REGISTRY.md`**. Add or change stacks there; sync.sh uses it to copy the right template to `docs/ai/STACK_RULES.md` in the project.

Previously these lived as `templates/rails/.cursorrules`, `templates/django/.cursorrules`, and `templates/react-native/.cursorrules`; they have been renamed and moved here for IDE-agnostic naming.
