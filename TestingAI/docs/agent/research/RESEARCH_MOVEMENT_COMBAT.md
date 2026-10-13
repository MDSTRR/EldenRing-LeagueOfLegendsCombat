# Elden Ring — Movement and Combat Architecture Research

**Document Type:** Agent-maintained technical research  
**Status:** Preliminary investigation  
**Initial Character:** Soldier of Godrick  
**Primary Objective:** League of Legends-style movement and combat through NPC control

**2026-10-13 evidence update:** This document's architecture remains preliminary. The completed battle analysis at [GODRICK_SOLDIER_AI.md](../../docs/analysis/GODRICK_SOLDIER_AI.md) provides current local call-site evidence and refines the first test to fixed-region ApproachTarget. No controller architecture or gameplay behavior has been verified.

---

## 1. Research Objective

Investigate how to implement a responsive mouse-controlled movement and combat system in Elden Ring by controlling an NPC rather than the standard player character.

The intended system must eventually support:

- Right-clicking the ground to move toward a destination.
- Right-clicking an enemy to approach and attack it.
- Replacing an existing movement command with a new command.
- Interrupting movement to initiate combat.
- Canceling or redirecting an attack command with a movement command.
- Reusing Elden Ring's existing navigation, locomotion, animation, and combat systems wherever feasible.

The initial prototype uses Soldier of Godrick.

This document evaluates possible technical approaches. It does not establish final architectural decisions.

User-controlled requirements and decisions take precedence over this research.

## 2. Core Architectural Principle

Separate command interpretation from game execution.

The proposed architecture is:

```text
Mouse / Keyboard Input
          |
          v
Input Interpreter
          |
          v
Command Controller
          |
          +----------------------+
          |                      |
          v                      v
    Move Command           Attack Command
          |                      |
          v                      v
   Destination Target      Enemy Target
          |                      |
          +-----------+----------+
                      |
                      v
             NPC Control Adapter
                      |
                      v
             Elden Ring AI /
             Navigation Systems
                      |
                      v
              Locomotion /
             Combat Animations
```

The command controller is a proposed component of our implementation, not an existing Elden Ring API.

The goal is to identify the most effective way for the NPC Control Adapter to communicate with Elden Ring.

## 3. Shared Command System

Movement and combat should not be implemented as entirely independent input systems.

Both should be interpreted through a shared command interface.

### 3.1 Proposed Commands

```cpp
// Conceptual interfaces, not Elden Ring APIs.

MoveTo(Vector3 destination);

AttackTarget(EntityId target);

CancelCurrentCommand();
```

These functions describe desired behavior. Their implementation depends on discoveries about Elden Ring's runtime systems.

### 3.2 Right-Click Interpretation

When a right-click occurs:

1. Detect the mouse input.
2. Determine which object or world position was clicked.
3. Check whether the clicked object is a valid hostile target.
4. If a valid hostile target was selected, issue an attack command.
5. Otherwise, if a navigable ground position was selected, issue a movement command.
6. If neither condition applies, reject the command or apply an explicitly defined fallback.

This requires investigation into screen-to-world raycasting, entity identification, target classification, and navigable ground detection.

### 3.3 Command Replacement

The controller must eventually support replacing commands during execution.

Example:

```text
Move to A
    |
    | New right-click
    v
Cancel / replace movement
    |
    v
Move to B
    |
    | Enemy selected
    v
Approach enemy
    |
    v
Attack when in range
```

Command replacement must be tested independently of initial movement success.

## 4. Candidate Movement Approaches

### Approach A — GOAL_COMMON_MoveToSomewhere

**Level:** High-level AI goal  
**Status:** Documented candidate; untested in project

Elden Ring's community AI documentation identifies `GOAL_COMMON_MoveToSomewhere` as a movement goal.

Potentially useful for moving an NPC toward a recognized AI target or position reference.

#### Advantages

- Reuses existing NPC AI goal infrastructure.
- May preserve navigation and locomotion behavior.
- Potentially straightforward to integrate into an existing AI script.
- Provides a useful baseline for measuring responsiveness.

#### Constraints

- Requires a valid movement target.
- Does not establish direct arbitrary-coordinate input.
- May be interrupted or replaced by normal NPC decision-making.
- Goal lifetime and completion behavior must be investigated.
- Repeated command updates may cause undesirable goal restarts.

#### Research Questions

