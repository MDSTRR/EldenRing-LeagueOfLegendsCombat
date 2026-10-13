# Codex Handoff 004 — Analyze Decompiled Godrick Soldier AI

**Status: Completed — research/documentation, 2026-10-13.** See `docs/analysis/GODRICK_SOLDIER_AI.md` and current `agent/STATE.md`. Original assignment retained below. No implementation/repack/deployment occurred; first experiment awaits authorization and prerequisite checks.

## Project context

We are developing an Elden Ring mod that aims to implement League of Legends-style movement and combat.

The long-term goal is to control an NPC through mouse commands rather than directly controlling Elden Ring's player character.

Our initial NPC is a Godrick Soldier (`c4311`), and our first technical milestone is:

**Make the NPC move to a predetermined location using Elden Ring's existing AI movement and navigation systems.**

Mouse input, dynamic destinations, attacks, camera behavior, and full MOBA controls come later.

## Current progress

We have successfully:

1. Installed and configured Smithbox, WitchyBND, DSLuaDecompiler, and ModEngine 2.
2. Unpacked Elden Ring's game resources.
3. Identified an NPC instance in Smithbox:
   - Map: `m18_00_00_00`
   - NPC instance: `c4311_9007`
   - Entity ID: `18000257`
   - NPC Think Param ID: `43114006`
   - Battle Goal ID: `431030`
   - Logic ID: `10000`
4. Extracted `431030_battle.luabnd.dcx` using WitchyBND.
5. Successfully decompiled its Lua bytecode into readable Lua.

The NPC instance has not yet been conclusively verified as the Soldier of Godrick tutorial boss.

## Available resources

Start by inspecting the repository structure and reading:

- `AGENTS.md`
- `user/VISION.md`
- `user/REQUIREMENTS.md`
- `user/DECISIONS.md`
- `agent/STATE.md`
- `agent/RESEARCH.md`, if present
- `agent/PROGRESS.md`
- `agent/BLOCKERS.md`
- `docs/api/INDEX.md`
- Existing research and extraction documentation

The primary source for this task is:

`TestingAI/decompiled/431030_battle.lua`

If the file is located elsewhere, discover its actual path rather than assuming it is missing.

Other potentially relevant resources include:

- `010000_logic.luabnd.dcx`
- `aicommon.luabnd.dcx`
- Decompiled or extracted versions of those archives, if available
- Existing documentation about Elden Ring AI goals

Do not attempt to read the Steam game installation. You only have access to files provided inside the repository.

## Assignment 1 — Analyze the battle AI

Read the complete `431030_battle.lua` file.

Explain its architecture, including:

- `RegisterTableGoal`
- `REGISTER_GOAL_NO_SUB_GOAL`
- `Goal.Initialize`
- `Goal.Activate`
- `Goal.Update`
- `Goal.Terminate`
- `Goal.Interrupt`
- `Common_Battle_Activate`
- `REGIST_FUNC`
- `AddSubGoal`

Determine how the NPC selects actions, executes movement, performs attacks, and responds to interruptions.

Explain how the action-weight tables work, including the distinction between the action weights and the registered action functions.

Document the control flow from `Goal.Activate` to an individual movement action.

Do not assume every function or parameter is understood. Distinguish confirmed behavior from interpretation.

## Assignment 2 — Catalog movement and combat actions

Identify every movement-related function in the decompiled battle AI.

Pay particular attention to:

- `GOAL_COMMON_ApproachTarget`
- `GOAL_COMMON_SidewayMove`
- `GOAL_COMMON_LeaveTarget`
- `GOAL_COMMON_Turn`
- `Approach_Act_Flex`

Also identify attack-related goals and their relationships to movement.

For each relevant action, document:

1. The function or goal name.
2. Where it is called.
3. The arguments passed.
4. The apparent purpose of each argument.
5. Whether it operates relative to a target, position, or direction.
6. Whether its implementation is local or supplied by shared AI code.
7. Any unresolved questions.

Do not invent argument meanings. Consult existing API documentation or reliable references where necessary.

## Assignment 3 — Investigate navigation possibilities

Our primary technical question is:

**Can we command this NPC to navigate to an arbitrary world-space destination using its existing AI system?**

Investigate these candidates:

- `GOAL_COMMON_MoveToSomewhere`
- `GOAL_COMMON_MoveFollowPathSpecifyPos`
- `SetEventMoveTarget`
- `SetAIFixedMoveTarget`
- `POINT_EVENT`
- `POINT_AI_FIXED_POS`
- `AiFunc::FollowPath`

Determine which are:

- Confirmed in our extracted code.
- Documented in external reference material.
- Plausible but unverified.
- Unsuitable for our use case.

Pay particular attention to whether a destination can be changed without requiring a new map region, target entity, or full AI reload.

Distinguish pathfinding from simple straight-line movement.

If the available files cannot establish an answer, identify the precise missing evidence.

## Assignment 4 — Recommend the first experiment

Propose the smallest feasible experiment that would make the NPC walk or run to a fixed destination.

Compare at least two possible approaches, such as:

- An existing target-based movement goal.
- A region or point-based movement goal.

Choose one approach based on available evidence, implementation complexity, and likelihood of working.

Describe:

- Which Lua function would need modification.
- Which resource archive would need repacking.
- Whether Smithbox changes are required.
- How the modified resource would be loaded through ModEngine 2.
- What visible behavior would count as success.
- What failures would tell us about the AI system.
- How to revert the experiment safely.

Treat the deployment procedure as provisional until verified.

**Do not implement or repack anything yet.** This task ends with a concrete experiment proposal.

## Assignment 5 — Maintain documentation

Update the existing agent-owned documentation as appropriate:

- `agent/STATE.md`
- `agent/RESEARCH.md`
- `agent/PROGRESS.md`
- `agent/BLOCKERS.md`
- `docs/api/INDEX.md`
- Relevant files under `docs/api/`

Create a dedicated analysis document if helpful, for example:

`docs/analysis/GODRICK_SOLDIER_AI.md`

The analysis should include:

- An architecture overview.
- A readable execution-flow diagram, using Mermaid if useful.
- A table of relevant AI goals and functions.
- File and line references.
- Confirmed findings.
- Open questions.
- Recommended first experiment.

Reuse existing documentation rather than creating redundant files.

Do not modify user-owned documents under `user/` or change `AGENTS.md`.

## Constraints

- Research and documentation only.
- Do not modify any extracted or decompiled game resources.
- Do not edit or access the Steam installation.
- Do not install additional tools without asking.
- Do not implement mouse input, camera control, or combat overrides.
- Do not claim that pathfinding or coordinate movement works until verified.
- Preserve existing repository structure and Git ignore rules.
- Cite file paths and line numbers for code-derived conclusions.
- Clearly separate observations, inferences, and hypotheses.

## Final response

When finished, report:

1. What the Godrick Soldier's AI currently does.
2. How its movement actions work.
3. Whether there is evidence for arbitrary destination navigation.
4. The recommended first experiment and why.
5. Which files were updated.
6. What requires further verification.

End with a short, actionable handoff for the next Codex session, focused exclusively on implementing and testing the first fixed-destination movement experiment.

Do not begin that implementation in this session.
