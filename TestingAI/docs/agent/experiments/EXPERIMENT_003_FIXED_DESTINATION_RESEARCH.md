# Experiment003 — fixed destination research and proposed region test

2026-10-13. **Research complete; region-based prototype proposed, not implemented or deployed.** Direct coordinate navigation is not established. This report honors the instruction to report the best supported alternative before implementing it.

## Established project result

User now confirms Experiment002 passed the offline A/B/A test: the Godrick spear soldier approached without initiating melee, and disabling the override restored attacks. This establishes the observed behavior change for the tested setup; game build/timings/video were not supplied here. It does not verify any new region or coordinate goal. Prior static integrity/recovery evidence remains unchanged. Repository cleanup remains deferred.

## Destination

- Map `m18_00_00_00`, NPC entity `18000257`, ThinkParam `43114006`, battle goal `431030`.
- User-supplied spawn `(-102.524, 2.849, 157.056)`.
- User-supplied destination `(-108.095, 3.183, 150.961)` in the same Smithbox map coordinate frame.
- Computed horizontal displacement8.2574 units; elevation difference+0.334. Reachability/navmesh projection and actual in-game floor position remain unverified.

## Research evidence

Local soldier source and Experiment002 source contain enemy-target ApproachTarget, not SetEventMoveTarget/POINT_EVENT/coordinate-goal calls. Original extracted logic/common paths are absent after cleanup; backup Git objects retain them, but they were not regenerated/decompiled during this research. Existing SoulsFormats assembly lacks a full MSBE type. No installed game assets were accessed.

