# AI movement goals

Evidence date: 2026-10-13. Community documentation only; no local verification or known tested build. See [index](INDEX.md) and [investigation](../../agent/RESEARCH.md).

Sources: [ER Goals & Params (wiki)](https://soulsmodding.com/doku.php?id=er-refmat:ai-goals-and-params), [ERAiAPI Goals.hpp](https://eladidu.github.io/readable-ds-lua/dd/dac/_goals_8hpp.html).

Tables are the documented positional signatures. Index 0 is the first goal parameter, after goal ID and lifetime in the enclosing goal-add call. ERAiAPI's C++-style types/defaults describe goals; they do not introduce callable Lua functions or establish omitted-argument behavior in the installed game.

## GOAL_COMMON_MoveToSomewhere

**Purpose (documented):** use pathing toward a target-centered spherical sector through [FollowPath](ai-functions.md#followpath). A destination represented by an AI point is a promising application; fixed-region navigation by the soldier remains an inference pending a test. No direct x/y/z slots.

| Index | Exact wiki parameter | ERAiAPI name | Type | Displayed default |
|---|---|---|---|---|
| 0 | moveTarget | moveTarget | TARGET | TARGET_ENE_0 |
| 1 | orientationFromTarget | directionFromTarget | AI_DIR_TYPE | AI_DIR_TYPE_CENTER |
| 2 | stopDistance | stopDist | float | 0 |
| 3 | turnTarget | turnTarget | TARGET | TARGET_ENE_0 |
| 4 | walk | walk | bool | false |
| 5 | directionalDistance | directionalDistance | float | 0 |
| 6 | NONE_MISTAKE | unused_7 | float | Not shown |
| 7 | xzDistanceOnly | xzDistanceOnly | bool | false |
| 8 | ROUTEMOVE_UNKBOOL7 | useDefaultArgs | bool | false |
| 9 | isCloseProximityMode | closeProximityMode | bool | false |

ERAiAPI describes the movement target as sector origin, stop distance as radius, turn target as facing reference, and walk as walk/run selection. `xzDistanceOnly` excludes vertical distance; `useDefaultArgs` selects center direction and zero directional distance. Its directional-width note is tentative. Slot 6 is labeled unused, slot 8 has differing confidence between sources, and close-proximity semantics are not explained.

### Usage evidence

The following is a source example, **made for DS1; not verified for Elden Ring**, from the author's [common function repository](https://www.soulsmodding.com/doku.php?id=common-refmat:lua_ai_common_function_repository):

```lua
goal:AddSubGoal(GOAL_COMMON_MoveToSomewhere, 20, TARGET_ENE_0, AI_DIR_TYPE_CENTER, 1.5, TARGET_SELF, false, 0)
```

It demonstrates enemy destination, self facing and omitted trailing slots. Those omissions are not endorsed for the current ER build. [Older Souls non_battle_act.lua](https://github.com/Grimrukh/SoulsAI/blob/master/ai_scripts/aiCommon/non_battle_act.lua) also uses POINT_MOVE_POINT as destination.

**Targets:** TARGET_ENE_0 is the documented default; TARGET_SELF is demonstrated as facing target; POINT_MOVE_POINT has older-game usage evidence. Other [shared target constants](ai-targets.md) are not a tested goal whitelist. [SetEventMoveTarget](ai-functions.md#seteventmovetarget) documents region setup for POINT_EVENT, making it a proposed fixed-destination test input.

**Unverified:** current-build behavior, soldier compatibility, omitted arguments, route failures, obstacle detours, interruption, retargeting and arrival precision. See experiment A in [RESEARCH.md](../../agent/RESEARCH.md#minimal-proposed-experiment-a--recommended-first).

## GOAL_COMMON_MoveFollowPathSpecifyPos

**Purpose:** explicit-position movement candidate inferred from its name and coordinate slots. The inspected typed reference supplies no behavioral explanation. Direct world-space navigation is not confirmed.

| Index | Exact wiki parameter | ERAiAPI name | Type | Displayed default |
|---|---|---|---|---|
| 0 | moveTargetAlmostUnused | moveTarget | TARGET | TARGET_ENE_0 |
| 1 | NONE | directionFromTarget | AI_DIR_TYPE | AI_DIR_TYPE_CENTER |
| 2 | stopDistance | stopDist | float | 0 |
| 3 | turnTarget | turnTarget | TARGET | TARGET_ENE_0 |
| 4 | NONE | walk | bool | false |
| 5 | NONE | directionalDistance | float | 0 |
| 6 | x | x | float | 0 |
| 7 | y | y | float | 0 |
| 8 | z | z | float | 0 |

Both sources document coordinate slots. The wiki's NONE labels disagree with ERAiAPI's names for slots 1/4/5; names do not prove those slots are used. “AlmostUnused” does not specify when the movement target matters.

**Targets:** moveTarget and turnTarget are typed TARGET, with TARGET_ENE_0 displayed defaults. No exact-goal usage example or target whitelist was found. [Enum membership](ai-targets.md) does not demonstrate accepted destination types.

**Usage examples:** none confirmed in the inspected sources. No runnable example is supplied because required arguments, coordinate frame and route prerequisites remain unresolved. The proposed coordinate-discrimination test is a procedure, not an API example: see experiment B in [RESEARCH.md](../../agent/RESEARCH.md#minimal-proposed-experiment-b--fixed-coordinate-discrimination).

**Unverified:** coordinate frame/units, fresh-path computation versus existing-route use, target influence, unused slots, walk behavior, stopping, failures, obstacles, interruption and dynamic coordinate updates. No local verification.

## Target-relative goals observed in 431030

Experiment002 uses the existing ApproachTarget entry on a disposable copy: `goal:AddSubGoal(GOAL_COMMON_ApproachTarget,10,TARGET_ENE_0,3,TARGET_SELF,true,9910)`. This supplies the same slots as Act13, forcing its observed walk variant. Main queue clearing and interrupt isolation are described in the [experiment report](../../agent/experiments/EXPERIMENT_002_OBSERVABLE_OVERRIDE.md). Lua5.0 compilation/header/static function isolation verified; archive repack, approach behavior, exact distance/guard/facing and repeated activation unverified. No omitted goal parameters or defaults inferred.

Added Handoff004. Sources: [ER parameter reference](https://soulsmodding.com/doku.php?id=er-refmat:ai-goals-and-params), [ERAiAPI](https://eladidu.github.io/readable-ds-lua/dd/dac/_goals_8hpp.html), and `TestingAI/decompiled/431030_battle.lua`. Observed call sites are locally inspected decompiled text, not verified runtime behavior. Full arguments/caller inventory: [analysis](../analysis/GODRICK_SOLDIER_AI.md#complete-movement-call-catalog). No installed build known; no omitted-argument defaults asserted here.

Exact documented ordered goal slots, excluding enclosing goal ID/lifetime:

| Exact goal | Ordered wiki parameter labels | Purpose / representative local call |
|---|---|---|
| GOAL_COMMON_ApproachTarget | moveTarget,stopDistance,turnTarget,walk,guardStateId,guardEndType,guardSuccessOnEnd,xzDistanceOnly | Approach target; Act13 line564 supplies enemy,3,self,false,9910 after lifetime10 |
| GOAL_COMMON_SidewayMove | moveTarget,isRight,stopAngle,isWalk,successOnEnd,guardStateId,guardEndType | Circle target; Act14 line584 supplies enemy,random0/1,180,true,false,9910 after lifetime random1–3 |
| GOAL_COMMON_LeaveTarget | moveTarget,stopDistance,turnTarget,walk,guardStateId,guardEndType,guardSuccessOnEnd | Retreat; Act18 line667 supplies enemy,2,enemy,true,9910,two unresolved globals after lifetime1 |
| GOAL_COMMON_Turn | turnTarget,withinAngle,guardStateId,guardEndType,guardSuccessOnEnd | Face target; Act17 line648 supplies enemy,90,9910,GUARD_GOAL_DESIRE_RET_Continue,true after lifetime2 |

Movement/facing targets are TARGET enum references; distance and angle slots are numeric, walk/right/success selections boolean-like, guard action numeric. Guard result selectors remain goal-specific; do not normalize their enum names across sources. Approach has separate move/facing targets; Sideway uses direction around a target, Turn specifies orientation rather than position. Guard flags/global meanings and actual obstacle route behavior require shared/native inspection. Implementations not present in the battle file. POINT_EVENT compatibility is documented as a proposal, not established by these enemy-target call sites.

## Attack goals observed in 431030

Exact documented positional signatures from the same wiki (no defaults inferred). Usage tuples and all caller line numbers: [attack catalog](../analysis/GODRICK_SOLDIER_AI.md#attack-catalog-and-movement-relationship).

| Exact goal | Ordered documented parameters | Local usage example location |
|---|---|---|
| GOAL_COMMON_ComboTunable_SuccessAngle180 | ezStateId,target,successDistance,turnTime,turnFaceAngle,upAngle,downAngle | Act01 line436; after helper approach |
| GOAL_COMMON_ComboRepeat | ezStateId,target,successDistance,upAngle,downAngle | Act01 lines437–438; chained followups |
| GOAL_COMMON_ComboAttackTunableSpin | ezStateId,target,successDistance,turnTime,turnFaceAngle,upAngle,downAngle | Act20 line705; after approach |
| GOAL_COMMON_AttackTunableSpin | ezStateId,target,successDistance,turnTime,turnFaceAngle,upAngle,downAngle | Interrupt line922 |
| GOAL_COMMON_ComboRepeat_SuccessAngle180 | ezStateId,target,successDistance,upAngle,downAngle | Interrupt line957 |

Purpose: animation/action execution relative to the specified target. Action ID and target identify execution request and reference; successDistance is documented as an end-condition distance, not weapon reach. Tunable families have pre-action turn timing/facing slots; repeat families have vertical-angle slots instead. ERAiAPI uses `animationId`/`successDist` names for corresponding fields. Additional zeros observed beyond a documented repeat signature remain unassigned; do not invent parameters. Exact animations, guard behavior, cancellation and native success semantics are not locally tested. No combat changes proposed or implemented by this catalog.

## Navigation candidates — Handoff004 status

No occurrence of MoveToSomewhere, MoveFollowPathSpecifyPos, SetEventMoveTarget, SetAIFixedMoveTarget, POINT_EVENT, POINT_AI_FIXED_POS or FollowPath in all1044 lines of the supplied battle text. This is absence in that file, not absence from the engine. Logic/common archives are supplied but unreadable counterparts are not yet provided. Previous coordinate/pathing claims remain external-documentation evidence only. Current first-test proposal uses region + observed ApproachTarget; [analysis](../analysis/GODRICK_SOLDIER_AI.md#recommended-first-experiment--fixed-region-using-the-observed-approach-goal) explains the refinement.
