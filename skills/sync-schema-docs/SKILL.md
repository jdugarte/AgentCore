---
name: sync-schema-docs
description: AI-driven workflow to automatically generate and maintain schema documentation (SCHEMA_REFERENCE.md) based on the project's database schema definitions (e.g., db/schema.rb, db/schema.ts, prisma/schema.prisma) and business logic from docs/core/SPEC.md. Use when the database schema changes.
---

# Sync Schema Docs Skill

## Required files / Pre-flight

Before running this skill, check that these exist:

- Your project’s database schema file (e.g. `db/schema.rb`, `db/schema.ts`, `prisma/schema.prisma`)
- `docs/core/SPEC.md` (business logic and domain glossary; required to map schema to semantics)

**If `docs/core/SPEC.md` is missing:** Do not guess business logic or invent semantics. Tell the user that this skill requires `docs/core/SPEC.md` and point them to the Expected Project Structure document (`docs/ai/EXPECTED_PROJECT_STRUCTURE.md` in your project after sync, or `playbooks/EXPECTED_PROJECT_STRUCTURE.md` in AgentCore) for how to create it. **If the user explicitly asks you to create it,** you may do so by following that document (e.g. create a minimal SPEC with placeholder sections for business logic and domain glossary; the user can fill in details). Do not generate `docs/core/SCHEMA_REFERENCE.md` until SPEC exists.

## Purpose
To maintain a bulletproof, auto-generating markdown file (`docs/core/SCHEMA_REFERENCE.md`) that explicitly maps the raw database tables/columns from `db/schema.ts` to their semantic business logic defined in `docs/core/SPEC.md`.

## Workflow
When this skill is triggered, you must perform the following algorithm exactly:

1. **Read the Source of Truth:**
   - Read `db/schema.ts` to get the current tables, columns, and types.
   - Read `docs/core/SPEC.md` to rehydrate your understanding of the application's business logic and domain glossary.

2. **Infer & Map Semantic Meaning:**
   - For every table and column in the schema, determine its purpose based on the `SPEC.md`.
   - **CRITICAL PAUSE:** If a column's purpose or business logic mapping is ambiguous, unclear, or not found in `SPEC.md`, you MUST pause and ask the user for clarification (e.g., *"What is the business logic/purpose behind the `price_source` column? I need this to complete the schema docs."*). Do not guess or hallucinate logic. Wait for their response.

3. **Generate `docs/core/SCHEMA_REFERENCE.md`:**
   - Once all semantics are clear, generate or overwrite `docs/core/SCHEMA_REFERENCE.md`.
   - Format the document with clear Markdown tables.
   - Each table section MUST include a markdown link pointing directly to the relevant H3 header in `docs/core/SPEC.md` if applicable.

### Markdown Output Format Template:
```markdown
# 📦 Table: [TableName]
*[1-sentence summary of the table's purpose]*
*🔗 Business Logic: [Link to docs/core/SPEC.md#header]*

| Column | Type | Semantic Business Logic |
|---|---|---|
| `id` | `text` | Primary Key |
| `column_name` | `real` | [Inferred semantic meaning confirmed by user/SPEC] |
```

4. **Confirm Update:**
   - Explicitly tell the user: *"I have finished updating `docs/core/SCHEMA_REFERENCE.md`. Please review the accuracy of the semantics, and commit the file when you are ready."* **CRITICAL RULE: NEVER commit or push changes on your own. At most, suggest a commit message for the uncommitted changes.**
