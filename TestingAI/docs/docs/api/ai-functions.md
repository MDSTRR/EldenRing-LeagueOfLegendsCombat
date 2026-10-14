# Related AI movement functions

## Battle dispatch and registration helpers

Handoff004 sources: `TestingAI/decompiled/431030_battle.lua` (**B**); public [common_func_plan.lua](https://github.com/mihai1rus/EldenRingCommonAiFuncs/blob/main/common_func_plan.lua) (**P**, refactored ER-oriented example); public [common_battle_func.lua](https://github.com/mihai1rus/EldenRingCommonAiFuncs/blob/main/common_battle_func.lua) (**C**). These shared definitions are not yet inspected in the supplied aicommon. No runtime verification/build identified. Examples below are observed calls, not new implementations.

| Exact name | Signature / known arguments | Purpose, example and limits |
|---|---|---|
| RegisterTableGoal | B observed call shape `(goalConstant, nameString)`; full definition/defaults unknown | B:1 registers battle goal/name; B:1032 after-attack goal. Shared Goal table setup must be inspected before modification. |
| REGISTER_GOAL_NO_SUB_GOAL | B observed shape `(goalConstant, true)`; full signature/defaults unknown | B:2,1033 flags registration. Do not interpret as a ban on AddSubGoal: B queues many goals. |
| REGIST_FUNC | P:846–850 `(ai,goal,act,paramTable)` | Returns closure calling act with captured arguments. B:385 binds Act13. P has no explicit defaults; B omits paramTable. Installed binding behavior not verified. |
| Common_Battle_Activate | C:6 `(ai,goal,probabilities,acts,actAfter)`; B:401 passes **six** arguments, including thirdTable | C cumulative-weight selector calls bound action; B local weights/callables confirmed. Sixth-argument contract and fallback behavior unknown in installed version. |
| Approach_Act_Flex | P:851 `(ai,goal,stopDistance,runChanceDistance,forceRunDistance,runChance,guardChance,walkLife,runLife)` | P chooses enemy approach/guard/walk or run and adds distance adjustment. P uses walkLife or3/runLife or8; not verified installed defaults. B:697 passes `(ai,goal,3.5,0,999,100,0,3,3)`. All seven numeric meanings are external-source supported; local callee missing. |
| ClearSubGoal | [GoalFunc](https://eladidu.github.io/readable-ds-lua/d4/d58/class_goal_func.html): `void ClearSubGoal()` | Clear queue; B:921 then adds attack. Does not itself prove safe immediate locomotion retargeting. |
| SetTargetRange | [GoalFunc](https://eladidu.github.io/readable-ds-lua/d4/d58/class_goal_func.html): `SetTargetRange(int rangeObserverSlot,float minDistance,float maxDistance)`; also two-distance overload | Observer selection and min/max bounds; B:607 chains `(1,6,7)`, B:630 `(1,6,100)`. Reference describes unused ER facility; do not equate it with destination or stopping tolerance. |

Related: [architecture and branch caveats](../analysis/GODRICK_SOLDIER_AI.md), [target goals](ai-goals.md#target-relative-goals-observed-in-431030), [AddSubGoal](#addsubgoal). RegisterTableGoal's goal constant/name and callback parameter shapes are observable; full engine signatures should not be synthesized from those calls.

## AddSubGoal

Source: [ERAiAPI GoalFunc](https://eladidu.github.io/readable-ds-lua/d4/d58/class_goal_func.html). Documented declaration:

```text
GoalFunc* AddSubGoal(int goalId, float life,
  float goalParam0=0, float goalParam1=0, float goalParam2=0,
  float goalParam3=0, float goalParam4=0, float goalParam5=0,
  float goalParam6=0, float goalParam7=0, float goalParam8=0,
  float goalParam9=0, float goalParam10=0, float goalParam11=0,
  float goalParam12=0)
```

Purpose: enqueue a subgoal and return the created goal object. `goalId` selects the goal, `life` supplies lifetime, and `goalParam0` through `goalParam12` carry that goal's positional arguments. Source-displayed zeros do not replace each goal's own interpretation/default handling. The sourced Lua usage example already appears under [MoveToSomewhere](ai-goals.md#usage-evidence); it is a DS1 example. Status: documented ER method, no local invocation test or known tested build. Related: [resource/configuration mapping](ai-resources.md), [goal parameter tables](ai-goals.md).

Handoff004 local usage: `TestingAI/decompiled/431030_battle.lua:564` supplies `(GOAL_COMMON_ApproachTarget,10,TARGET_ENE_0,3,TARGET_SELF,false,9910)` after resolving local variables. Confirmed call site in supplied text; engine behavior still untested.

Evidence date: 2026-10-13. Source: [ERAiAPI AiFunc](https://eladidu.github.io/readable-ds-lua/d1/d81/class_ai_func.html), an Elden Ring community reverse-engineering reference. No tested build stated or local verification. These are documented declarations, not implementation code. See [goals](ai-goals.md), [constants](ai-targets.md), and [index](INDEX.md).

## SetEventMoveTarget

2026-10-13 runtime update: the user now reports Experiment003 verified in-game for the saved region, with post-arrival wandering/return. This is **user-reported runtime verification of the tested fixed-region setup**, not proof of arbitrary XYZ, dynamic replacement or a native bridge. [Experiment003B](../../agent/experiments/EXPERIMENT_003B_ARRIVAL_WAIT.md) investigates completion/idle control. Earlier pending-runtime statements below are historical for that fixed-region setup; the new 003B behavior remains untested.

Experiment003 prepared usage: `ai:SetEventMoveTarget(67676767)` followed by ApproachTarget using POINT_EVENT. Confirmed in compiled callback disassembly; region9063/entity67676767 saved map checked. Compilation/static checks establish call construction, not runtime lookup. User authorized testing Other/Point compatibility as a hypothesis. [Prototype report](../../agent/experiments/EXPERIMENT_003_PREPARED_PROTOTYPE.md).

Documented Lua-facing declaration: `void SetEventMoveTarget(unsigned int regionId)`, generated `AiFunc.hpp:2635` in readable-ds-lua gh-pages commit `4c78203276c9dd5dbaf8b6d769a30d807cd41233` ([header source view](https://eladidu.github.io/readable-ds-lua/d3/d42/_ai_func_8hpp_source.html)). This declaration is reference documentation, not a resolved native function address or DLL ABI.

- Parameter: a real map region's **EntityID**, assigned to `POINT_EVENT`; no default shown. It is distinct from RegionID, list index, NPC EntityID and ThinkParam ID. [MSBE region fields](https://github.com/soulsmods/SoulsFormatsNEXT/blob/master/SoulsFormats/Formats/MSB/MSBE/PointParam.cs) distinguish the serialized identifiers.
- Purpose: select a region destination reference. This setter alone does not queue movement and accepts no raw X/Y/Z.
- **VERIFIED FROM SOURCE:** [ER white-ghost source](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/npc_whiteghost_battle.dec.lua#L96-L103), `GOAL_NPC_WhiteGhost_Battle_Act03:96–103`, uses `arg0:SetEventMoveTarget(f5_local0)` before an ApproachTarget goal targets `POINT_EVENT`. [MoveToMultiPoint source](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/move_to_point.dec.lua#L33-L41), lines33–41, sets the region, measures distance and queues a point goal. Both use EldenRingAI commit `3b3efb00219026dfba4663b9eb1a1afd94c0a68e`, with unspecified game-build provenance. The suspicious white-ghost constant/distance branch is not endorsed as correct arrival logic.
- **REASONABLE INFERENCE:** Lua could select between validated regions after receiving a native event flag. The combined bridge is a proposed architecture, not a tested invocation.
- **UNVERIFIED:** current-build region lookup/subtype availability, soldier navigation/reachability, setter storage layout/native address, cached-path response and immediate mid-movement retargeting. Static map/compiler checks do not resolve this boundary.
- Related: [POINT_EVENT](ai-targets.md#point-targets), [MoveToSomewhere](ai-goals.md#goal_common_movetosomewhere), [IsEventFlag](event-ai-communication.md#iseventflag), [SetEventPoint](event-ai-communication.md#seteventpoint), and the [recommended experiment sequence](../analysis/NATIVE_LUA_NAVIGATION.md#recommended-experiment-sequence-and-criteria).

Earlier DS1 example remains provenance-specific: [common function repository](https://www.soulsmodding.com/doku.php?id=common-refmat:lua_ai_common_function_repository). Current project records: [Experiment003 research](../../agent/experiments/EXPERIMENT_003_FIXED_DESTINATION_RESEARCH.md), [saved-map check](../../agent/experiments/EXPERIMENT_003_SAVED_MAP_CHECK.md), and the newer [prepared prototype report](../../agent/experiments/EXPERIMENT_003_PREPARED_PROTOTYPE.md). Those experiment files are linked, not modified by this consolidation.

## GetDist

Documented declaration: `float GetDist(TARGET target)` in [ERAiAPI AiFunc](https://eladidu.github.io/readable-ds-lua/d1/d81/class_ai_func.html). One target enum parameter, no default. Returns capsule-adjusted target distance; not an exact XYZ coordinate measurement. [ER030000 logic](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/030000_logic.dec.lua), lines16–19, checks `arg0:GetDist(POINT_EVENT) <= 0.3` before an event-point approach. TARGET_ENE_0 usage is also present throughout supplied431030 source. POINT_EVENT support observed externally; local region validity/distance semantics untested. Related: SetEventMoveTarget, ApproachTarget, GetSubGoalNum. Missing-target behavior is not established; zero distance cannot certify region existence.

## GetSubGoalNum

Documented declaration: `int GetSubGoalNum()`; no parameters/defaults. [ERAiAPI GoalFunc](https://eladidu.github.io/readable-ds-lua/d4/d58/class_goal_func.html) identifies subgoal queue count. [ER MoveToMultiPoint](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/move_to_point.dec.lua), line47, uses `arg2:GetSubGoalNum() <= 0` with an additional distance check and GOAL_RESULT constants. Queue exhaustion alone does not prove arrival/success; could reflect failure/cancellation/lifetime. Source's ambiguous numeric target usage is not adopted. Documented/external usage only, no local runtime verification. Related: GetDist and [result constants](ai-targets.md#goal-result-constants).

## Battle-goal completion and per-goal state

Added 2026-10-13 for [Experiment003B arrival/wait control](../../agent/experiments/EXPERIMENT_003B_ARRIVAL_WAIT.md). Distinguish source evidence from the user's successful fixed-region test and the still-pending 003B test.

| Function | Known signature / call shape | Source-backed behavior and limits |
|---|---|---|
| Update_Default_NoSubGoal | Published Lua `Update_Default_NoSubGoal(arg0,arg1,arg2)`; third argument is the goal in the caller | **VERIFIED FROM SOURCE:** empty subgoal queue returns GOAL_RESULT_Success; otherwise Continue. No distinction between arrival, timeout or failure. [ER common_func_plan.dec.lua:1261–1267](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/common_func_plan.dec.lua#L1261-L1267). Experiment003 main Update delegates here. |
| GuardGoalSubFunc_Update | Published Lua `(ai,goal,guardId,onGuardResult,lifeSuccess)` positional interpretation from ApproachTarget caller | **VERIFIED FROM SOURCE:** handles goal-number guard results and goal life <=0, otherwise Continue. [Common helper:1276–1292](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/common_func_plan.dec.lua#L1276-L1292), [ApproachTarget caller:27–32](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/approach_target.dec.lua#L27-L32). Lifetime completion is not arrival. Argument names are interpretation, not original decompiled names/defaults. |
| GoalFunc.GetNumber / SetNumber | `float GetNumber(int index)` / `void SetNumber(int index,float value)` | [GoalFunc reference](https://eladidu.github.io/readable-ds-lua/d4/d58/class_goal_func.html) documents goal-local slots0–7, distinct from AI-wide numeric state. Published guard helpers read/write child-goal slots0/1. 003B reserves parent slot0 for its state; current-game behavior of that new policy is **UNVERIFIED**. |

All published ER examples above use commit `3b3efb00219026dfba4663b9eb1a1afd94c0a68e`, with unspecified game-build provenance. **REASONABLE INFERENCE:** keeping the parent Update at Continue and replenishing short Wait subgoals may avoid handing control back on queue exhaustion while leaving Update available to future commands. Native/state-change preemption and actual future command reception remain **UNVERIFIED**. No AI-wide disable, faction change, or command receiver is added by 003B. See [Wait](ai-goals.md#goal_common_wait).

## MoveToEventPoint

Documented declaration: `bool MoveToEventPoint(unsigned int regionId, int p2, float p3, bool isWalk)` in [ERAiAPI AiFunc](https://eladidu.github.io/readable-ds-lua/d1/d81/class_ai_func.html). Region identifier, two parameters described as unused, walk selection; no defaults inferred. Reference describes pathing to event region and returning whether the region exists, not proof of arrival. No concrete Lua usage validated here; no prototype call supplied. Region-based ApproachTarget has better existing project evidence. Status: documented native declaration only, build unspecified; Lua integration/local behavior unverified. Related: SetEventMoveTarget and POINT_EVENT.

## SetAIFixedMoveTargetSpecifyAngle

Documented declaration: `void SetAIFixedMoveTargetSpecifyAngle(TARGET targetOrigin, float angle, float lineLength, AI_SPA_DIR_TYPE spatialDirectionStart)` in [ERAiAPI AiFunc](https://eladidu.github.io/readable-ds-lua/d1/d81/class_ai_func.html). Sets POINT_AI_FIXED_POS to a target-relative line endpoint; no defaults. [ER common_logic_func](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/common_logic_func.dec.lua), lines43–44, supplies `(TARGET_SELF,180,3,AI_SPA_DIR_TYPE_TargetF)` before ApproachTarget toward POINT_AI_FIXED_POS. This is not an absolute XYZ setter; precise angle/frame semantics and local behavior unverified. Related: SetAIFixedMoveTarget and [fixed point target](ai-targets.md#point-targets). Experiment003 chooses a region rather than adding this dependency.

## SetAIFixedMoveTarget

Documented declaration: `void SetAIFixedMoveTarget(TARGET targetOrigin, AI_DIR_TYPE directionFromTarget, float lineLength)`.

| Parameter | Documented role |
|---|---|
| targetOrigin | Line origin target |
| directionFromTarget | Direction from that target |
| lineLength | Line length |

No defaults shown. Purpose: set POINT_AI_FIXED_POS to the line endpoint. Related: [POINT_AI_FIXED_POS](ai-targets.md#point-targets), [MoveToSomewhere](ai-goals.md#goal_common_movetosomewhere).

Usage examples: no exact invocation validated during this research; do not substitute arbitrary x/y/z values into this target-relative signature. Status: documented setup mechanism only; movement integration and runtime behavior untested.

## FollowPath

Documented overload parameter lists (both return `bool`):

```text
FollowPath(TARGET moveTarget, AI_DIR_TYPE directionFromTarget, float stopDistance,
           bool isWalk, float directionalDistance)
FollowPath(TARGET moveTarget, AI_DIR_TYPE directionFromTarget, float stopDistance,
           bool isWalk, float directionalDistance, bool xzDistanceOnly,
           bool defaultOrientationAndDirDist, bool closeProximityMode)
```

Purpose: path toward a target-centered spherical sector. The source relates the shorter overload to false values for the three additional flags; this is documented overload behavior, not permission to omit arbitrary Lua arguments.

| Parameter | Documented role / remaining uncertainty |
|---|---|
| moveTarget | Reference target |
| directionFromTarget | Sector direction; center gives a full sphere |
| stopDistance | Stopping radius |
| isWalk | Walk selection |
| directionalDistance | Directional distance; detailed geometry not established here |
| xzDistanceOnly | Horizontal distance selection |
| defaultOrientationAndDirDist | Default orientation/directional-distance selection |
| closeProximityMode | Mode named in the signature; detailed behavior unresolved here |

Usage evidence: ERAiAPI documents [MoveToSomewhere](ai-goals.md#goal_common_movetosomewhere) as using FollowPath. No direct Lua invocation validated or implemented. Status: documented pathing semantics; current-build navigation success and replacement behavior untested. This reference is not a recommendation to bypass the AI goal.
