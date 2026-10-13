# Current state

Updated 2026-10-13. Handoff004 analysis/documentation complete. No gameplay implementation/repack/test; M1 unachieved.

- User confirmed Smithbox instance c4311_9007, model c4311, entity 18000257, map m18_00_00_00, NpcParam/NpcThinkParam 43114006, logicId 10000, position (-102.524, 2.849, 157.056). Tutorial-boss identity unknown; approved prototype character unchanged.
- Handoff004 reports battleGoalID431030 and successful tool setup/extraction/decompilation. Fully read TestingAI/decompiled/431030_battle.lua (1044 lines); confirmed binder manifest and symbolic registration. Param-row mapping remains user-reported.
- Script uses weighted enemy-relative approach/circling/retreat/turn and attacks; interruptions replace queues. No requested coordinate/pathing candidate occurs in this battle text. Shared logic/common archives now exist but no readable counterparts supplied; no unpacking performed.
- Detailed catalog/line references: docs/analysis/GODRICK_SOLDIER_AI.md. Source anomalies documented, not repaired. Check docs/api/INDEX.md before future API research; read relevant entries only.
- First experiment proposal refined to documented SetEventMoveTarget/POINT_EVENT plus observed ApproachTarget, adapting main Activate/Act13. Fixed region distinct from enemy; no arbitrary-coordinate or obstacle-navigation claim. Shared431030 override affects other users of that goal.
- Prerequisites: reachable region ID, identity, shared registration/update evidence, game build, compatible bytecode compilation/unchanged round-trip, actual ModEngine config/root and offline loading. No new tool installation or Steam access authorized/performed.
- Git cleanup completed: tools/extracted/decompiled assets, map DCX and regulation binaries excluded and untracked from parent index; local files retained. Nested DSLuaDecompiler/SoulsFormats repositories untouched. Documentation/source/config tracking retained; no commit/push. User-controlled files unchanged.
- Active handoffs: none; handoff004 marked completed, earlier handoffs historical/deferred. Await instruction to implement/test only the first fixed-destination experiment; no input/camera/combat development.
