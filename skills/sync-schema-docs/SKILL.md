---
name: sync-schema-docs
description: AI-driven workflow to automatically generate and maintain schema documentation (SCHEMA_REFERENCE.md) based on Drizzle's db/schema.ts and business logic from docs/core/SPEC.md. Use when the database schema changes.
---

# Sync Schema Docs Skill

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
   - Explicitly tell the user: *"I have finished updating `docs/core/SCHEMA_REFERENCE.md`. Please review the accuracy of the semantics, and commit the file when you are ready."* Do NOT commit it for them.
