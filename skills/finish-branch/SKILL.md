<agentcore_skill>
  <skill_definition>
    <name>finish-branch</name>
    <description>Handles the completion of a branch, PR creation, and continuous CI/Bot feedback loops.</description>
  </skill_definition>

  <state_machine_directives>
    1. NEVER execute more than ONE <step> per response.
    2. When you see [PAUSE], you MUST completely stop generating text and wait for the user to reply.
    3. CYCLIC EXECUTION: You are permitted to loop backward between steps if the workflow dictates it.
  </state_machine_directives>

  <pre_flight>
    <directive>Before executing the workflow, verify the necessary context exists.</directive>
    <check>Verify `docs/core/deterministic_coding_standards.md`, `docs/core/SYSTEM_ARCHITECTURE.md`, and `docs/core/SPEC.md` exist.</check>
    <action>If they are missing, abort the skill and point the user to `docs/ai/EXPECTED_PROJECT_STRUCTURE.md`. Do NOT hallucinate their contents.</action>
  </pre_flight>

  <workflow>
    <phase id="1" name="Interactive Local Review">
      <step id="1.1">
        <action>Trigger the `code-review` skill. Wait for its internal loop to conclude.</action>
        <yield>[PAUSE - AWAIT CODE REVIEW COMPLETION]</yield>
      </step>
    </phase>

    <phase id="2" name="Compliance & Traceability Audit">
      <step id="2.1">
        <action>
          Read `docs/core/deterministic_coding_standards.md`.
          Analyze the branch to ensure no cyclomatic complexity or function length violations occurred.
          Scan all new tests for `[REQ-ID]` tags referencing `docs/core/SPEC.md`.
        </action>
        <yield>[PAUSE - REPORT FINDINGS. AWAIT COMMAND TO FIX OR PROCEED]</yield>
      </step>
    </phase>

    <phase id="3" name="Remote Async Review (The BugBot Loop)">
      <step id="3.1">
        <action>
          Instruct the user to commit their code, push to the remote branch, and wait for CI/BugBot feedback.
          Update `.agentcore/current_state.md` to indicate waiting status.
        </action>
        <yield>
          [PAUSE - AWAIT BUGBOT STATUS]
          Tell the user: "Paste any BugBot errors here, or reply 'BUGBOT IS HAPPY' if CI is green."
        </yield>
      </step>
      <step id="3.2">
        <action>
          Evaluate the user's input from Step 3.1:
          - If they pasted BugBot errors: Analyze the errors, write the fixes, and run local tests.
          - If they replied "BUGBOT IS HAPPY": Skip any fixes.
        </action>
        <yield>
          [PAUSE - AWAIT COMMAND]
          If fixes were applied: "I have applied the BugBot fixes. I am looping back to Phase 3, Step 3.1." (Silently update state to 3.1).
          If BUGBOT IS HAPPY: "CI is green. Reply PROCEED to begin Phase 4."
        </yield>
      </step>
    </phase>

    <phase id="4" name="Final Spackle & PR">
      <step id="4.1">
        <action>Trigger `sync-schema-docs` if the database was modified.</action>
        <yield>[PAUSE - AWAIT CONFIRMATION TO PROCEED]</yield>
      </step>
      <step id="4.2">
        <action>Trigger `harvest-rules` to identify new patterns.</action>
        <yield>[PAUSE - AWAIT CONFIRMATION TO PROCEED]</yield>
      </step>
      <step id="4.3">
        <action>Trigger `pr-description-clipboard`.</action>
        <yield>[PAUSE - BRANCH IS FINISHED]</yield>
      </step>
    </phase>
  </workflow>
</agentcore_skill>
