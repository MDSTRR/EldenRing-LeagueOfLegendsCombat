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
