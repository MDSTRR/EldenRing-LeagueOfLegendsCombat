# Placidusax testing arena: feasibility

Research completed 2026-10-13. **Conditional feasibility; arena navigation remains INCONCLUSIVE.** This is research and planning only. No map, Lua, event, parameter, build, deployment, installation, or save file was changed; no game was launched.

Read next: [architecture](ARENA_ARCHITECTURE.md), [implementation plan](ARENA_IMPLEMENTATION_PLAN.md), [test matrix](ARENA_TEST_MATRIX.md).

## Evidence and limits

- **VERIFIED FROM SOURCE** means directly present in the cited source, not verified against this installation or in-game.
- **REASONABLE INFERENCE** means a proposed design derived from that evidence.
- **UNVERIFIED — REQUIRES IN-GAME TESTING** means runtime behavior has not been established here. Some prerequisites also require local data inspection before implementation.

The assignment reports Experiments 002 and 003 as successfully tested in-game, with unwanted movement after arrival. This is user-reported project evidence; it does not establish navigation in Farum Azula. Agent 1 owns the arrival investigation. Historical pending-runtime notes in existing reports are not rewritten by this research.

Published vanilla source was read over HTTPS, without downloading tools or game assets. The pinned dump's game version is unspecified. No `m13_00_00_00` MSB, EMEVD, or navigation data was found in the targeted workspace inventory. Consequently, current-build correspondence, region shapes/coordinates, and complete event/asset references still need a read-only local audit.

## Source ledger

