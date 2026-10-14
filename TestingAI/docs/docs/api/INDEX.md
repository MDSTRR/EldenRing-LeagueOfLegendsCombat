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
- **User-reported in-game verification:** Experiment002 A/B/A passed according to the project owner: enemy-target ApproachTarget without melee, attacks restored when disabled. Game build/raw test evidence not supplied here. This does not validate new destination types.

The 2026-10-13 Open Enemy Control consolidation uses explicit classifications alongside those historical conventions: **VERIFIED FROM SOURCE** means an implementation/declaration/call site exists, **REASONABLE INFERENCE** means a proposed connection, and **UNVERIFIED** means missing engine/runtime evidence. Source verification is not local game verification. See [consolidated findings and experiment criteria](../analysis/NATIVE_LUA_NAVIGATION.md).

Last updated: 2026-10-13, Handoff004. Battle Lua text and manifest are now available and inspected. Sources do not specify a tested Elden Ring build; no behavior is verified in-game. Parameter disagreements and older-game examples remain explicit. “Observed locally” identifies supplied decompiled text evidence, distinct from runtime verification.

## AI goals

Latest runtime status, 2026-10-13: the user reports Experiments002 and003 verified in-game. Fixed-region003 reaches its destination but then wanders and returns. [Experiment003B](../../agent/experiments/EXPERIMENT_003B_ARRIVAL_WAIT.md) is separately built/staged to investigate arrival→waiting and parent completion; its runtime test is pending. Historical pending/first-test statements below do not supersede this update. Dynamic/native command reception and arbitrary XYZ remain unverified.

