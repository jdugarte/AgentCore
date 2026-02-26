<agentcore_skill>
  <skill_definition>
    <name>sync-docs</name>
    <description>Keeps project docs in sync with branch changes. Analyzes the diff against the docs-to-sync list, then applies all necessary updates in one batch.</description>
  </skill_definition>

  <state_machine_directives>
    1. NEVER execute more than ONE <step> per response.
    2. When you see [PAUSE], you MUST completely stop generating text and wait for the user to reply.
  </state_machine_directives>

  <pre_flight>
    <directive>Before executing the workflow, verify the necessary context exists.</directive>
    <check>Verify `docs/core/SYSTEM_ARCHITECTURE.md` and `docs/core/SPEC.md` exist.</check>
    <action>If they are missing, abort the skill and point the user to `docs/ai/EXPECTED_PROJECT_STRUCTURE.md`. Do NOT hallucinate their contents.</action>
  </pre_flight>

  <workflow>
    <phase id="1" name="Impact Analysis">
      <step id="1.1">
        <action>
          Read the git diff of the current branch against the default branch (e.g. `main`).
          Read the "Docs to Sync" table in `docs/ai/EXPECTED_PROJECT_STRUCTURE.md` to get the list of docs and their update conditions.
          For each doc in the list that exists in the project: determine whether the branch changes require updates based on the condition.
          Output a report: [Doc] → [Needs update: Yes/No] + brief reason.
        </action>
        <yield>[PAUSE - AWAIT USER CONFIRMATION TO PROCEED OR SKIP]</yield>
      </step>
    </phase>

    <phase id="2" name="Apply Updates">
      <step id="2.1">
        <action>
          For each doc that needs updates, apply the changes in a single batch:
          - **SCHEMA_REFERENCE.md**: Read the raw schema file (path from EXPECTED_PROJECT_STRUCTURE or infer), map to SPEC.md, generate/overwrite.
          - **SPEC.md**: Update domain logic, entities, glossary, or REQ-IDs as implied by the diff.
          - **DATA_FLOW_MAP.md**: Update entity lifecycles or side-effects.
          - **ADRs/**: Add or update ADRs for new architectural decisions.
          - **SYSTEM_ARCHITECTURE.md**: Update stack, boundaries, or forbidden libs.
          Output a summary of what was updated.
          Remind the user: "To have more docs updated automatically, add them to the 'Docs to Sync' table in `docs/ai/EXPECTED_PROJECT_STRUCTURE.md`."
        </action>
        <yield>[PAUSE - DOCS SYNCED. ASK IF THEY WANT TO RUN HARVEST-RULES]</yield>
      </step>
    </phase>
  </workflow>
</agentcore_skill>