Scanned **529/529 Lua text files successfully**, with zero retrieval failures, in public [EldenRingAI revision3b3efb0](https://github.com/zoloypzuo/EldenRingAI/tree/3b3efb00219026dfba4663b9eb1a1afd94c0a68e). Only matching files and two relevant common helpers were saved under `TestingAI/build/experiment003/research/public-ai-3b3efb0/`; per-file URL/hash/size/search results are in `search-ledger.json`. These are external decompiled examples with unspecified game build/provenance, not this installed build's verified code.

| Concrete source | Finding and limit |
|---|---|
| [npc_whiteghost_battle.dec.lua](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/npc_whiteghost_battle.dec.lua), lines96–104 and121–130 | Sets event movement target from stored `NPC_PointFrontWall`, then queues ApproachTarget toward POINT_EVENT. Its surrounding `POINT_EVENT <= 0.3` comparison looks suspect; do not copy that branch or infer reliable arrival logic from it. |
| [030000_logic.dec.lua](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/030000_logic.dec.lua), lines16–19 | Tests GetDist(POINT_EVENT)<=0.3; otherwise AddTopGoal ApproachTarget targets POINT_EVENT. Shows target-distance use, not where its event point was assigned. |
| [407000_battle.dec.lua](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/407000_battle.dec.lua), Wolf407000_Act28 lines756–764 | Measures POINT_EVENT distance and uses it as the movement target of ApproachSettingDirection. Different goal; not evidence of direct coordinate slots. |
| [400000_battle.dec.lua](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/400000_battle.dec.lua), line672 | ApproachTarget moves toward TARGET_EVENT but faces POINT_EVENT. Demonstrates that movement/facing slots differ; TARGET_EVENT is not an alias for POINT_EVENT. |
| [approach_target.dec.lua](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/approach_target.dec.lua), lines7–24 | Forwards its target/stop distance/walk/facing arguments to MoveToSomewhere, then handles guarding. This is a native path-goal chain, not a teleport or custom pathfinder. |
| [move_to_point.dec.lua](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/move_to_point.dec.lua), lines33–41,47–63 | MoveToMultiPoint sets event targets, measures POINT_EVENT distance, and queues MoveToPoint. The update combines queue state and a distance test, but contains ambiguous target parameters; no new goal signature inferred from it. |
| [goal_list.dec.lua](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/goal_list.dec.lua), line733 | MoveFollowPathSpecifyPos=2024 is defined; no invocation found in the529-file scan. Absence is limited to this snapshot. |

The [ERAiAPI goal declaration](https://eladidu.github.io/readable-ds-lua/dd/dac/_goals_8hpp.html) documents MoveFollowPathSpecifyPos slots `moveTarget, directionFromTarget, stopDist, turnTarget, walk, directionalDistance, x, y, z`. Coordinate frame, path prerequisites and fresh path generation are not explained; existence/slot names do not establish direct world-coordinate navigation. ApproachTarget has target/distance/facing/walk/guard slots, not Vector3 or x/y/z slots. See existing [goal reference](../../docs/api/ai-goals.md).

## Selected mechanism and exact proposed call shape

**Recommend a real MSB point region at the chosen position, assigned through SetEventMoveTarget, then reuse Experiment002 ApproachTarget.** The [ER reverse-engineering reference](https://eladidu.github.io/readable-ds-lua/d1/d81/class_ai_func.html) declares `void SetEventMoveTarget(unsigned int regionId)` and identifies its output as POINT_EVENT. Combined with the concrete white-ghost example, this supports a region-targeted experiment. Native lookup and this soldier's region-target behavior remain untested locally.

The proposed callback body, shown as design evidence only:

```lua
-- destinationRegionEntityId must be the new region's confirmed EntityID.
ai:SetEventMoveTarget(destinationRegionEntityId)
goal:ClearSubGoal()
goal:AddSubGoal(GOAL_COMMON_ApproachTarget, 10, POINT_EVENT, 0.5, TARGET_SELF, true, 9910)
```

No numeric ID has been selected or assumed free. `destinationRegionEntityId` is a proposed local variable, not a new engine global/API. Setter receives one unsigned entity identifier. AddSubGoal supplies goal ID, lifetime10, move targetPOINT_EVENT, stop distance0.5, facingTARGET_SELF, walktrue, guard9910. Lifetime/guard/facing/walk are retained from Experiment002; smaller stop distance0.5 is an experimental choice. No omitted trailing defaults are invented. Preserve Experiment002 pseudo-global setup/observer cleanup and returnfalse interrupt isolation; leave Initialize/Update/registration/action helpers intact initially. Only main Activate needs another change.

Resolution chain: **map region EntityID → SetEventMoveTarget → POINT_EVENT target slot → ApproachTarget → native MoveToSomewhere/pathing**. Coordinates live in the map region, not in the Lua goal call. Passing NPC18000257, ThinkParam43114006, region list index, RegionID, a name string or a Vector3 to the setter would be incorrect for this proposal.

Other alternatives: POINT_INITIAL is a native spawn/home reference but cannot represent the chosen destination without changing other state. SetAIFixedMoveTarget defines an endpoint relative to a target and direction, not an absolute XYZ setter; it is less direct for this fixed location. MoveToEventPoint is documented but introduces another primitive with no local validation, so it is unnecessary for the first test. No invisible NPC, event-script rewrite or executable change is needed for the region proposal.

## Read-only workspace map findings

Workspace `TestingAI/map/mapstudio/m18_00_00_00.msb.dcx`: SHA256 `65183A0F099111C1CF48A8C81F0A9A74083596F2FD7527891B703878A28CCF7A`,254348 bytes. Existing DCX library decompressed it in memory; a bounded reader based on [MSBE section layout](https://github.com/soulsmods/SoulsFormatsNEXT/blob/master/SoulsFormats/Formats/MSB/MSBE/MSBE.cs) and [region layout](https://github.com/soulsmods/SoulsFormatsNEXT/blob/master/SoulsFormats/Formats/MSB/MSBE/PointParam.cs) inventoried324 regions. This is limited metadata inspection, not complete MSBE validation, editing or installed-map provenance verification.

Found132 point shapes and57 regions with nonzero EntityID; no center matches the requested XYZ within0.01 units. Nearest addressable center is18002659 at(-107.271,1.681,148.568),2.53 horizontal units away, a tutorial box;18002201 is another box3.39 units away. Neither represents the exact destination and neither should be relocated. All324 RegionIDs were distinct, maximum9062. Source describes RegionID as *presumed* unique per map; it is separate from entity identity. No global EntityID collision scan was performed across parts/events/other loaded maps.

Inventory and reader: `TestingAI/build/experiment003/research/workspace-region-inventory.json`, `inspect-regions.ps1`. Input map hash remained unchanged. Region subtypeOther and point shape are present locally, but their suitability for the new AI target must still be tested; do not infer it from serialized existence alone.

## Exact Smithbox preparation

[Smithbox's author guide](https://soulsmodding.com/doku.php?id=tutorial:smithbox-map-editor-fundamentals) describes Create tools, target map/type/subtype, Properties editing and Ctrl+D duplication; UI labels can differ from its documented1.0.25 version. Use your existing Smithbox, not a new tool installation.

1. Create/open a **separate disposable Smithbox project** rooted at `TestingAI/build/experiment003/smithbox-project/`, using the same installed game as a read-only source. Do not change the existing TestingAI project or any Steam file. Copy existing project-local MSB into this disposable project's `map/mapstudio/` first if it contains changes you need to preserve. Back up that input copy separately before editing; record the base map hash. These are manual preparation instructions; Codex has not created a new Smithbox project or altered any map.
2. Load `m18_00_00_00`; confirm NPC entity18000257 and its supplied spawn coordinates. Load related maps only as needed to view the floor and collision. Do not move the NPC or change ThinkParam.
3. Use Map Editor **Tools → Create**: target map `m18_00_00_00`, core/target type **Region**, subtype **Other**, then **Create Object**. This is a proposed simple region subtype, not a proven native whitelist. Set **Shape = Point** in Properties. Create a new object rather than editing tutorial/trigger/sound/navmesh regions. If your version cannot expose these fields, stop and record the actual UI rather than substituting another functional region type.
4. Give it a new map-unique region **Name**, e.g. `EXP003_destination`. Set **Position** X=-108.095,Y=3.183,Z=150.961. Point shape has no radius/box extents; no exact shape-dependent arrival test is assumed. Verify the point is on reachable floor near the NPC, not inside geometry or a disconnected navigation surface. Do not change navmesh or collision.
5. Set a fresh nonzero **EntityID**, distinct from NPC18000257 and every existing addressable part/region/event in the map and relevant loaded maps. Use Smithbox property search to check the candidate before and after creating it. No value in this report is certified free. Lua must use this EntityID, not the name or RegionID. Do not add EntityGroupIDs or event flags just to identify this point.
6. Set/check a fresh **RegionID** if editable: the inspected source describes it as presumed map-local unique; ensure it differs from all current regions.9063 is unused in the inspected snapshot only, not a guaranteed current-project reservation. Do not confuse the writer-generated per-type entry ID/index with either field; let Smithbox manage serialization indices.
7. Check **ActivationPartName** is unset/no part restriction for this simple point. Preserve normal map/ceremony visibility; copied restrictive activation/layer settings can make a region unavailable. Source fields support these restrictions; no universal undocumented default is prescribed. If duplicating instead of Create, explicitly clear carried references and check both IDs/name—Ctrl+D is not proof of uniqueness.
8. Save only to the disposable project. Reopen/reload and verify name, type, shape, EntityID, RegionID and XYZ persist. Expected output is `.../smithbox-project/map/mapstudio/m18_00_00_00.msb.dcx`; confirm actual save path and record SHA256. Keep the input/backups. Provide the saved test map plus confirmed IDs for the Lua build; do not copy anything to ModEngine yet.

## Completion, failure and expected behavior

Documented `float GetDist(TARGET target)` measures distance with capsule considerations. `ai:GetDist(POINT_EVENT) <= 0.5` is a proposed arrival observation supported by the030000 logic pattern; it is not exact Euclidean XYZ coincidence. `int goal:GetSubGoalNum()` counts queued subgoals, per [GoalFunc](https://eladidu.github.io/readable-ds-lua/d4/d58/class_goal_func.html); an empty queue alone cannot distinguish arrival, timeout, failure or cancellation. Goal lifetime expiration is not proof of reaching the destination. Source constants are Failed=-1,Continue=0,Success=1, but no result override is implemented now. Point containment has no useful finite arrival volume; a later sphere/box test would be a separate map/logic change.

Expected test: trigger the same soldier's battle activation, then stand to a side so the player is not at the destination. The soldier should walk/guard toward the fixed point, finish near it, and not chase the relocated player or initiate melee. Battle-state/aggro activation still depends on the player; autonomous movement from an idle state is outside this minimal callback test. Repeat from a reset spawn; compare to Experiment002 player-following behavior, then restore Experiment002. Preserve ordinary navigation/collision; this does not prove arbitrary coordinates, dynamic input, rerouting after interrupts, or every obstacle route.

A missing/unloaded/wrong region, wrong map override, ID collision, disconnected navmesh, guard interference, goal timeout, shared/native reactions or loss of battle state can invalidate results. If using GetDist later, separately establish that the region exists; a missing-target distance must not be treated as successful arrival. Guard9910 is retained for isolation even if it affects navigation animation.

## Implementation and deployment boundary

**Experiment003 compiled Lua, repacked archive and deployment manifest do not exist.** Compilation/archive verification was not run; there is no deployable prototype or invented output hash. Research output directory exists; all Experiment001/002 artifacts are preserved. No game/tool/external ModEngine changes, map edits, launch, deployment or Git mutations occurred.

Next prerequisite: confirm the region alternative and obtain the saved disposable test map with unique EntityID/RegionID. Then build only Experiment003 source/binder copies, use existing Lua5.0 compiler, verify original/recovered baseline provenance, compare function isolation against Experiment002, repack via existing interactive Witchy workflow, and independently extract/compare Lua/LUAGNL/IDs/names/flags/binder metadata/header. Verify map differences separately: exactly one new region and unchanged NPC/parts/events/routes/other regions. New region metadata-only inventory does not replace full map comparison.

Future override needs **both** `script/431030_battle.luabnd.dcx` and `map/mapstudio/m18_00_00_00.msb.dcx` in one isolated mod root. Before later authorized deployment, back up both existing override paths plus config/launcher, including recording absence of a prior map file. Verify both staged/deployed hashes from the final manifest. Roll back both files together, restoring previous files or previous absence, preserving displaced copies. Experiment002's helper manages only Lua and its pinned hash; it must not be reused unchanged for this two-file test. Exact runnable deployment commands await verified outputs and authorization; nothing should be deployed at this research boundary.
