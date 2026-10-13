# Related AI movement functions

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
