# Project Decisions

This document records architectural and development decisions approved by the project owner.

Codex must not modify this file without explicit authorization.

Technical discoveries and unapproved recommendations belong in agent-maintained documentation.

---

## DEC-001 — Target Game

**Decision:** Elden Ring

**Status:** Approved

**Rationale:**
Elden Ring provides existing NPC navigation, movement, animation, and combat systems that may be reusable for the intended gameplay modification.

---

## DEC-002 — NPC-Based Control

**Decision:** Control an NPC rather than the normal player character during initial development.

**Status:** Approved

**Rationale:**
NPCs already possess AI-controlled movement and combat behaviors. Reusing these systems may reduce the need to implement new movement and navigation functionality.

**Constraint:**
Do not switch to a player-character-based approach without approval.

---

## DEC-003 — Initial Test Character

**Decision:** Use Soldier of Godrick.

**Status:** Approved

**Rationale:**
Provides a relatively simple humanoid enemy for early movement and combat experiments.

---

## DEC-004 — Development Order

**Decision:** Implement movement before combat.

**Status:** Approved

**Order:**
1. Fixed-destination movement
2. Dynamic destination updates
3. Keyboard-controlled movement
4. Mouse-controlled movement
5. Mouse-controlled combat

**Rationale:**
Movement is a foundational dependency for the intended combat system.

---

## DEC-005 — Reuse Existing AI Systems

**Decision:** Prioritize existing Elden Ring AI and navigation systems.

**Status:** Approved

**Rationale:**
The project should investigate reusing NPC movement and targeting behaviors rather than building an entirely new navigation system.

**Exception:**
Alternative implementations may be proposed if existing systems prove inadequate, but major architectural changes require approval.

---

## DEC-006 — Modding Tools

**Decision:** Begin development using the following tools:

- Smithbox
- WitchyBND
- DSLuaDecompiler
- ModEngine or a compatible successor
- Visual Studio Code
- Codex

**Status:** Approved as the initial toolchain

**Note:**
Additional tools may be introduced when technically necessary. Compatibility must be verified.

---

## DEC-007 — Agent Communication Architecture

**Decision:** Separate user-controlled project instructions from Codex-maintained working memory.

**Status:** Approved

**User-controlled files:**
- user/VISION.md
- user/REQUIREMENTS.md
- user/DECISIONS.md
- AGENTS.md

**Agent-controlled files:**
- agent/STATE.md
- agent/PROGRESS.md
- agent/RESEARCH.md
- agent/EXPERIMENTS.md
- agent/BLOCKERS.md
- agent/tempHandoffs/

**Rationale:**
Preserve project ownership, maintain continuity between sessions, and prevent technical assumptions from silently becoming requirements.

---

## DEC-008 — Documentation Format

**Decision:** Use Markdown for project instructions, research, and agent handoffs.

**Status:** Approved

**Rationale:**
Markdown supports structured documentation, code examples, version control, and efficient reading by coding agents.

---

## Open Architectural Questions

The following are NOT approved implementation decisions:

- Whether MoveToSomewhere is sufficient for movement control.
- Whether MoveFollowPathSpecifyPos supports the required coordinate-based navigation.
- Whether an invisible target NPC is necessary.
- Whether runtime movement control requires a custom DLL.
- Whether NPC AI commands can be reliably updated while the game is running.

Codex should investigate these questions and report evidence before recommending an implementation.

---

## Decision Change Policy

Any change to an approved decision requires explicit user authorization.

Codex may recommend changes but must not silently revise approved decisions.