| Key | Primary source and scope |
|---|---|
| E | [Farum Azula event dump](https://github.com/Grimrukh/soulstruct-vanilla/blob/e6de1b79370755152f4f89c4a106a2d67c9ae674/eldenring/events/m13_00_00_00.evs.py), pinned commit `e6de1b79370755152f4f89c4a106a2d67c9ae674`; Constructor and events named below |
| M | [Farum Azula enums generated from map data](https://github.com/Grimrukh/soulstruct-vanilla/blob/e6de1b79370755152f4f89c4a106a2d67c9ae674/eldenring/enums/m13_00_00_00_enums.py), same commit |
| S | [Stranded Graveyard enums](https://github.com/Grimrukh/soulstruct-vanilla/blob/e6de1b79370755152f4f89c4a106a2d67c9ae674/eldenring/enums/m18_00_00_00_enums.py), same commit |
| P | [gracenotes' generated player-part inventory](https://gist.github.com/gracenotes/75ca6b323dd951d7ec8746cf59be369a), `m13_00_00_00` section; unpinned, game version unspecified |
| W | [DarkScript3 ER EMEDF](https://soulsmods.github.io/emedf/er-emedf.html#WarpPlayer), retrieved 2026-10-13; exact instruction declarations |
| N | [Smithbox HavokNavmeshBank](https://github.com/vawser/Smithbox/blob/cbd477a8fd6d436b3e011c8548e1de8fd8876918/src/Smithbox.Program/Editors/Map%20Editor/Data/HavokNavmeshBank.cs) and [NVA format](https://github.com/vawser/Smithbox/blob/cbd477a8fd6d436b3e011c8548e1de8fd8876918/src/Andre/SoulsFormats/SoulsFormats/Formats/NVA.cs), pinned tool commit `cbd477a8fd6d436b3e011c8548e1de8fd8876918` |
| T | [Smithbox author's map fundamentals](https://soulsmodding.com/doku.php?id=tutorial:smithbox-map-editor-fundamentals) and [official releases](https://github.com/vawser/Smithbox/releases), read 2026-10-13; available editor support does not identify the installed tool version |
| B | [Boss Arena author's changelog](https://www.nexusmods.com/eldenring/mods/5645?tab=logs), reports spawning/respawning inside Placidusax's arena; precedent for access, not proof of a boss-free soldier arena |

## Identifiers

Identifier rows below are **VERIFIED FROM SOURCE**, with the installation correspondence limitation above. The two override-path rows are **REASONABLE INFERENCE** from the map ID and established file conventions; their current-build binaries were not available locally.

| Object / namespace | Identifier | Evidence |
|---|---|---|
| Map | `m13_00_00_00`, Crumbling Farum Azula | E, M, P |
| MapStudio override | `map/mapstudio/m13_00_00_00.msb.dcx` | Standard project MSB override convention applied to source map ID; local file absent |
| Map event override | `event/m13_00_00_00.emevd.dcx` | E file/map identity; local binary absent |
| Shared event dependency | `common_func.emevd`; E also links `common_macro.emevd` | E header and common function calls; do not blanket replace these shared files |
| Boss Enemy part / model | `c4520_9000` / `c4520` | M |
| Boss EntityID | `13000830` | M |
| Boss NpcParam / ThinkParam | `45200072` / `45200000` | M comments |
| Boss EntityGroupIDs | `13005830`, `13005122` | M |
| Boss collision reference | `h015000` | M; arena floor extent and suitability still uninspected |
| Boss target dummy | `13000840`, `c1000_9021`, group `13005830`, collision `h015000` | M; E assigns it as the boss's event target |
| Lie-down interaction asset | `13001505`, `AEG099_090_9006` | M, E event `13002834` |
| Boss grace asset / grace flag | `13001951`, `AEG099_060_9001` / `13000001` | M, E Constructor `CommonFunc_9005810` gated by `13000830` |
| Battle trigger region | `13002831` | E `13002835`; shape/position unknown |
| Cutscene arrival regions | host `13002834`, other player `13002836` | E `13002834`; do not confuse region IDs with event/flag IDs bearing the same number |
| Arrival cutscene | `13000010` | E `13002834` |
| Existing Player part | `c0000_9003`, EntityID `13000981`, XYZ `(12.21,1009.6,330.07)` | P labels this the Placidusax warp player part |
| Other nearby Player part | `c0000_9004`, EntityID `13003111`, XYZ `(10.04,1010.01,347.54)` | P; exact role is not established by E's region-based cutscene |

**VERIFIED FROM SOURCE:** the same map contains Maliketh and Godskin Duo event logic and player parts. It is not a standalone Placidusax map. P also places ordinary Farum Azula spawns at very different heights. **REASONABLE INFERENCE:** the high arena layer needs its own collision/streaming audit; copying another part's draw settings blindly is unsafe. Published rounded coordinates are inspection landmarks, not certified new spawn or navigation coordinates.

## Encounter dependency trace

The following is **VERIFIED FROM SOURCE** in E. These event IDs describe the published dump, not certified patches for the current build.

| Event | Responsibility and relevant references |
|---|---|
| `13002830` | Death handling; banner and weather reset; writes `13000830`, `9115`, and own-world flags `61115`, `71301` |
| `13002834` | Lie-down interaction/action button `9740`; animation, invader handling, cutscene arrival, weather and camera setup |
| `13002835` | Boss initialization, battle trigger, AI enable, health bar name `904520000`, battle-start notification and group authority/buffs; defeated branch disables/kills group `13005830` and writes `71301` |
| `13002840` | Boss special effect `5029` changes weather and writes phase flag `13002832` |
| `13002841` | Boss special effect `5025` drives camera changes (`4525`, `4521`, `4520`) |
| `13002849` | Initializes helper `13002846` and common music helper `9005822` with BGM conversion row `452000`, flags `13000830`, `13002835`, `13002836`, `13002832` |
| `13002846` | Phantom music-state flag helper called by `13002849` |

**REASONABLE INFERENCE:** the smallest controlled encounter suppression is to retain map geometry and original references, prevent the listed encounter paths from running in an arena-only event copy, and explicitly keep the boss/dummy inactive. Do not kill the boss to simulate removal. Audit every reference to its character, groups, assets and flags first, including common reward consumers. Removing one Enemy part does not address these paths. Never reuse `13005830` or `13005122` for the test soldier.

**VERIFIED FROM SOURCE:** the death path has multiple persistent side effects; its flag is not a clean test-mode switch. **REASONABLE INFERENCE:** forcing defeat or allowing a hidden boss to die can alter rewards, grace availability and progression. Preserve both previously defeated and undefeated save states; use a disposable backed-up offline test save in a future authorized test.

**UNVERIFIED — REQUIRES IN-GAME TESTING:** no-health-bar/no-music/no-cutscene behavior after suppression; appropriate neutral weather/camera; map streaming and death/return behavior. No Placidusax-specific fog-wall asset was identified in the inspected blocks. This does not prove none exists: inspect MSB assets, boundaries, damage/kill regions and every common initializer before choosing what to suppress. Preserve physical floor/edge collision rather than removing boundaries wholesale.

## Access, NPC and navigation verdict

**VERIFIED FROM SOURCE:** ER has an EMEVD player-warp instruction and a published arena Player part; see [access API](../api/arena-access.md). **REASONABLE INFERENCE:** reuse the existing Player part initially, with an explicit entry interaction in a separately copied accessible hub event file. Avoid unconditional startup warps (load loops), defeating the boss to unlock its grace, save editors and native hooks. Source B supports this access direction, not this project's exact implementation.

**VERIFIED FROM SOURCE:** S identifies `18000257` as `c4311_9007`, model `c4311`, NpcParam `43114006`, ThinkParam `43114006`, collision `h002100`. The project associates battle goal `431030` with it. **REASONABLE INFERENCE:** import a duplicate Enemy/model reference into the arena with a new audited EntityID and arena collision/draw references. To avoid affecting other soldiers, use an arena-specific Think row and battle goal/archive, preserving the NpcParam initially. Their IDs must be chosen after collision/registration checks; none is reserved here.

**VERIFIED FROM SOURCE:** the prepared Experiment 003 source targets EntityID `67676767` in `m18_00_00_00`. **REASONABLE INFERENCE:** its movement technique can be reused, but its compiled archive cannot be reused unchanged for new arena region IDs without deliberately recreating that target. Prefer a distinct arena target and source copy; do not share the existing test region ID or globally override every user of goal `431030`. Stable activation and post-arrival behavior remain Agent 1 integration dependencies.

**VERIFIED FROM SOURCE:** N reads ER navigation instances through NVA/NVA_ER and Havok containers from a binder with extension `nvmhktbnd`. Smithbox releases document ER collision/navmesh HKX inspection. **UNVERIFIED — REQUIRES IN-GAME TESTING:** usable connected humanoid navigation coverage at the arena's elevated floor, soldier clearance, endpoint projection and `GOAL_COMMON_ApproachTarget` movement there. Neither Placidusax's own movement nor a flat rendered floor establishes these.

Read-only next audit: obtain authenticated copies of the current-build m13 MSB/events, its NVA and referenced navigation binder/HKX assets; enumerate actual file paths rather than guessing them. In an existing compatible Smithbox, inspect collision `h015000`, relevant NVA transforms, navigation triangles/connectivity at arena height, and planned spawn/destinations. Check load/draw groups and cutting regions. Record screenshots/data hashes/tool version; a missing viewport overlay is not proof of missing navigation. No navmesh generation or tool installation is proposed in this phase.

## Decision

**REASONABLE INFERENCE:** technically plausible as a reusable arena, but not yet implementation-ready. First establish safe empty-arena entry/return, then test one ordinary soldier moving 3–5 metres to one fixed region with the player off-route. Add two more points only after that gate passes. If navigation is missing or event isolation becomes broad, retain the already tested Stranded Graveyard `m18_00_00_00` location as the simpler fallback; this reuses known soldier/floor behavior without importing a special boss arena. Avoid turning this research into a navmesh rebuilding project.
