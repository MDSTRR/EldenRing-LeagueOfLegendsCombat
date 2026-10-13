# Experiment 002 — Observable NPC AI Override

Experiment 001 completed its preliminary in-game compatibility test.

The game launched through ModEngine 2 with the compiled-source archive installed. A spear-wielding Godrick Soldier detected, approached, and attacked the player normally. This is not definitive proof that the custom Lua was loaded.

Proceed with Experiment 002.

## Objective

Demonstrate that modifying `431030_battle.lua` can produce a clearly observable, reversible behavior change in a Godrick Soldier using battle goal `431030`.

This experiment is NOT yet about League of Legends controls, mouse input, or arbitrary-coordinate navigation.

## Requirements

1. Review the validated Experiment 001 pipeline and the existing analysis of `431030_battle.lua`.
2. Verify the selected NPC's battle-goal assignment from available project evidence. Do not assume the Soldier of Godrick tutorial boss uses this script.
3. Identify the smallest reliable change to `Goal.Activate` or its action-selection logic that produces a distinctive behavior.
4. Prefer a deterministic, nonlethal change, such as repeatedly approaching without attacking, if the existing APIs support it.
5. Account for interrupts, existing subgoals, and action-selection logic so the modification is not immediately overridden.
6. Preserve the original source and archive. Work on disposable copies under `TestingAI/build/experiment002/`.
7. Compile using the already validated Lua 5.0 compiler.
8. Prepare a WitchyBND binder folder for interactive repacking if necessary.
9. Prepare a ModEngine 2 deployment directory, but do not modify my external ModEngine 2 installation.
10. Document exactly how to run an A/B test: original behavior with the override disabled versus modified behavior with the override enabled.
11. Record assumptions, expected observations, possible failure modes, and rollback instructions.
12. Update the agent-owned experiment report, status notes, and handoff.

Do not modify user-owned planning documents, install new tools, launch Elden Ring, commit, or push.

Stop if you cannot identify a sufficiently reliable, observable behavior change. Do not invent undocumented AI functions.

## Success criterion

The same NPC exhibits normal behavior without the override and the predicted altered behavior with the override, reproducibly.

This will establish that our custom Lua is being executed in-game.