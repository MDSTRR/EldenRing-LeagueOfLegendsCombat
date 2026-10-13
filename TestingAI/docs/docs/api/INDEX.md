# API Reference Index

## Technical Knowledge Management

The `docs/api/` directory is the project's reusable technical reference library.

When discovering an Elden Ring function, AI goal, event instruction, or constant:

1. Record investigation details and evidence in `agent/RESEARCH.md`.
2. Add reusable function documentation to the appropriate file under `docs/api/`.
3. Record the exact name, signature, parameters, purpose, usage examples, source references, and verification status.
4. Clearly distinguish documented behavior from hypotheses and locally verified behavior.
5. Never invent undocumented parameters, default values, or function signatures.
6. Cross-reference related functions and constants where relevant.
7. Update `docs/api/INDEX.md` when adding a new function.
8. Do not duplicate existing entries. Update them with new evidence instead.
9. Do not treat the existence of a documented function as proof that it works in the current Elden Ring build.

Before researching a function, check `docs/api/INDEX.md` to determine whether it has already been documented.

Read only the API reference files relevant to the current assignment. Do not load the entire reference library at every session startup.

## Library conventions

Paths above are relative to `TestingAI/docs/`, the project's documentation root. This index is `TestingAI/docs/docs/api/INDEX.md` in the repository.

- **Documented:** supported by the cited community reference or source example, with game provenance identified.
- **Hypothesis/inference:** plausible interpretation requiring further evidence.
- **Locally verified:** reproduced in this project with build, procedure and outcome recorded. No current entries have this status.

Last updated: 2026-10-13, Handoff004. Battle Lua text and manifest are now available and inspected. Sources do not specify a tested Elden Ring build; no behavior is verified in-game. Parameter disagreements and older-game examples remain explicit. “Observed locally” identifies supplied decompiled text evidence, distinct from runtime verification.

## AI goals

| Exact name | Reference | Current evidence |
|---|---|---|
| GOAL_COMMON_MoveToSomewhere | [Movement goals](ai-goals.md#goal_common_movetosomewhere) | Documented target-based pathing; no local test |
| GOAL_COMMON_MoveFollowPathSpecifyPos | [Movement goals](ai-goals.md#goal_common_movefollowpathspecifypos) | Documented coordinate slots; behavior unresolved |
| GOAL_COMMON_ApproachTarget, GOAL_COMMON_SidewayMove, GOAL_COMMON_LeaveTarget, GOAL_COMMON_Turn | [Observed target goals](ai-goals.md#target-relative-goals-observed-in-431030) | Exact call sites in431030; runtime behavior untested |
| GOAL_COMMON_ComboTunable_SuccessAngle180, GOAL_COMMON_ComboRepeat, GOAL_COMMON_ComboAttackTunableSpin, GOAL_COMMON_AttackTunableSpin, GOAL_COMMON_ComboRepeat_SuccessAngle180 | [Observed attack goals](ai-goals.md#attack-goals-observed-in-431030) | Catalog only; no combat implementation |

## Related AI functions

| Exact name | Reference | Current evidence |
|---|---|---|
| SetEventMoveTarget | [Point setup](ai-functions.md#seteventmovetarget) | Documented assignment of POINT_EVENT to a region |
| SetAIFixedMoveTarget | [Point setup](ai-functions.md#setaifixedmovetarget) | Documented assignment of a target-relative fixed point |
| FollowPath | [Pathing](ai-functions.md#followpath) | Documented pathing operation used by MoveToSomewhere |
| AddSubGoal | [Goal queue](ai-functions.md#addsubgoal) | Documented ER declaration; no local test |
| RegisterTableGoal, REGISTER_GOAL_NO_SUB_GOAL, REGIST_FUNC, Common_Battle_Activate, Approach_Act_Flex, ClearSubGoal, SetTargetRange | [Dispatch helpers](ai-functions.md#battle-dispatch-and-registration-helpers) | Observed calls and external definitions distinguished |

## AI resource and configuration references

| Exact name | Reference | Current evidence |
|---|---|---|
| NpcThinkParam.logicId | [Logic selection](ai-resources.md#npcthinkparamlogicid) | Locally inspected ER schema; selected row value user-reported |
| NpcThinkParam.battleGoalID | [Battle selection](ai-resources.md#npcthinkparambattlegoalid) | User-reported431030; binder/text independently inspected |
| common10000_Logic, common10000_Interupt | [Published example](ai-resources.md#common10000_logic--common10000_interupt) | Public ER-oriented Lua source; installed registration unverified |

[Resource organization](ai-resources.md) and [manual extraction instructions](../AI_EXTRACTION.md) cover the archive trace. The workspace tool dictionary is reference metadata, not local game-behavior verification.

## Constants

| Exact names | Reference | Current evidence |
|---|---|---|
| TARGET_ENE_0, TARGET_SELF, TARGET_FRI_0 | [Targets](ai-targets.md#character-targets) | Shared TARGET enum; goal-specific compatibility not guaranteed |
| TARGET_LOCALPLAYER, TARGET_HOSTPLAYER, TARGET_EVENT | [Targets](ai-targets.md#character-targets) | Shared TARGET enum; TARGET_EVENT differs from POINT_EVENT |
| POINT_INITIAL, POINT_EVENT, POINT_MOVE_POINT, POINT_AI_FIXED_POS | [Points](ai-targets.md#point-targets) | Shared TARGET enum; setup and older-game usage evidence distinguished |
| AI_DIR_TYPE_CENTER | [Direction](ai-targets.md#direction) | Documented center direction |

## Investigation and experiments

[RESEARCH.md](../../agent/RESEARCH.md) holds investigation history; [STATE.md](../../agent/STATE.md) holds current status. [Godrick Soldier analysis](../analysis/GODRICK_SOLDIER_AI.md) refines the first experiment to a fixed region via observed ApproachTarget, with MoveToSomewhere as a comparison candidate. Nothing implemented or tested.
