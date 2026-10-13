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

Documented declaration: `void SetEventMoveTarget(unsigned int regionId)`.

- Parameter: `regionId`, the region assigned to POINT_EVENT. No default shown.
- Purpose: assign the event movement point to a map region.
- Source example: `ai:SetEventMoveTarget(RegionEntityID)` appears in the [DS1 common function repository](https://www.soulsmodding.com/doku.php?id=common-refmat:lua_ai_common_function_repository). `RegionEntityID` denotes a real map region ID to supply, not a predefined engine constant.
- Related: [POINT_EVENT](ai-targets.md#point-targets), [MoveToSomewhere](ai-goals.md#goal_common_movetosomewhere).
- Status: setup behavior documented for ER; Lua example has DS1 provenance. Region reachability, soldier movement and runtime updates untested. This setter alone does not command movement.

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
