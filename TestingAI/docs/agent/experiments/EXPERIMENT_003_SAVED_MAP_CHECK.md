# Experiment003 — saved map check

Follow-up: user explicitly waived the runtime prerequisite. [Prepared prototype report](EXPERIMENT_003_PREPARED_PROTOTYPE.md) records completed Lua/map static validation and workspace staging. Runtime remains unverified; no installed deployment or game launch. Earlier stopping-condition discussion below describes the previous request.

2026-10-13. **PASS: current saved-map values and map-local ID collision checks. BLOCKED: requested runtime-compatibility prerequisite remains unestablished.** No prototype built/staged/deployed and no game launched.

## Current verified file

The map changed during this session. A fresh read of `TestingAI/map/mapstudio/m18_00_00_00.msb.dcx` verifies exactly one `EXP003_destination`, Other/Point, RegionID9063, EntityID67676767, position(-108.095,3.183,150.961) within float representation tolerance. File254372 bytes; SHA256 `605B02422EE285ABD699107C7A24C8A49BE65DD759B5166A6E71D01AA66D79FD`. This fresh read remained unchanged throughout inspection.

Checked325 regions,4683 parts,27 events and37464 entity-group slots: no part/event/group collision with67676767; its sole region is the destination.9063 appears once among RegionIDs. Scope is this saved map, not other loaded maps or unsaved Smithbox objects. Evidence: `TestingAI/build/experiment003/research/saved-map-605B0242-verification.json`. No separate project file was found inside the repository; actual verified input is the exact file above, regardless of the project's informal disposable label.

The reviewed ModEngine mod root and MSB file structure establish the intended relative map override location: `map/mapstudio/m18_00_00_00.msb.dcx`; Lua companion path `script/431030_battle.luabnd.dcx`. Installed config was read only and not edited.

[ERAiAPI](https://eladidu.github.io/readable-ds-lua/d1/d81/class_ai_func.html) documents assigning a region to POINT_EVENT, and the public ER Lua examples establish the setter/ApproachTarget call pattern. Available evidence does **not** establish that the current engine resolves this particular Other/Point region67676767 or that it is reachable on this map. No current-build native loader/lookup implementation or runtime test is available; serialization/type/uniqueness is not that proof. Search did not produce subtype-specific validation. This is uncertainty, not evidence of incompatibility.

User explicitly said: “Stop if the map override location or runtime region compatibility cannot be established.” Map location is established, but the runtime gate is not. Stopped before modifying Lua or packaging either override. To proceed as an experiment, the remaining region-lookup/availability assumption must be explicitly permitted for validation in the later user-run offline test, or supported by additional native/runtime evidence. No instruction to run the game is inferred.

## Historical initial read — superseded after map changed

Repository-wide filename search, excluding tool directories, found only `TestingAI/map/mapstudio/m18_00_00_00.msb.dcx` and the existing `TestingAI/project.json` (project name ER-LoL-Test1). No separate Experiment003 Smithbox project/map was found inside this repository. A disposable project outside the repository may contain the requested file; its actual path is needed before treating this copy as authoritative.

The available map was decompressed in memory using existing tools and inspected with the existing source-based bounded region reader, with its output-writing statements removed in memory. File size254371 bytes; SHA256 `E51E4DE664C153ACF97D88ADEDA0CA146240EBF03189350B493ED56878864F10`.325 regions. The file hash remained unchanged during and after inspection.

| Field | Requested | Actual saved value | Result |
|---|---|---|---|
| Name | EXP003_destination | EXP003_destination | Match; one occurrence |
| Type | Other | 0xFFFFFFFF / Other | Match |
| Shape | Point | 0 / Point | Match |
| EntityID | 67676767 | 67676767 | Match; one region occurrence |
| RegionID | 9063 | **-1822257825** | **Mismatch; no region with9063** |
| Position | (-108.095,3.183,150.961) | Same to supplied precision | Match; expected float representation rounding |

Saved activation-part index=-1 and map layer=0xFFFFFFFF. These serialized settings are not proof of runtime availability. Current map hash differs from earlier snapshots because the user's map changed between checks; it was not modified by Codex. Prior negative-ID format validity does not waive the user's new exact9063 requirement.

Known reviewed ModEngine config still enables its default `mod` root. Expected two-file relative structure remains `map/mapstudio/m18_00_00_00.msb.dcx` and `script/431030_battle.luabnd.dcx`. This check does not prove region lookup/current-build behavior or navigation reachability. No new runtime compatibility claim was made.

Experiment002 archive still has approved SHA256 `71D1B924524B4811A3CFFC62B0DA516CAF253687443A7B7D69A03AAB17644A17`; no Experiment001/002 artifact was modified. No Git branch/history changes, original-map edits, installed game/ModEngine changes, compilation/repack or deployment occurred.

Next: provide the full path to the disposable project's saved MSB, or save RegionID9063 to the intended project and identify its output path. Reinspect that exact file, including entity/region ID collisions and map delta, then assess the compatibility gate before building. A guessed alternative map path or silently accepting the negative RegionID would bypass the condition and is not permitted.
