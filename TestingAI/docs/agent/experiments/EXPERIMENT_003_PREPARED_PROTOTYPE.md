# Experiment003 — prepared fixed-region prototype

2026-10-13. **PASS: Lua build, archive checks, saved-map validation and two-file workspace staging. Runtime test pending.** User explicitly waived the previous pre-implementation runtime-compatibility requirement. Other/Point region lookup is an authorized hypothesis to test, not a verified engine behavior.

## Minimal change and expected behavior

Starting from the exact validated Experiment002 source, changed only its main Activate callback's destination setup/request:

```lua
f2_arg2:ClearSubGoal()
f2_arg1:SetEventMoveTarget(67676767)
f2_arg2:AddSubGoal(GOAL_COMMON_ApproachTarget, 10, POINT_EVENT, 0.5, TARGET_SELF, true, 9910)
```

Arguments: setter receives destination region **EntityID67676767**; goal lifetime10, destinationPOINT_EVENT, stop distance0.5, facingTARGET_SELF, walktrue, guard9910. RegionID9063 is map bookkeeping, not the setter argument. No XYZ/Vector3 passed to ApproachTarget. API/source evidence is in the [research report](EXPERIMENT_003_FIXED_DESTINATION_RESEARCH.md).

Pseudo-global setup, observer removal and queue clearing retained. Main Interrupt still returnsfalse without attack/retreat requests, as in the successful Experiment002 test. Initialize/Update/Terminate, registration and all other functions unchanged from Experiment002. Existing attack helpers remain defined but unselected by the main callback. All NPCs using battle431030 can be affected; this is not an entity-filtered script.

After normal battle activation, the soldier should walk/guard toward the fixed point and stop near it, without following the player or initiating the scripted melee attacks. **This does not start movement from an inactive/idle AI:** detection/battle activation still needs the existing game logic. “Autonomous” here means destination-directed movement without further player steering after activation. Native/shared interruption, aggro loss, guard behavior, timeout and repeated activation remain unverified. A10-second goal timeout or an empty queue is not proof of arrival.

## Saved map and provenance

Used exactly `TestingAI/map/mapstudio/m18_00_00_00.msb.dcx`,254372 bytes, SHA256 `605B02422EE285ABD699107C7A24C8A49BE65DD759B5166A6E71D01AA66D79FD`. Verified `EXP003_destination`, Other/Point, RegionID9063, EntityID67676767, position(-108.095,3.183,150.961). Map-local checks covered325 regions/4683 parts/27 events/37464 group slots; no target-ID collision. Input map not edited/repacked by Codex; staged as an exact copy.

Earlier workspace map snapshot hash65183A0F…28CCF7A is recorded but its bytes are no longer present. Backup Git map at commit5043ed2bbf060d531b6d69d838ef93095eb0fb2b has hash2DDB49F2…0DCB56; it is **a separate authenticated comparison baseline**, not relabeled as the missing snapshot. Earlier Experiment001/002 Lua provenance remains unchanged.

Compared all5407 existing named entry spans (including name-occurrence keys), section versions and order against that backup. The current map has exactly one additional entry: EXP003_destination. A strict raw comparison flagged106 existing-entry changes. Source-based classification verified **every** difference:

-98 Other-region generated IDs/indices shift by1 because the new region is inserted at region-list index226.
-5 composite regions' child indices resolve to the same existing named regions.
-2 RetryPoint events' references resolve to the same existing named regions.
-NPC c4311_9007 rotation X differs only as positive zero versus negative zero. Remaining NPC bytes, including param assignments, match.

