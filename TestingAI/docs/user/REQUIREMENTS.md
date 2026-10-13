# Project Requirements

## 1. Project Scope

Implement a prototype of League of Legends-style movement and combat within Elden Ring.

The initial controlled character will be Soldier of Godrick.

The prototype must prioritize movement before combat.

## 2. Functional Requirements

### REQ-001 — NPC Control

The prototype must control an NPC rather than relying on Elden Ring's normal player-character movement system.

The initial controlled NPC is Soldier of Godrick.

### REQ-002 — Fixed-Destination Movement

The first milestone must demonstrate that Soldier of Godrick can move toward a predetermined destination through an AI movement behavior.

Success requires observable movement, not instantaneous teleportation.

### REQ-003 — Dynamic Movement

A later milestone must allow the controlled NPC's destination to change while the game is running.

The system must support issuing a new destination before the previous destination is reached.

### REQ-004 — Input-Based Movement

A later milestone must translate custom keyboard or mouse input into movement commands.

The initial input test may use a keyboard key such as X.

The eventual movement system should use right-click commands.

### REQ-005 — Combat Targeting

The eventual system must support selecting an enemy through mouse input.

The controlled NPC should approach the selected enemy and initiate attacks when in range.

### REQ-006 — Command Replacement

New movement commands must be able to replace previous movement commands.

### REQ-007 — Existing Game Systems

Reuse Elden Ring's existing navigation, animations, combat, and AI functionality wherever technically feasible.

Do not implement a completely new pathfinding system unless existing systems prove insufficient and the user approves the change.

## 3. Technical Constraints

### TECH-001 — Game Integrity

Do not directly overwrite original Elden Ring game files.

Use a compatible mod-loading mechanism and maintain recoverable backups.

### TECH-002 — Offline Testing

All gameplay-mod testing must occur offline with anti-cheat protections appropriately disabled through supported methods.

### TECH-003 — Evidence-Based Implementation

Do not invent undocumented Elden Ring API functions.

Distinguish between documented functionality, reverse-engineered findings, hypotheses, and verified in-game behavior.

### TECH-004 — Minimal Experiments

Prefer small, isolated, reversible experiments.

Do not implement later milestones before establishing the necessary technical foundations.

### TECH-005 — Agent Documentation

Codex must maintain its technical findings, progress, blockers, and experiments within the designated agent-controlled directories.

Codex must not modify user-controlled project documents without explicit authorization.

## 4. Preferred Implementation Strategies

The following are research preferences, not mandatory architectural requirements:

- Investigate GOAL_COMMON_MoveToSomewhere.
- Investigate GOAL_COMMON_MoveFollowPathSpecifyPos.
- Investigate AI target-following mechanisms.
- Investigate predefined movement points.
- Consider an invisible target entity if direct destination control is impractical.
- Investigate runtime event commands and AI communication.

No particular approach should be considered verified until successfully tested.

## 5. Development Milestones

### M1 — Fixed Movement
Soldier of Godrick moves toward a predetermined destination.

### M2 — Dynamic Movement
The destination can change during runtime.

### M3 — Keyboard Input
Pressing a specified key causes the soldier to move toward a destination.

### M4 — Mouse Movement
Right-clicking a navigable location commands movement.

### M5 — Combat Targeting
Right-clicking an enemy causes the soldier to approach and attack.

### M6 — Responsiveness
Movement and combat commands can be replaced or interrupted reliably.

## 6. Acceptance Criteria

A milestone is complete only when:

1. The intended behavior is demonstrated in-game.
2. The experiment is reproducible.
3. Modified files and dependencies are documented.
4. Known limitations are recorded.
5. The user confirms the milestone is accepted.

Code compilation alone does not constitute successful implementation.