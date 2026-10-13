# Handoff 001 — Investigate Soldier of Godrick's AI

## Objective

Identify how Soldier of Godrick's movement AI is implemented in Elden Ring.

Do not implement any modifications yet.

## Context

We are investigating whether Elden Ring's existing NPC AI can be reused to implement externally controlled movement.

Our first milestone is making Soldier of Godrick navigate toward a predetermined destination.

## Tasks

1. Identify Soldier of Godrick's character configuration and AI identifiers.
2. Locate the relevant AI script files.
3. Determine which movement goals or operations its AI uses.
4. Investigate whether the AI can receive a custom movement destination.
5. Identify the smallest possible experiment that would demonstrate externally controlled movement.

## Candidate Function

Investigate `GOAL_COMMON_MoveToSomewhere` if relevant.

Do not assume it is the correct solution.

Other approaches may be documented if discovered, but do not implement them.

## Constraints

- Do not modify original game files.
- Do not write implementation code.
- Do not create a generalized movement controller.
- Do not begin combat implementation.
- Do not assume undocumented APIs exist.
- Clearly distinguish verified findings from hypotheses.

## Deliverables

Update:

- `agent/RESEARCH.md` with technical findings and source references.
- `agent/PROGRESS.md` with completed investigation steps.
- `agent/BLOCKERS.md` with unresolved technical obstacles.
- `agent/STATE.md` with the next recommended experiment.

## Completion Criteria

The assignment is complete when we know which files and systems control Soldier of Godrick's movement, or have documented why they could not be identified.

Present the findings and the proposed first experiment for user approval before implementing anything.