- Can active movement goals be replaced immediately?
- Can their targets be updated without restarting the goal?
- How frequently does the AI evaluate movement requests?
- Does the NPC preserve pathfinding when goals change?
- What happens if the target becomes unreachable?

### Approach B — GOAL_COMMON_MoveFollowPathSpecifyPos

**Level:** AI goal with explicit position arguments  
**Status:** Documented candidate; semantics unverified

Community documentation lists a movement goal named `GOAL_COMMON_MoveFollowPathSpecifyPos` with `x`, `y`, and `z` arguments.

#### Potential Advantage

May permit destination-based movement without introducing an additional target entity.

#### Constraints

- Coordinate interpretation is not verified.
- The function may require a predefined path or route.
- Obstacle avoidance and navigation behavior are unknown.
- Runtime coordinate updates are not established.

#### Research Questions

- Are coordinates expressed in world space?
- Does the function calculate a path?
- Can it be used with Soldier of Godrick?
- Does it support dynamic destination changes?
- Can it be interrupted or replaced reliably?

Do not assume that explicit coordinate arguments guarantee general-purpose pathfinding.

### Approach C — Invisible Target Entity

**Level:** Target-based AI control  
**Status:** Architectural hypothesis

Create or reuse a target entity that the controlled NPC is instructed to follow.

Movement commands reposition the target entity.

Conceptual behavior:

```text
Right-click position
        |
        v
Relocate invisible target
        |
        v
NPC follows target
        |
        v
NPC approaches destination
```

#### Advantages

- May reuse existing target-following AI.
- Could support dynamic movement through target relocation.
- Avoids passing coordinates directly into NPC AI goals.

#### Constraints

- Requires a valid follow target.
- The target must not interfere with gameplay.
- Target visibility, collision, faction, and targeting properties must be configured appropriately.
- Teleporting the target may not automatically update the follower's navigation.
- The NPC may treat the target as an enemy instead of a navigation destination.

#### Research Questions

- Can an NPC follow another arbitrary NPC?
- Can a noncombat target be created?
- Can its position be modified at runtime?
- Does the follower automatically recalculate its route?
- What happens when the target moves repeatedly?

### Approach D — Map Region / Event Movement

**Level:** AI target and event system  
**Status:** Candidate requiring Elden Ring-specific verification

Investigate predefined movement points, map regions, and event movement targets.

Relevant concepts include:

- `POINT_EVENT`
- `POINT_MOVE_POINT`
- `SetEventMoveTarget`
- `GOAL_COMMON_ApproachTarget`

Some examples originate from older Souls games. Their compatibility with Elden Ring must be verified.

#### Advantages

- Potentially simpler than creating a dynamic target NPC.
- Suitable for fixed-destination experiments.
- May integrate with existing event systems.

#### Constraints

- Static regions may not support arbitrary mouse destinations.
- Runtime repositioning may require additional mechanisms.
- AI event requests may carry limited command data.

### Approach E — Lower-Level Lua Movement Operations

**Level:** Lower-level AI scripting interface  
**Status:** Requires function availability and signature verification

Investigate movement-related operations such as:

- `MoveTo`
- `MoveToEventPoint`
- `FollowPath`

These names appear in community Souls AI references, but Elden Ring compatibility and exact behavior must be verified individually.

#### Potential Advantages

- May bypass unnecessary high-level goal behavior.
- Could provide more direct control over movement requests.
- May improve command replacement behavior.

#### Constraints

- Function signatures may differ between games.
- Lower-level operations may require additional state management.
- Direct operations may interfere with normal AI goals.
- Reduced abstraction does not guarantee lower latency.

### Approach F — Runtime Navigation Hooks

**Level:** Engine/runtime integration  
**Status:** Advanced research option

Investigate whether internal Elden Ring navigation or character movement interfaces can be accessed through a runtime extension.

A custom C++ component could potentially deliver movement requests directly to an NPC's navigation system.

#### Potential Advantages

- Greater control over command timing.
- Potential access to active navigation destinations.
- Possible support for direct runtime destination updates.

#### Constraints

- Requires reverse engineering.
- Internal APIs may be undocumented.
- Game updates may break offsets, signatures, or hooks.
- Incorrect calls may crash the game.
- Bypassing too much AI logic may interfere with locomotion and animation.

Directly modifying character position every frame is not considered an acceptable substitute for functional navigation.

