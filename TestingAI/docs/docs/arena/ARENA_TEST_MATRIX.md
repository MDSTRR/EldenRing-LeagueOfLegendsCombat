# Arena verification matrix

2026-10-13. Proposed checks only; **no arena test was run**. [Evidence](PLACIDUSAX_ARENA_FEASIBILITY.md) | [Plan](ARENA_IMPLEMENTATION_PLAN.md).

**REASONABLE INFERENCE:** the criteria below separate access, encounter isolation, navigation and arrival behavior. **UNVERIFIED — REQUIRES IN-GAME TESTING:** every runtime row until evidence is recorded. User-reported Experiment003 success applies to m18, not this arena.

| Gate | Check | Pass evidence | Failure / next action |
|---|---|---|---|
| S0 | Current-build provenance | Version, tool versions, original hashes and published-ID correspondence recorded | Missing m13 reference or version mismatch: stop for a local read-only audit |
| S1 | MSB references and uniqueness | New IDs collision-free; model/param/collision/draw/region references resolve after readback; unrelated parts unchanged | Repair disposable copy only; no forced hash acceptance |
| S2 | Encounter isolation | All boss/group/flag callers audited; death/reward consumers cannot fire; non-Placidusax logic retained | Unknown initializer or fog/boundary dependency: stop before deployment |
| S3 | Navigation inspection | NVA/HKX instances/triangles and collision at spawn/D1 height identified and connected | Missing/unsupported evidence: mark inconclusive; do not claim flat floor proves coverage |
| S4 | Lua/binder verification | Compatible header, intended source delta, fresh payload/hash/entry/metadata readback, unchanged LUAGNL | Any mismatch: stop; preserve failed artifacts/evidence |
| R0 | Empty-arena entry | Explicit hub interaction arrives on stable floor; map objects/collision remain loaded; no looping warp | Fall/unloaded floor/wrong layer: return safely and investigate streaming/Player part |
| R1 | Encounter suppression | No Placidusax, health bar, boss music, forced cutscene/camera/weather or reward banner while walking through trigger region and waiting | Record trigger and source event; no defeat-flag shortcut |
| R2 | Safe return/re-entry | Return reaches verified hub start; repeated entry works without progression/grace/respawn flag changes | Stop if trapped or a save-state side effect appears |
| R3 | Soldier loading/activation | Exactly one correct c4311 soldier appears, remains loaded and activates without attacking | Diagnose model/draw/Think/logic/activation separately from navmesh |
| R4 | One-point navigation | Soldier traverses unobstructed3–5m to D1 using native approach; player stands off-route; same endpoint from different player positions | Stalling may be activation, target lookup, collision or navigation; gather evidence before blaming navmesh |
| R5 | Arrival behavior | Record tolerance, elapsed time and next30seconds independently | Drift/shared reaction logged separately; do not overwrite Agent1's arrival experiment |
| R6 | D2/D3 connectivity | Forward, lateral and reverse routes succeed without falling/stalling; player movement does not select endpoint | Keep failed destinations disabled; inspect connectivity/clearance/target projection |
| R7 | Repeatable reset | Three leave/reload/re-entry cycles restore spawn, selected destination and activation; also document death behavior | Distinguish goal/state/death reset; reloading is not assumed sufficient |
| R8 | Isolation regression | Original m18 soldier and other users of431030 remain unchanged; Maliketh/Godskin events unchanged in source diff | Broad goal or event edits: roll back and isolate |
| R9 | A/B/A rollback | A=original override set, B=arena set, A=exact restored set; hashes/config restored and baseline behavior returns | Stop on unknown current files; never overwrite another experiment blindly |

## Manual runtime protocol for a later authorized test

**REASONABLE INFERENCE:** use a disposable backed-up save, offline with anti-cheat disabled, and a dedicated override root. Record exact staged and deployed hashes/configuration before each phase. Test R0–R2 without a soldier first; then R3–R5 with one destination. Do not add UI, multiple NPCs or arbitrary coordinate control to diagnose a failed gate.

Capture game version, override hashes, save's prior boss state, entry route, start/destination IDs and coordinates, player position, activation trigger, video of path/arrival, time to destination, reload results and any flag/UI/weather changes. A visible success once does not establish repeatability. Do not toggle boss flags to compare defeated/undefeated states; use already differing backed-up disposable saves if that comparison is needed and authorized.

## Rollback design

**REASONABLE INFERENCE:** before future deployment, back up every existing file at each proposed override path and the active ModEngine config, noting paths that were absent. Keep this arena root separate from prior experiments. Exit the game before changing overrides. Restore exact original config/overrides by recorded hashes; disable the arena root or move newly added files into a workspace quarantine instead of deleting references. Restore the prior hub/map/event/regulation/Lua set together. A file rollback does not undo progression written to a save; this is why forced defeat flags are excluded and disposable save provenance is required.

No installation or save operation was performed here. Exact rollback commands depend on the future built override set and configuration and must be prepared at that stage.