| Exact name | Reference | Current evidence |
|---|---|---|
| GOAL_COMMON_MoveToSomewhere | [Movement goals](ai-goals.md#goal_common_movetosomewhere) | Documented target-based pathing; no local test |
| GOAL_COMMON_MoveFollowPathSpecifyPos | [Movement goals](ai-goals.md#goal_common_movefollowpathspecifypos) | Documented coordinate slots; behavior unresolved |
| GOAL_COMMON_Wait | [Renewable waiting](ai-goals.md#goal_common_wait) | Published ER call sites and documented turning-only wait; 003B idle policy built, runtime untested |
| GOAL_COMMON_ApproachTarget, GOAL_COMMON_SidewayMove, GOAL_COMMON_LeaveTarget, GOAL_COMMON_Turn | [Observed target goals](ai-goals.md#target-relative-goals-observed-in-431030) | Exact call sites in431030; runtime behavior untested |
| GOAL_COMMON_ComboTunable_SuccessAngle180, GOAL_COMMON_ComboRepeat, GOAL_COMMON_ComboAttackTunableSpin, GOAL_COMMON_AttackTunableSpin, GOAL_COMMON_ComboRepeat_SuccessAngle180 | [Observed attack goals](ai-goals.md#attack-goals-observed-in-431030) | Catalog only; no combat implementation |

## Related AI functions

| Exact name | Reference | Current evidence |
|---|---|---|
| SetEventMoveTarget | [Point setup](ai-functions.md#seteventmovetarget) | VERIFIED FROM SOURCE for ER region setter/call sites; native address and current-build movement UNVERIFIED |
| SetAIFixedMoveTarget | [Point setup](ai-functions.md#setaifixedmovetarget) | Documented assignment of a target-relative fixed point |
| FollowPath | [Pathing](ai-functions.md#followpath) | Documented pathing operation used by MoveToSomewhere |
| GetDist, GetSubGoalNum | [Distance](ai-functions.md#getdist), [queue count](ai-functions.md#getsubgoalnum) | ER call sites; queue exhaustion differs from arrival |
| MoveToEventPoint | [Region primitive](ai-functions.md#movetoeventpoint) | Native declaration; no local test/Lua example |
| SetAIFixedMoveTargetSpecifyAngle | [Relative endpoint](ai-functions.md#setaifixedmovetargetspecifyangle) | Concrete ER common-logic call; no absolute XYZ setter |
| AddSubGoal | [Goal queue](ai-functions.md#addsubgoal) | Documented ER declaration; no local test |
| RegisterTableGoal, REGISTER_GOAL_NO_SUB_GOAL, REGIST_FUNC, Common_Battle_Activate, Approach_Act_Flex, ClearSubGoal, SetTargetRange | [Dispatch helpers](ai-functions.md#battle-dispatch-and-registration-helpers) | Observed calls and external definitions distinguished |
| Update_Default_NoSubGoal, GuardGoalSubFunc_Update, GoalFunc.GetNumber/SetNumber | [Completion and per-goal state](ai-functions.md#battle-goal-completion-and-per-goal-state) | Source-backed empty-queue/lifetime results and goal-local storage; exact wandering caller still inferred |

## Native runtime access and event communication

| Exact name / mechanism | Reference | Current evidence |
|---|---|---|
| resolve_addresses, get_current_target, chr_ins_quality, is_valid_chr_ins | [Native NPC access](native-runtime.md) | VERIFIED FROM SOURCE in Open Enemy Control; current-target pointer lookup, no entity-ID resolver; build/lifetime/thread guarantees UNVERIFIED |
| handle_f1, link_target, set_control_flags, sync_position | [Possession implementation](native-runtime.md#possession-implementation-and-limits) | VERIFIED FROM SOURCE for links/state/player following; AI arbitration UNVERIFIED; no dynamic navigation interface |
| CSFD4VirtualMemoryFlag.SetEventFlag / set_flag | [Native flag writing](event-ai-communication.md#native-event-flag-writing) | Source-backed engine call and independent memory writer; ABI/current-build/scheduling compatibility UNVERIFIED |
| IsEventFlag | [Battle Lua flag reader](event-ai-communication.md#iseventflag) | VERIFIED FROM SOURCE for ER battle-script reads; combined flag-to-region bridge is REASONABLE INFERENCE |
| GetEventRequest, INTERUPT_EventRequest | [AI request channel](event-ai-communication.md#geteventrequest-and-interupt_eventrequest) | VERIFIED FROM SOURCE for reads/shared dispatch; soldier request handling UNVERIFIED |
| RequestCharacterAICommand / AICommand | [Event command](event-ai-communication.md#requestcharacteraicommand) | EMEVD 2004[17] and source call sites; command values depend on NPC logic |
| SetEventPoint | [Event destination](event-ai-communication.md#seteventpoint) | EMEVD 2004[18] uses an entity-relative reference, no XYZ; native handler/storage aliasing UNVERIFIED |
| RequestCharacterAIReplan / ReplanAI | [Replanning request](event-ai-communication.md#requestcharacteraireplan) | EMEVD 2004[20] and source call sites; immediate replacement/current-NPC behavior UNVERIFIED |
| SetCharacterEventTarget | [Separate event target](event-ai-communication.md#setcharactereventtarget) | EMEVD 2004[11] declaration; not an established POINT_EVENT movement alias |
| GetNumber, SetNumber | [AI numeric state](event-ai-communication.md#getnumber-and-setnumber) | Lua-facing storage APIs; mapped native writer and XYZ endpoint UNVERIFIED |

These pages preserve source paths, functions, revision hashes and URLs. The [consolidated analysis](../analysis/NATIVE_LUA_NAVIGATION.md#original-reports-and-source-provenance) links both original investigations rather than copying their full reports.

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
| GOAL_RESULT_Failed, GOAL_RESULT_Continue, GOAL_RESULT_Success | [Results](ai-targets.md#goal-result-constants) | ER source values; no automatic arrival proof |

## Investigation and experiments

Latest: [Experiment003 prototype prepared](../../agent/experiments/EXPERIMENT_003_PREPARED_PROTOTYPE.md). Minimal setter/POINT_EVENT approach compiled and paired Lua/map overrides statically verified/staged inside project. Runtime prerequisite waived explicitly; actual lookup/navigation still unverified. No installed deployment/game launch; earlier research-only/blocked notes below are historical.

Current Experiment003: [fixed-destination research](../../agent/experiments/EXPERIMENT_003_FIXED_DESTINATION_RESEARCH.md), [saved-map check](../../agent/experiments/EXPERIMENT_003_SAVED_MAP_CHECK.md), then [prepared prototype report](../../agent/experiments/EXPERIMENT_003_PREPARED_PROTOTYPE.md). The latest report records a built/staged workspace prototype under the user's authorized runtime-region hypothesis; gameplay testing remains pending.529 public ER Lua scripts were searched: region setter/POINT_EVENT movement examples were found, but coordinate-goal usage was not. Experiment002 behavioral success is user-reported; historical pending/“no behavior verified” notes below do not establish the new region or dynamic bridge.

Open Enemy Control investigations: [consolidated findings](../analysis/NATIVE_LUA_NAVIGATION.md), [recommended sequence with pass/fail criteria](../analysis/NATIVE_LUA_NAVIGATION.md#recommended-experiment-sequence-and-criteria). Native flag publication and battle-Lua flag reception have separate source evidence; their combined dynamic-region architecture is not runtime verified. Arbitrary world-coordinate destinations remain unresolved. This documentation update does not change Agent 1's experiment authorization or artifacts.

[Experiment001 Lua round-trip](../../agent/experiments/EXPERIMENT_001_LUA_ROUNDTRIP.md): unchanged-bytecode baseline verified; compilation/header/27-function structural checks passed. Compiled repack and in-game loading pending. Behavior preservation precedes movement implementation.

Latest: compiled archive extraction/payload/metadata checks also passed; separate inactive override prepared. [Offline test plan](../../agent/experiments/EXPERIMENT_001_OFFLINE_TEST.md) covers next stage. In-game loading/compatibility still unverified.

[RESEARCH.md](../../agent/RESEARCH.md) holds investigation history; [STATE.md](../../agent/STATE.md) holds current status. [Godrick Soldier analysis](../analysis/GODRICK_SOLDIER_AI.md) refines the first experiment to a fixed region via observed ApproachTarget, with MoveToSomewhere as a comparison candidate. Nothing implemented or tested.

2026-10-13 current status supersedes earlier pending-compilation/repack and “nothing implemented” notes: Experiment001 static archive verification passed; user reports preliminary normal-behavior game test without definitive script-load evidence. [Experiment002 observable override](../../agent/experiments/EXPERIMENT_002_OBSERVABLE_OVERRIDE.md) prepares ApproachTarget plus ClearSubGoal and main interrupt isolation on disposable source. Compiled/header/static checks pass; interactive repack and in-game A/B/A pending. Existing entries reused; no new API invented. Fixed-region work deferred.

## Arena access and research

| Exact name | Reference | Current evidence |
|---|---|---|
| WarpPlayer | [Player warp](arena-access.md#warpplayer) | ER EMEVD2003[14], exact six-field declaration; arena runtime unverified |
| SetPlayerRespawnPoint | [Respawn destination](arena-access.md#setplayerrespawnpoint) | ER EMEVD2003[23], one EntityID; persistence/runtime unverified |

[Placidusax arena feasibility](../arena/PLACIDUSAX_ARENA_FEASIBILITY.md), [architecture](../arena/ARENA_ARCHITECTURE.md), [implementation plan](../arena/ARENA_IMPLEMENTATION_PLAN.md), [test matrix](../arena/ARENA_TEST_MATRIX.md). Research only; no arena build or game test. Existing NPC region targeting references are reused, not duplicated.

## Humanoid NPC architecture

| Exact names / fields | Reference | Current evidence |
|---|---|---|
| BuddyParam.npcParamId, npcThinkParamId, npcPlayerInitParamId, triggerSpEffectId, pcFollowType, disablePCTargetShare; NpcThinkParam.isBuddyAI | [Summon configuration](humanoid-npc-configuration.md#configuration-fields) | ER schema declarations; candidate row links/values not inferred from Names files |
| CharaInitParam.npcPlayerThinkId, npcPlayerType, equip_Wep_Right, equip_Wep_Left, equip_Helm, equip_Armer; NpcParam.teamType, chrActivateConditionParamId | [Human configuration](humanoid-npc-configuration.md#configuration-fields) | ER schema; effective selector/activation precedence unverified |
| npc30000_Logic, npc30000_Interupt, npc31000_Logic, npc31000_Interupt | [Player-NPC logic](humanoid-npc-configuration.md#npc30000_logic-and-npc31000_logic) | Exact published callbacks; candidate selection unverified |
| GOAL_NPC_WhiteGhost_Battle, PLAN_SP_EFFECT_BUDDY_DECLARE | [Shared goal/effect](humanoid-npc-configuration.md#goal_npc_whiteghost_battle-and-plan_sp_effect_buddy_declare) | Published constants5000/297000 and use sites; not candidate-row mapping |
| CopyPlayerCharacterData, SetAIParamID / SetCharacterAIId | [Copy and AI selection](humanoid-npc-configuration.md#copyplayercharacterdata-and-setaiparamid) | Exact Soulstruct wrappers and vanilla Mimic example; standalone runtime unverified |

[Humanoid foundation comparison](../arena/HUMANOID_NPC_FOUNDATION_COMPARISON.md): retain Godrick as the immediate control; proposed fixed-equipment c0000 map NPC validation before permanent arena adoption. Actual Mimic copying deferred. Research only; no architecture decision changed.