## 5. Candidate Combat Approaches

Combat introduces additional problems beyond movement.

### Approach G — Existing NPC Combat AI

**Status:** Preferred initial combat research direction

Reuse the controlled NPC's existing attack selection, range checks, animations, and damage systems.

Potential process:

1. Identify a hostile entity.
2. Assign it as the controlled NPC's attack target.
3. Make the NPC approach the target.
4. Allow the existing combat AI to initiate attacks.
5. Support replacing the attack command with movement.

#### Questions

- Can the NPC's enemy target be assigned programmatically?
- Can the NPC attack an arbitrary selected enemy?
- Can its normal combat AI be activated without ordinary aggro?
- Can combat be interrupted by a new movement command?
- Does the NPC automatically reposition when its target moves?

### Approach H — Explicit Attack Goals

**Status:** Research candidate

Investigate Elden Ring AI attack goals and attack-selection logic.

Rather than allowing the NPC to select all combat behavior independently, the custom controller may request particular attack actions.

#### Potential Advantages

- Greater control over attack timing.
- Potentially more predictable command execution.
- Better alignment with MOBA-style attack commands.

#### Constraints

- Attack animations may impose recovery and commitment periods.
- Combat range must be evaluated.
- Attacks may require specific animation or behavior states.
- Damage and targeting must remain compatible with Elden Ring.

### Approach I — Runtime Combat Hooks

**Status:** Advanced fallback

Investigate direct control over target assignment, attack requests, and combat state transitions.

This approach may provide greater control but requires significantly more reverse engineering.

## 6. Event Communication

Investigate Elden Ring's EMEVD event system as a possible communication mechanism between external control logic and NPC AI scripts.

Relevant documented concepts include:

```text
RequestCharacterAICommand
GetEventRequest
```

Potential architecture:

```text
Custom Input
     |
     v
Runtime Event Trigger
     |
     v
EMEVD / AI Command
     |
     v
NPC Lua Script
     |
     v
Movement or Attack Goal
```

### Limitations

- EMEVD does not automatically capture arbitrary keyboard or mouse input.
- AI event requests may not support arbitrary coordinate payloads.
- Communication latency and update frequency require testing.
- Runtime integration may still require a custom extension.

## 7. Responsiveness Research

The project prioritizes responsiveness, but lower-level control must not automatically be assumed superior.

The preferred interface is the lowest-level practical interface that preserves reliable navigation, collision, locomotion, and animation.

### Metrics

Measure:

- Input-to-visible-movement latency.
- Time required to change direction.
- Time required to stop.
- Time required to replace an active movement command.
- Time required to switch from movement to combat.
- Time required to cancel or redirect combat.
- Pathfinding reliability.
- Frequency of stuck or failed navigation.
- Animation consistency.

### Experimental Method

For each viable implementation:

1. Issue a movement command.
2. Observe when the NPC begins moving.
3. Issue another destination before arrival.
4. Observe whether movement redirects.
5. Repeat under comparable conditions.
6. Test navigation around obstacles.
7. Record successes, failures, and observed delays.

Use recorded footage or instrumentation when practical. Do not invent latency measurements.

## 8. Comparative Research Matrix

| Approach | Navigation reuse | Dynamic destination potential | Combat integration | Main risk |
|---|---|---|---|---|
| MoveToSomewhere | Likely | Unknown | Potentially strong | Goal interruption |
| MoveFollowPathSpecifyPos | Unknown | Possible | Requires integration | Path semantics |
| Invisible target | Likely if follow AI works | Possible | Target-system reuse | Target assignment |
| Map region | Potential | Limited/unknown | Indirect | Static destination |
| Lower-level Lua | Unknown | Possible | Potential | API availability |
| Runtime hooks | Depends on interface | Potentially strong | Potentially strong | Reverse engineering |

These are qualitative research expectations, not experimentally verified performance rankings.

## 9. Proposed Unified NPC Controller

The long-term architecture should abstract the underlying implementation.

Conceptual C++ interface:

```cpp
enum class CommandType {
    None,
    Move,
    Attack
};

struct CharacterCommand {
    CommandType type;
    Vector3 destination;
    EntityId target;
};

class NPCController {
public:
    void IssueMove(Vector3 destination);
    void IssueAttack(EntityId target);
    void CancelCommand();
    void Update();
};
```

`Vector3` and `EntityId` are conceptual project types.