After checking these exact supported fields, no unexplained existing-entry byte change remains. No broad hash substitution/blanket ignored fields were used. This is a bounded source-based map comparison, not a complete native loader validation. Source layouts: [MSBE regions](https://github.com/soulsmods/SoulsFormatsNEXT/blob/master/SoulsFormats/Formats/MSB/MSBE/PointParam.cs), [RetryPoint](https://github.com/soulsmods/SoulsFormatsNEXT/blob/master/SoulsFormats/Formats/MSB/MSBE/EventParam.cs), and local SoulsFormats MSB/Shape.cs composite reader. Raw failure evidence is retained alongside the classification.

## Actual static results

| Check | Result |
|---|---|
| Existing Lua5.0 compiler | Compiled directly, no corrections/errors; Shift-JIS |
| Compiled payload |46894 bytes; SHA256 `D1760630C35B883A70080E60418A9DFF6326B421A60A90229756844A5D314D3E` |
| Lua header | Matches original22-byte Lua5.0 header |
| Function count |27; only main Activate/index2 differs from Experiment002 |
| Original-game function delta | Only indices2/24, matching prior combat isolation plus new Activate |
| Embedded source/disassembly | Exact source text matches; decoded Activate confirms region67676767/POINT_EVENT/0.5/walktrue/guard9910 |
| Repacked Lua archive |7792 bytes; SHA256 `4CAA4E3ECEB7CE182E6AC057969817764E88AF75C3C1EFF757C0EB4A949F7F45` |
| LUAGNL | Exact original1504-byte payload/hash2A00F443…DD8CC |
| Binder | Exactly IDs1000/1000000; full names/flags/per-entry compression and all nine checked binder fields match original |
| Outer compression |DCX_KRAK, explicit KRAK/level6 header |
| Staged copies | Both match their verified source archive/map hashes |
| Earlier experiments | All100 files under Experiment001/002 hash-checked unchanged |

Packaging used **existing SoulsFormats BND4.Write and existing Oodle6 runtime**, already present in the toolchain, rather than the previously blocked interactive Witchy CLI. First wrote an unchanged-payload control and freshly read it back to confirm original Lua/LUAGNL and binder metadata preservation. Then wrote/read/extracted the modified archive and validated exact payload hashes/metadata. No tools downloaded/installed, third-party repository edited, compiler uncertainty bypassed, or archive success inferred from an exit code alone. Game compatibility still requires runtime testing.

## Exact outputs

All below are under repository root `C:\Users\creep\Desktop\Projects\Elden Ring - LoL\EldenRing-LeagueOfLegendsCombat`:

- `TestingAI/build/experiment003/source/431030_battle.lua` — modified text.
- `TestingAI/build/experiment003/fixed-region/431030_battle-luabnd-dcx/` — compiled Lua plus unchanged LUAGNL/XML.
- `TestingAI/build/experiment003/fixed-region/431030_battle.luabnd.dcx` — rebuilt archive.
- **Staged mod root:** `TestingAI/build/experiment003/deployment/fixed-region/`, containing `script/431030_battle.luabnd.dcx` and `map/mapstudio/m18_00_00_00.msb.dcx`.
- `build-verification.json`, `map-verification.json`, `map-verification-detail.json`, `map-remapping-verification.json`, `prior-experiment-hashes-before.json`, `verification/activation-disassembly.json` — evidence inside Experiment003.
- `build.ps1`, `compare-map.ps1`, `validate-map-remapping.ps1` — preparation/validation scripts. Existing outputs cause refusal rather than overwrite; do not rebuild unnecessarily.

## User-run deployment and rollback

Installed ModEngine is `C:\Users\creep\Documents\ModEngine-2.1.0.0-win64`; reviewed config enables only its default `mod` root. No configuration edit needed. Prepared `TestingAI/build/experiment003/modengine-test.ps1` manages **both** Lua and map, preserves prior files or absence, pins both new hashes and reviewed config/launcher hashes, and refuses changed setup/unexpected current files/open game. Script syntax checked; external write actions intentionally not run by Codex. Do not reuse the Experiment002 Lua-only helper.

Run blocks separately in PowerShell7 with the game closed. No command launches the game.

```powershell
$ErrorActionPreference = 'Stop'
$repo = 'C:\Users\creep\Desktop\Projects\Elden Ring - LoL\EldenRing-LeagueOfLegendsCombat'
$ops = Join-Path $repo 'TestingAI\build\experiment003\modengine-test.ps1'
$backup = Join-Path $repo ('TestingAI\build\experiment003\modengine-backups\test-' + [guid]::NewGuid().ToString('N'))
& $ops -Action Backup -BackupDirectory $backup
$backup
```

Keep that printed backup directory; reuse it for all actions. Backup prints the current two-file baseline hashes/absence. If reopening PowerShell, reset `$repo`/`$ops`, set `$backup` to that exact existing directory, and retain ErrorActionPreference=Stop. Do not make a new backup after deploying B.

Perform baseline A manually offline and record which existing override is active. Prefer the known Experiment002 approach-only behavior if that is already the restored baseline; otherwise label the actual original/compiled-source behavior correctly. Do not mislabel an unrelated current override. Close the game, then:

```powershell
& $ops -Action Deploy -BackupDirectory $backup
& $ops -Action Verify -BackupDirectory $backup
```

Verify requires both exact hashes from the table above at `mod/script/...` and `mod/map/mapstudio/...`. If any action fails, do not launch: inspect the error and run rollback to restore the backed-up pair. Files are copied sequentially, not atomically. Unknown-file hash changes stop the helper for review; no expected hashes should be substituted.

After B, close the game and restore A:

```powershell
& $ops -Action Rollback -BackupDirectory $backup
```

Rollback preserves displaced copies and restores both original files, or moves the test map out if no map override existed before. Config/launcher remain unchanged. Repeat A/B/A using the same backup if needed. A full restart/reset is required between variants; no file deletion/Steam edits.

## Offline runtime test and success criteria

Use the existing supported ModEngine launch setup offline with anti-cheat disabled; do not launch the normal anti-cheat-enabled executable. Record game build, map/entity/ThinkParam, config, both deployed hashes, baseline hashes and footage.

1. Reset the same NPC c4311_9007/entity18000257 in Stranded Graveyard. Confirm spawn(-102.524,2.849,157.056). Keep equipment/conditions fixed; no attacks, staggering or applied effects.
2. For B, enter detection range to activate the battle goal. Position the player **away from the destination**, preferably to the side/opposite direction, within stable aggro range. A player standing at the destination cannot distinguish player-following from region navigation.
3. Expect the soldier to walk/guard approximately8.26 horizontal units toward(-108.095,3.183,150.961) and stop near the point without initiating ordinary melee. Move the player laterally while it travels to see whether the route remains destination-directed. Observe at least30 seconds, noting arrival/idle/timeout/aggro loss separately.
4. Repeat after restart/reset with different player positions. Roll back both overrides and confirm baseline behavior returns. Require reproducible destination-directed B and restored A before claiming success.

A matching deployed hash, compilation, no crash, idle NPC or elapsed lifetime is not success. An unresolved region, navmesh disconnect, floor-height issue, guard obstruction or shared/native reaction can fail the hypothesis. Stop on crash, attacking, player-following or movement to the wrong place; preserve logs/video and restore the pair. No update/result flags, fabricated arrival API, input system or custom pathfinder added.

Codex stopped with the pair staged only inside the workspace. Original map and all earlier artifacts retained; installed game/ModEngine files and Git branches/history untouched. No game launched/deployment performed. Next action belongs to the user's offline test.
