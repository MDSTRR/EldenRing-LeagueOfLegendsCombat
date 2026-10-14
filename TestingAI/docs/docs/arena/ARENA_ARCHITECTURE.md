# Proposed arena architecture

2026-10-13. **REASONABLE INFERENCE:** this document is a proposed design, not an implemented configuration. [Evidence and identifiers](PLACIDUSAX_ARENA_FEASIBILITY.md) | [Plan](ARENA_IMPLEMENTATION_PLAN.md) | [Tests](ARENA_TEST_MATRIX.md).

## Separate override set

Use a new disposable project and inactive ModEngine override root dedicated to the arena. Keep Experiments 001–003, their sources, staged maps and archives unchanged. Do not merge this into Agent 1's experiment root.

| Component | Proposed role |
|---|---|
| m13 MSB copy | Preserve terrain/collisions; add one c4311 Enemy, required model reference, destination points and eventually a custom Player start if the existing start is inadequate |
| m13 EMEVD copy | Suppress only audited Placidusax encounter paths; explicit test initialization; later reset/return interaction |
| Accessible hub EMEVD copy | Opt-in entry interaction using an existing inspected interactible; one requested warp per interaction, no unconditional constructor warp |
| `regulation.bin` copy | Add an arena-specific ThinkParam row selecting a unique registered battle goal; initially retain NpcParam `43114006` |
| New arena battle Lua binder | Copy the verified fixed-region technique into a separately registered goal; use arena EntityIDs and retain combat isolation |
| Native map navigation | Preserve existing NVA/HKX assets; no navigation override initially |

**UNVERIFIED — REQUIRES IN-GAME TESTING:** this complete configuration, unique goal registration/binder discovery, hub access, and soldier activation. Exact new goal/archive/row/event/flag IDs are deliberately unassigned. First audit source IDs and registration tables; a free number alone does not prove an engine registration works. A temporary shared-goal override is smaller but affects unrelated soldiers and is not the recommended reusable environment.

## Access comparison

| Route | Evidence / tradeoff | Recommendation |
|---|---|---|
| Native lie-down access | **VERIFIED FROM SOURCE:** event `13002834` uses a cutscene, arrival regions and weather/camera changes | Useful reference baseline; inconvenient repeated access and conflicts with encounter suppression |
| Existing grace warp | **VERIFIED FROM SOURCE:** published Player part `13000981`; grace setup is boss-defeat-gated | Reuse the start part, not forced defeat/unlock flags |
| EMEVD entry warp | **VERIFIED FROM SOURCE:** [WarpPlayer declaration](../api/arena-access.md#warpplayer) | **REASONABLE INFERENCE:** simplest repeatable entry after a hub trigger is inspected and isolated |
| New Player start | **REASONABLE INFERENCE:** copied native Player part with unique EntityID at verified floor coordinates | Later if needed; a generic Other/Point destination region is not automatically a warp-compatible Player start |
| Native hooks/save editing | Outside this assignment | Exclude |

**REASONABLE INFERENCE:** return through a second explicit interaction to an audited existing hub Player part. Do not assume arbitrary coordinates or the m13 cutscene region ID can be supplied as WarpPlayer's initial-area entity. Validate the chosen part type and all six instruction fields. Keep respawn behavior separate from entry warping; do not change respawn/grace state for convenience until death behavior has a dedicated test.

## Minimal layout

**REASONABLE INFERENCE:** choose a connected central patch after read-only navigation inspection. Numeric coordinates below are intentionally not invented. `P`, `N`, `D1`–`D3` are planning labels, not EntityIDs.

| Label | Placement and purpose |
|---|---|
| P | Start with published Player part `13000981`; move to a custom Player part only if floor/streaming tests require it |
| N | One Godrick spearman on the same validated ground component, away from edges and P's walking route |
| D1 | Other/Point region 3–5 metres from N, unobstructed; first movement gate |
| D2 | Further point on the same connected patch, selected after D1 passes |
| D3 | Optional sideways/reverse point; defer until reset and D2 work |
| Arrival volumes | Separate small volume regions around destinations if event-based arrival observations are needed; Point regions have no useful volume for a containment test |

Every new Enemy/Player/region EntityID and EntityGroupID must be unique across relevant loaded maps and event references. Internal MSB region IDs are a different namespace and require their own format/editor validation. Do not copy `18000257`, `67676767` or boss groups into the arena. Reserve event slots, flags and parameter/goal IDs separately after a collision scan. Region names are labels, not engine target IDs.

## NPC references and activation

**VERIFIED FROM SOURCE:** original soldier model/NpcParam/ThinkParam are `c4311`/`43114006`/`43114006` (pinned map enums in feasibility report). **REASONABLE INFERENCE:** retain equipment, character assets, animation and collision behavior; copy the Enemy's fields faithfully, then deliberately change name/entity, transform, collision/draw parent, arena-specific Think row and groups. Ensure m13's model list includes c4311 and its normal assets can load. Do not copy the m18 collision name `h002100` into m13. `h015000` is an inspected-source candidate reference, not yet certified for the new soldier's chosen position.

Use Smithbox to inspect target-local draw/display groups, collision streaming, map layers, backread/activation, patrol references and event ownership. Keep the soldier out of boss groups. Do not guess group bitmasks or parameter defaults. Verify references survive save/readback and the NPC remains loaded while the player observes off-route.

**UNVERIFIED — REQUIRES IN-GAME TESTING:** ordinary battle activation in the empty arena. The current approach callback is battle-driven; placing an Enemy does not guarantee it runs. The first test may use the already established normal activation trigger with the player, then move the player off-route. Do not weaken no-attack isolation or invent an always-active idle callback. Later integrate Agent 1's arrival/idle work separately.

## Encounter isolation and reset

**REASONABLE INFERENCE:** keep original boss/dummy references, explicitly suppress their activity, and omit/guard the seven audited Placidusax event paths and music initialization in the disposable m13 event copy. Preserve non-Placidusax events and floor/streaming logic. No synthetic defeat, kill/reward event, or boss grace unlock. Audit fog/boundaries before altering any asset.

Initial reset: leave through the validated return route and re-enter/reload; compare NPC spawn, destination selection, activation and flag state on each cycle. **UNVERIFIED — REQUIRES IN-GAME TESTING:** reload restoring the intended NPC and AI state. A later reset interaction must explicitly clear only its audited test state and reset goals/NPC position using sourced instructions. Warping or moving an actor alone does not prove old goals, damage, death or event-slot state reset. No reset API implementation is supplied here.