This interface is not an Elden Ring API.

The implementation may use AI goals, event scripts, target entities, runtime hooks, or a combination.

The benefit is that the input system does not need to know which movement implementation is being used.

## 10. Proposed Development Experiments

### EXP-001 — Identify Soldier AI

Locate Soldier of Godrick's actual character configuration, AI identifiers, and relevant scripts.

**Success:** Relevant game resources are identified with supporting evidence.

### EXP-002 — Fixed Movement Goal

Make Soldier of Godrick move toward a predetermined target or point using an AI goal.

**Success:** The NPC visibly navigates toward the destination without relying on normal player aggro.

### EXP-003 — Direct Coordinate Movement

Test whether a documented movement goal supports specified coordinates.

**Success:** The NPC navigates to a specified reachable coordinate.

### EXP-004 — Dynamic Target Updating

Change the NPC's movement destination while it is already moving.

**Success:** The NPC redirects toward the new destination.

### EXP-005 — Command Interruption

Issue a second movement command before the first completes.

**Success:** The new command reliably supersedes the previous command.

### EXP-006 — Input Communication

Connect a keyboard input to a previously verified movement mechanism.

**Success:** Pressing X triggers the expected movement.

### EXP-007 — Enemy Target Assignment

Make the controlled NPC recognize a selected enemy as its combat target.

**Success:** The NPC approaches and attacks the selected entity.

### EXP-008 — Movement / Combat Switching

Alternate between movement and attack commands.

**Success:** The NPC transitions between navigation and combat without becoming stuck or ignoring subsequent commands.

### EXP-009 — Mouse-Based Command Selection

Determine whether a right-click selects navigable ground or an enemy.

**Success:** Ground clicks issue movement commands; valid enemy clicks issue attack commands.

## 11. Research Priorities

### Priority 1 — Establish Basic Movement

Investigate:

- GOAL_COMMON_MoveToSomewhere
- GOAL_COMMON_MoveFollowPathSpecifyPos
- POINT_EVENT / POINT_MOVE_POINT

Goal: Demonstrate movement toward a predetermined destination.

### Priority 2 — Investigate Dynamic Control

Investigate:

- Movement-goal replacement
- Target relocation
- Lower-level Lua movement operations
- Navigation destination updates

Goal: Redirect movement during runtime.

### Priority 3 — Investigate Combat

Investigate:

- Enemy target assignment
- Attack goals
- Combat state transitions
- Attack range and pursuit behavior

Goal: Reuse NPC combat through externally supplied targets.

### Priority 4 — Integrate Custom Input

Investigate:

- Keyboard input detection
- Mouse input detection
- Screen-to-world raycasting
- Enemy entity selection
- Runtime communication with NPC AI

Goal: Implement the unified right-click command system.

## 12. Documentation and Verification Rules

Codex must distinguish:

**Verified:** Reproduced in the actual game or confirmed through direct implementation inspection.

**Documented:** Supported by a cited reference but not yet tested in this project.

**Hypothesis:** Plausible but lacking sufficient evidence.

**Disproven:** Contradicted by reproducible testing or stronger technical evidence.

For every significant technical discovery, record:

- Relevant function or system.
- Source URL or file path.
- Game version, if known.
- Function parameters.
- Constraints.
- Verification status.
- Reproduction procedure.
- Outstanding questions.

Do not assume documentation from other FromSoftware games applies unchanged to Elden Ring.

## 13. References

### Elden Ring AI Goals
https://soulsmodding.com/doku.php?id=er-refmat:ai-goals-and-params

### Souls AI Lua Reference
https://soulsmodding.com/doku.php?id=common-refmat:lua_functions

### AI Common Function Repository
https://soulsmodding.com/doku.php?id=common-refmat:lua_ai_common_function_repository

### Souls Modding Wiki
https://www.soulsmodding.com/

### Smithbox
https://github.com/vawser/Smithbox

### WitchyBND
https://github.com/ividyon/WitchyBND

## 14. Current Conclusion

The most promising strategy is to separate custom command interpretation from NPC navigation and combat execution.

No final movement implementation has been selected.

High-level AI goals provide a practical starting point, but direct coordinate movement, target-following behavior, lower-level Lua operations, and runtime navigation interfaces should be investigated before committing to an architecture.

The immediate next task is to identify Soldier of Godrick's actual AI resources and establish a reproducible fixed-destination movement experiment.
