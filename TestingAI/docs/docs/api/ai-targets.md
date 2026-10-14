# AI targets and movement direction

Evidence date: 2026-10-13. Sources: [ERAiAPI TARGET/AI_DIR_TYPE enum](https://eladidu.github.io/readable-ds-lua/d4/d1b/_ai_constants_8hpp.html), [AiFunc](https://eladidu.github.io/readable-ds-lua/d1/d81/class_ai_func.html), and [DS1 common function repository](https://www.soulsmodding.com/doku.php?id=common-refmat:lua_ai_common_function_repository).

Constants have no function signature or parameters. They represent enum selections, not arbitrary entity IDs or coordinates. Documented membership is not proof of meaningful support in either movement goal. No tested ER build identified; none locally verified.

## Character targets

| Exact name | Known role / evidence limit |
|---|---|
| TARGET_ENE_0 | Enemy reference; displayed movement-goal default; older-game usage example |
| TARGET_SELF | AI character itself; older-game facing-target example |
| TARGET_FRI_0 | Ally reference in common documentation; ER enum member |
| TARGET_LOCALPLAYER | Local player reference in common documentation; ER enum member |
| TARGET_HOSTPLAYER | ER enum member; no goal-specific usage established here |
| TARGET_EVENT | ER enum member, value 20; differs from POINT_EVENT; common DS1 documentation labels it unused |

Do not transfer DS1's unused designation to current ER behavior without inspection. Do not use TARGET_EVENT as an alias for a map-region movement point.

## Point targets

2026-10-13 user-reported runtime update: Experiment003 reaches the custom region through POINT_EVENT. The reported post-arrival wandering is now investigated in [Experiment003B](../../agent/experiments/EXPERIMENT_003B_ARRIVAL_WAIT.md). Earlier runtime-pending notes are historical for the tested fixed-region setup; dynamic destination replacement and the 003B waiting policy remain unverified.

**VERIFIED FROM SOURCE:** POINT_EVENT=102 in [ER ai_define](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/ai_define.dec.lua#L50), line50, plus concrete ApproachTarget/GetDist call sites in white-ghost/030000 logic at the same EldenRingAI commit `3b3efb00219026dfba4663b9eb1a1afd94c0a68e`. `POINT_EVENT` is a target enum selection, not the region's EntityID or XYZ. [SetEventMoveTarget](ai-functions.md#seteventmovetarget) selects the region by EntityID; its separate map-local RegionID/internal index must not be passed in its place.

**REASONABLE INFERENCE:** a native flag read by Lua could select another region while the game runs. **UNVERIFIED:** current-build lookup and navigation, goal-specific target support, storage aliasing with [SetEventPoint](event-ai-communication.md#seteventpoint), and active-path replacement. `TARGET_EVENT` remains a separate enum and must not be treated as an alias. The [saved-map check](../../agent/experiments/EXPERIMENT_003_SAVED_MAP_CHECK.md) records static region verification; the newer [prepared prototype report](../../agent/experiments/EXPERIMENT_003_PREPARED_PROTOTYPE.md) records the authorized compatibility hypothesis and build/staging checks, with runtime testing pending. See the [consolidated sequence and criteria](../analysis/NATIVE_LUA_NAVIGATION.md#recommended-experiment-sequence-and-criteria).

| Exact name | Known role / evidence limit |
|---|---|
| POINT_INITIAL | Initial-position reference; ER enum member; goal compatibility untested |
| POINT_EVENT | Region movement point, value 102; assigned by SetEventMoveTarget |
| POINT_MOVE_POINT | Current movement-point reference; older Souls MoveToSomewhere call-site evidence |
| POINT_AI_FIXED_POS | Fixed position assigned through SetAIFixedMoveTarget |

Related setters: [SetEventMoveTarget](ai-functions.md#seteventmovetarget) and [SetAIFixedMoveTarget](ai-functions.md#setaifixedmovetarget). Related goals: [MoveToSomewhere](ai-goals.md#goal_common_movetosomewhere) and [MoveFollowPathSpecifyPos](ai-goals.md#goal_common_movefollowpathspecifypos).

## Direction

`AI_DIR_TYPE_CENTER`: documented center/no-directional-offset selection. See the sourced [MoveToSomewhere example](ai-goals.md#usage-evidence). A center direction plus zero directional distance is the proposed fixed-region baseline; its behavior in the installed build still needs testing.

## Goal result constants

Exact definitions observed in [ER ai_define](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/ai_define.dec.lua), lines1–3: `GOAL_RESULT_Failed=-1`, `GOAL_RESULT_Continue=0`, `GOAL_RESULT_Success=1`. No parameters/signatures/defaults: these are callback result constants. [MoveToMultiPoint](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/move_to_point.dec.lua) uses success/continue in Goal.Update. They do not report a child goal's result by themselves; choosing Success in a custom callback without validated arrival would not prove movement completion. External source evidence only; no new result-return implementation or local test. Related: [GetSubGoalNum](ai-functions.md#getsubgoalnum), [GetDist](ai-functions.md#getdist).

## Usage and verification boundary

Handoff004 update: `TestingAI/decompiled/431030_battle.lua:564` uses TARGET_ENE_0 as movement target and TARGET_SELF as facing reference; many other calls are cataloged in [analysis](../analysis/GODRICK_SOLDIER_AI.md). This upgrades these references to observed local call sites, not runtime verification. POINT_EVENT and POINT_AI_FIXED_POS do not occur in that battle file. Dynamic destination resolution remains unknown.

The movement-goal reference contains the sourced usage example for TARGET_ENE_0, TARGET_SELF and AI_DIR_TYPE_CENTER. The setter reference contains the sourced POINT_EVENT setup example. No validated examples were found for all remaining constants; do not synthesize them into a claimed working invocation. Current knowledge does not establish a goal-specific target whitelist.
