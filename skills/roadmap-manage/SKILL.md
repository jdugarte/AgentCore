<agentcore_skill>
  <skill_definition>
    <name>roadmap-manage</name>
    <description>Add, prioritize, catalog, and update items in the project roadmap.</description>
  </skill_definition>

  <state_machine_directives>
    1. NEVER execute more than ONE <step> per response.
    2. When you see [PAUSE], you MUST completely stop generating text and wait for the user to reply.
  </state_machine_directives>

  <pre_flight>
    <directive>Before executing the workflow, verify the necessary context exists.</directive>
    <check>Verify `docs/ROADMAP.md` exists. If not, inform the user and suggest running sync.sh to initialize it, or create a minimal structure with Done, In Progress, Pending, Backlog sections.</check>
  </pre_flight>

  <workflow>
    <phase id="1" name="Manage Roadmap">
      <step id="1.1">
        <action>
          Read `docs/ROADMAP.md`. Ask the user what they want to do: add an item, prioritize/reorder items, move an item (e.g. Pending → In Progress, or Done), catalog by phase/category, or something else.
        </action>
        <yield>[PAUSE - AWAIT USER INTENT]</yield>
      </step>
      <step id="1.2">
        <action>
          Execute the user's request. Update `docs/ROADMAP.md` accordingly. Follow the format: `[x]` for done, `[ ]` for pending; `(REQ-ID)` for SPEC links; `— YYYY-MM-DD` for done date; `— Branch: name` for in-progress; `— Depends on: Item` for dependencies.
          Output the updated roadmap or a summary of changes.
        </action>
        <yield>[PAUSE - ROADMAP UPDATED. SKILL COMPLETE]</yield>
      </step>
    </phase>
  </workflow>
</agentcore_skill>
