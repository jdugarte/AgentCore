<agentcore_skill>
  <skill_definition>
    <name>roadmap-consult</name>
    <description>Read-only view of the project roadmap: what's done, what's pending, priorities, phases.</description>
  </skill_definition>

  <state_machine_directives>
    1. NEVER modify the roadmap during this skill.
    2. Your ONLY job is to read and report.
  </state_machine_directives>

  <pre_flight>
    <directive>Verify the roadmap exists.</directive>
    <check>If `docs/ROADMAP.md` does not exist, inform the user and suggest running sync.sh or roadmap-manage to create it.</check>
  </pre_flight>

  <workflow>
    <phase id="1" name="Report">
      <step id="1.1">
        <action>
          Read `docs/ROADMAP.md`. Output a summary: count of items Done, In Progress, Pending, Backlog; list the top priorities; and optionally search/filter by the user's question (e.g. "what's blocking?", "what's next?", "show pending by priority").
        </action>
        <yield>[PAUSE - ROADMAP CONSULT COMPLETE]</yield>
      </step>
    </phase>
  </workflow>
</agentcore_skill>
