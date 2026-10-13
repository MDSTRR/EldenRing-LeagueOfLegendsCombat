# Elden Ring AI movement goals — research only

Researched: 2026-10-13. No game files available; game downloading. No gameplay changes or in-game tests performed. No movement architecture selected.

## Evidence and sources

- **S1 — [Souls Modding Wiki: Elden Ring AI Goals & Params](https://soulsmodding.com/doku.php?id=er-refmat:ai-goals-and-params).** Elden Ring-specific community reference, page last modified 2025-02-25. Supplies positional parameter labels, including unresolved/unused slots. No game build identified.
- **S2 — [ElaDiDu ERAiAPI: Goals.hpp](https://eladidu.github.io/readable-ds-lua/dd/dac/_goals_8hpp.html).** Author-maintained reverse-engineering documentation explicitly for Elden Ring ([introduction](https://eladidu.github.io/readable-ds-lua/)). Supplies types/defaults and movement semantics. No tested game build identified. These C++-style declarations describe goals; they are not new callable Lua APIs.
- **S3 — [ERAiAPI: AiFunc](https://eladidu.github.io/readable-ds-lua/d1/d81/class_ai_func.html).** Documents target setup and pathing operations for Elden Ring.
- **S4 — [ERAiAPI: TARGET constants](https://eladidu.github.io/readable-ds-lua/d4/d1b/_ai_constants_8hpp.html).** Lists the shared target enumeration; enumeration membership alone does not establish that every goal accepts every value meaningfully.
- **S5 — [Lua AI Common Function Repository](https://www.soulsmodding.com/doku.php?id=common-refmat:lua_ai_common_function_repository).** Author's example repository explicitly says it was made for DS1. Useful supporting example, not Elden Ring verification.
- **S6 — [Grimrukh/SoulsAI: non_battle_act.lua](https://github.com/Grimrukh/SoulsAI/blob/master/ai_scripts/aiCommon/non_battle_act.lua).** Older Souls source example using a movement point. Not proof of current Elden Ring behavior.

Credibility: these are community reverse-engineering references/source examples, not official FromSoftware specifications. “Documented” below means supported by these sources; “verified in-game” requires local reproduction, which has not happened. No independent exact-goal Elden Ring call-site example was located in the inspected public examples. The inspected EldenRingCommonAiFuncs `010000_logic.lua` and `common_func_plan.lua` did not supply an example of either exact goal. This is a limited search result, not proof that no examples exist.

## 1. GOAL_COMMON_MoveToSomewhere

### Exact documented positional parameters

S1 uses zero-based goal parameters, after the goal ID and lifetime supplied by the surrounding goal-add operation. Lifetime is not param0. The following preserves S1's labels and aligns S2's alternative names, types and displayed defaults:

| Index | S1 exact label | S2 name; type; displayed default |
|---|---|---|
| 0 | moveTarget | moveTarget; TARGET; TARGET_ENE_0 |
| 1 | orientationFromTarget | directionFromTarget; AI_DIR_TYPE; AI_DIR_TYPE_CENTER |
| 2 | stopDistance | stopDist; float; 0 |
| 3 | turnTarget | turnTarget; TARGET; TARGET_ENE_0 |
| 4 | walk | walk; bool; false |
| 5 | directionalDistance | directionalDistance; float; 0 |
| 6 | NONE_MISTAKE | unused_7; float; none shown |
| 7 | xzDistanceOnly | xzDistanceOnly; bool; false |
| 8 | ROUTEMOVE_UNKBOOL7 | useDefaultArgs; bool; false |
| 9 | isCloseProximityMode | closeProximityMode; bool; false |

S2 describes target-centered spherical-sector pathing through `AiFunc::FollowPath`. It identifies the stopping radius, facing target, walk/run choice, horizontal-only distance option, and the option to force center direction/zero directional distance. Several details remain undescribed; its directional-width note includes a question mark. Displayed defaults are documentation, not locally verified omitted-Lua-argument behavior. S1's slot 8 uncertainty is more conservative than S2's interpretation; retain both. [S1](https://soulsmodding.com/doku.php?id=er-refmat:ai-goals-and-params), [S2](https://eladidu.github.io/readable-ds-lua/dd/dac/_goals_8hpp.html)

### Known target types and examples

- `TARGET_ENE_0`: documented default and demonstrated movement target in S5. Its example passes goal ID, a 20-second lifetime, enemy target, center direction, 1.5 stopping distance, self facing target, false walk flag, and zero directional distance. This is a DS1 example, not a tested ER invocation. S5 describes true as walking and false as dashing.
- `TARGET_SELF`: demonstrated facing target in that example; do not confuse facing with destination.
- `POINT_MOVE_POINT`: demonstrated movement target in S6's `NonBattleAct_Activate`; it uses the current movement point and self facing.
- Elden Ring's shared TARGET enum includes enemy/self, ally (`TARGET_FRI_0`), player (`TARGET_LOCALPLAYER`, `TARGET_HOSTPLAYER`), `POINT_INITIAL`, `POINT_EVENT`, `POINT_MOVE_POINT`, and `POINT_AI_FIXED_POS`. These are documented enum members, not an exhaustive goal-specific compatibility list. [S4](https://eladidu.github.io/readable-ds-lua/d4/d1b/_ai_constants_8hpp.html)
- S3 documents `SetEventMoveTarget(unsigned int regionId)` assigning `POINT_EVENT` to a region, and `SetAIFixedMoveTarget(TARGET targetOrigin, AI_DIR_TYPE directionFromTarget, float lineLength)` assigning `POINT_AI_FIXED_POS` from a target-relative line endpoint. These establish point setup mechanisms, not proof that this soldier/goal combination works. `TARGET_EVENT` and `POINT_EVENT` are separate constants (20 versus 102); they must not be interchanged. [S3](https://eladidu.github.io/readable-ds-lua/d1/d81/class_ai_func.html), [S4](https://eladidu.github.io/readable-ds-lua/d4/d1b/_ai_constants_8hpp.html)

**Destination assessment:** Strong documented candidate for navigation to a destination represented by an AI target/point. It has no direct x/y/z parameter slots. Using a fixed region via POINT_EVENT is a supported research inference combining the goal signature with documented point setup; successful soldier navigation still needs testing.

**Unverified:** obstacle detours in the chosen area, reachable-point constraints, failure/timeout behavior, normal AI interruptions, parameter omission semantics, command replacement, runtime point changes, and Soldier of Godrick compatibility. Do not infer arbitrary coordinate input or guaranteed reachability.

### Minimal proposed experiment A — recommended first

After installation and a new instruction authorizing implementation:

1. Identify the actual Soldier of Godrick map instance, AI configuration/scripts, and installed game version. Inspect a local ER call site/default handling before choosing omitted or unresolved slots; do not guess IDs or defaults.
2. Select one fixed map region on nearby open, reachable ground, away from the player and outside the soldier's initial stopping radius. Verify its entity ID and position. Use a reversible mod override offline, preserving original files.
3. In one isolated AI action, assign that region to POINT_EVENT using the documented setup and request MoveToSomewhere with center direction, zero directional offset, an explicit small stopping tolerance, and walking. Use locally confirmed values for every required slot and a finite lifetime. Keep the player stationary elsewhere so pursuit cannot explain the movement.
4. Compare an unchanged baseline with the test. Record the call's complete arguments, changed file, source instance/IDs, start and destination, footage, and timeout/arrival outcome. Repeat the same start once.

**Pass:** observable locomotion toward the fixed region and arrival within the chosen tolerance on repeated runs, without teleportation. **Fail/inconclusive:** no movement, wrong destination, interruption, or timeout; investigate setup/execution before rejecting the API. This experiment establishes basic destination movement only; obstacle avoidance and replacement require later tests.

## 2. GOAL_COMMON_MoveFollowPathSpecifyPos

### Exact documented positional parameters

Same indexing convention. Preserve the disagreement rather than filling S1's NONE slots with invented meanings:

| Index | S1 exact label | S2 name; type; displayed default |
|---|---|---|
| 0 | moveTargetAlmostUnused | moveTarget; TARGET; TARGET_ENE_0 |
| 1 | NONE | directionFromTarget; AI_DIR_TYPE; AI_DIR_TYPE_CENTER |
| 2 | stopDistance | stopDist; float; 0 |
| 3 | turnTarget | turnTarget; TARGET; TARGET_ENE_0 |
| 4 | NONE | walk; bool; false |
| 5 | NONE | directionalDistance; float; 0 |
| 6 | x | x; float; 0 |
| 7 | y | y; float; 0 |
| 8 | z | z; float; 0 |

S2 provides a declaration without a behavioral explanation. Its names for slots 1/4/5 do not prove those slots affect execution; S1 marks them NONE. “AlmostUnused” also does not establish when slot 0 matters. Both agree on explicit coordinate slots. [S1](https://soulsmodding.com/doku.php?id=er-refmat:ai-goals-and-params), [S2](https://eladidu.github.io/readable-ds-lua/dd/dac/_goals_8hpp.html)

### Known target types and destination assessment

S2 types both moveTarget and turnTarget as TARGET, defaulting to TARGET_ENE_0. S4 supplies the same shared enum described above. No goal-specific target whitelist or exact-goal usage example was found. POINT_EVENT, POINT_MOVE_POINT, TARGET_SELF, and arbitrary entity IDs must not be described as proven accepted destinations for this goal.

**Documented:** goal presence in the ER list, nine positional slots, explicit x/y/z labels, and S2's typed declaration. **Inference:** a plausible explicit-position movement candidate. **Unverified hypotheses:** that coordinates are an absolute world destination; their frame/units; whether it computes a fresh route or consumes an existing path; required route state; which target is consulted; ignored versus active slots; walk behavior; stopping/completion; obstacle avoidance; dynamic updates and interruption. The name alone cannot settle these questions.

### Minimal proposed experiment B — fixed-coordinate discrimination

After installation and separate implementation authorization, first inspect any local goal implementation/call site to establish safe required arguments, coordinate frame, and route prerequisites. If unresolved, document the experiment as exploratory; do not invent a route API or mandatory placeholder values.

Use the same soldier and open-ground baseline. Choose one recorded destination several steps away from both the soldier and any enemy/target position. Keep the moveTarget/facing references stationary and distinguishable from that destination. Request this goal once with the documented coordinate slots and locally confirmed other arguments, finite lifetime, and small explicit tolerance. Record full arguments, initial route state, coordinates/frame, version, override file and footage; repeat from the same start.

**Pass:** locomotion and arrival at the coordinate location rather than at the target reference. **Fail/inconclusive:** no movement, movement toward the reference, wrong location, or timeout. A failed trial cannot distinguish bad frame/arguments, missing path state, interruption, or unsupported behavior without further evidence. A successful trial proves only this fixed-coordinate case, not arbitrary world navigation or dynamic retargeting.

## Recommendation and stopping point

Start with experiment A: fixed region plus MoveToSomewhere. Its pathing semantics and a region-to-point setup mechanism have stronger documentation than the coordinate goal's behavior. Treat experiment B as the next isolated research test, not an approved architecture. Neither experiment has been implemented or run; M1 is not achieved. Research assignment complete; wait for further user instructions.

## 2026-10-13 — Reusable API library

Created [docs/api/INDEX.md](../docs/api/INDEX.md) with the user's Technical Knowledge Management instructions. Promoted existing findings into [AI goals](../docs/api/ai-goals.md), [related AI functions](../docs/api/ai-functions.md) and [target constants](../docs/api/ai-targets.md). Checked for existing entries first; the prior `docs/ai-goals.md`, `docs/ai-targets.md` and `docs/lua-api.md` files were empty. No new engine behavior was verified. Missing usage examples, source disagreements, displayed-default limitations and current-build uncertainty remain explicit. This update organizes completed research; it does not implement either experiment.
