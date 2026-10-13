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

| Exact name | Known role / evidence limit |
|---|---|
| POINT_INITIAL | Initial-position reference; ER enum member; goal compatibility untested |
| POINT_EVENT | Region movement point, value 102; assigned by SetEventMoveTarget |
| POINT_MOVE_POINT | Current movement-point reference; older Souls MoveToSomewhere call-site evidence |
| POINT_AI_FIXED_POS | Fixed position assigned through SetAIFixedMoveTarget |

Related setters: [SetEventMoveTarget](ai-functions.md#seteventmovetarget) and [SetAIFixedMoveTarget](ai-functions.md#setaifixedmovetarget). Related goals: [MoveToSomewhere](ai-goals.md#goal_common_movetosomewhere) and [MoveFollowPathSpecifyPos](ai-goals.md#goal_common_movefollowpathspecifypos).

## Direction

`AI_DIR_TYPE_CENTER`: documented center/no-directional-offset selection. See the sourced [MoveToSomewhere example](ai-goals.md#usage-evidence). A center direction plus zero directional distance is the proposed fixed-region baseline; its behavior in the installed build still needs testing.

## Usage and verification boundary

Handoff004 update: `TestingAI/decompiled/431030_battle.lua:564` uses TARGET_ENE_0 as movement target and TARGET_SELF as facing reference; many other calls are cataloged in [analysis](../analysis/GODRICK_SOLDIER_AI.md). This upgrades these references to observed local call sites, not runtime verification. POINT_EVENT and POINT_AI_FIXED_POS do not occur in that battle file. Dynamic destination resolution remains unknown.

The movement-goal reference contains the sourced usage example for TARGET_ENE_0, TARGET_SELF and AI_DIR_TYPE_CENTER. The setter reference contains the sourced POINT_EVENT setup example. No validated examples were found for all remaining constants; do not synthesize them into a claimed working invocation. Current knowledge does not establish a goal-specific target whitelist.
