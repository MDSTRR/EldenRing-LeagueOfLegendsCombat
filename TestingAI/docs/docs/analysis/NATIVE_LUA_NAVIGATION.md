# Native-to-Lua NPC navigation: consolidated findings

2026-10-13. Documentation-only consolidation of two Open Enemy Control investigations. [API index](../api/INDEX.md) | [Native runtime access](../api/native-runtime.md) | [Event/AI communication](../api/event-ai-communication.md)

## Recommendation and evidence boundary

**ADAPT SELECTIVELY.** Use Open Enemy Control as a reference for obtaining NPC pointers, without possession. The strongest command-delivery candidate is native event-flag publication consumed by battle Lua to select a real region destination. That architecture is a **REASONABLE INFERENCE** from separately **VERIFIED FROM SOURCE** mechanisms; it has not been implemented or demonstrated for our NPC.

**Arbitrary world-coordinate destinations remain UNVERIFIED.** Switching regions can prove dynamic commands, but cannot establish unrestricted right-click XYZ navigation. Current-build compatibility, runtime region lookup, movement interruption/replacement and obstacle routing remain independent gates.

Classification used throughout the linked API pages:

- **VERIFIED FROM SOURCE:** a named implementation, declaration or call site exists at the cited revision; not a running-game result.
- **REASONABLE INFERENCE:** a proposed architecture or interpretation whose prerequisites are stated.
- **UNVERIFIED:** a missing function address/layout/ABI, integration, or runtime behavior.

The existing project's user-reported Experiment 002 success and recorded static map checks keep their existing verification categories. Neither is reclassified as source proof of a working dynamic bridge.

## Original reports and source provenance

The full reports remain outside the main repository in the sibling `Research Open Enemy Control/er_enemy_control` checkout:

- [Research index](<../../../../../Research Open Enemy Control/er_enemy_control/index.md>).
- [Open Enemy Control source analysis](<../../../../../Research Open Enemy Control/er_enemy_control/analysis.md>): full F1 path, offsets, player effects, lifetime/input limitations and reuse subset.
- [Original project-route comparison](<../../../../../Research Open Enemy Control/er_enemy_control/routes-analysis.md>): initial Lua/native/direct-control alternatives.
- [Native-to-AI bridge analysis](<../../../../../Research Open Enemy Control/er_enemy_control/native-ai-bridge-analysis.md>): native flag calls, Lua readers, event routes and unresolved endpoints.
- [Bridge evidence ledger](<../../../../../Research Open Enemy Control/er_enemy_control/native-ai-bridge-evidence.md>): source anchors, 529-script search and external evidence/555-file hash manifest.

These relative links require that sibling checkout; they are not portable standalone repository artifacts. The reusable API pages retain the key remote source URLs and full revision hashes so their conclusions can still be traced independently.

| Source | Pinned revision | What it establishes |
|---|---|---|
| [Open Enemy Control](https://github.com/AlpinDale/er_enemy_control/tree/8056f10c0864e3e10d6c20cc85827676fac36ab4) | `8056f10c0864e3e10d6c20cc85827676fac36ab4` | Native target lookup and possession implementation |
| [Elden Ring Debug Tool](https://github.com/Nordgaren/Elden-Ring-Debug-Tool/tree/014048f44a10eb3a925714f5da65ee92c1450b25) | `014048f44a10eb3a925714f5da65ee92c1450b25` | Tool flag-write consumer and pinned Erd-Tools dependency |
| [Erd-Tools](https://github.com/Nordgaren/Erd-Tools/tree/a2757f930afa3109dc4816d3f04e7cd11b91fea1) | `a2757f930afa3109dc4816d3f04e7cd11b91fea1` | Native flag manager/function resolution and call stub |
| [PropertyHook](https://github.com/Nordgaren/PropertyHook/tree/ca3c4413ed70786570e82b02851715c5d4adb651) | `ca3c4413ed70786570e82b02851715c5d4adb651` | Remote-thread call execution, not AI-thread scheduling |
| [EldenRingAI](https://github.com/zoloypzuo/EldenRingAI/tree/3b3efb00219026dfba4663b9eb1a1afd94c0a68e) | `3b3efb00219026dfba4663b9eb1a1afd94c0a68e` | Battle Lua readers, event-region setter and movement call sites |
| [Soulstruct vanilla](https://github.com/Grimrukh/soulstruct-vanilla/tree/e6de1b79370755152f4f89c4a106a2d67c9ae674) | `e6de1b79370755152f4f89c4a106a2d67c9ae674` | Published ER event command/point/replan sequences |
| [FromSoftware-rs](https://github.com/vswarte/eldenring-rs/tree/6933967b176332a37e9ce6773f8dcd74b9feaf42) | `6933967b176332a37e9ce6773f8dcd74b9feaf42` | Direct runtime event-flag memory implementation |
| [readable-ds-lua docs](https://github.com/ElaDiDu/readable-ds-lua/tree/4c78203276c9dd5dbaf8b6d769a30d807cd41233/docs) | gh-pages `4c78203276c9dd5dbaf8b6d769a30d807cd41233` | Lua-facing declarations/reference semantics, not native bindings |
| [libER](https://github.com/Dasaav-dsv/libER/tree/d8ae5c92719adca4344d8d902b63286b807f562b) | `d8ae5c92719adca4344d8d902b63286b807f562b` | General engine access reference; reviewed tree did not supply an AI destination setter |

[ER EMEDF](https://soulsmods.github.io/emedf/er-emedf.html) was retrieved 2026-10-13 without a pinned repository revision. Installed game-build support was not validated in either investigation. Decompiled examples have unspecified build/provenance; absence findings are limited to the inspected source scope.

## Component findings

| Capability | Finding | Classification and reference |
|---|---|---|
| NPC access | `get_current_target` calls a scanned engine getter; no entity-ID lookup in Open Enemy Control | VERIFIED FROM SOURCE; [runtime reference](../api/native-runtime.md#npc-selection) |
| Possession | Existing target linked into player-control structures; flags/team/HP/player-position changes | VERIFIED FROM SOURCE for writes; engine AI arbitration UNVERIFIED; [possession limits](../api/native-runtime.md#possession-implementation-and-limits) |
| Native state publication | Erd-Tools invokes an engine event-flag setter; FromSoftware-rs writes flag memory independently | VERIFIED FROM SOURCE; [flag writing](../api/event-ai-communication.md#native-event-flag-writing) |
| Battle Lua state reception | `IsEventFlag` and `GetEventRequest` occur in ER battle/logic scripts | VERIFIED FROM SOURCE; [reader](../api/event-ai-communication.md#iseventflag), [requests](../api/event-ai-communication.md#geteventrequest-and-interupt_eventrequest) |
| Region destination | `SetEventMoveTarget(region EntityID)` selects `POINT_EVENT`; ApproachTarget forwards to MoveToSomewhere | VERIFIED FROM SOURCE for call chain; [existing setter](../api/ai-functions.md#seteventmovetarget) and [point reference](../api/ai-targets.md#point-targets) |
| Event destination/replan | `SetEventPoint`, `RequestCharacterAICommand` and `RequestCharacterAIReplan` exist as event instructions and script calls | VERIFIED FROM SOURCE; [event API](../api/event-ai-communication.md#seteventpoint); native addresses/ABI UNVERIFIED |
| Combined dynamic command | Native change becomes a Lua order, changes target, replaces active motion and reaches destination | REASONABLE INFERENCE as architecture; UNVERIFIED end to end |

## Potential communication architectures

Ranking is a **REASONABLE INFERENCE**, not an approved change to the architecture or permission to implement.

| Rank | Architecture | Source-supported ingredients | Missing evidence and failure risk |
|---|---|---|---|
| 1 | Native flag → Lua selector → region goal | Flag writer, `IsEventFlag`, `SetEventMoveTarget`, `POINT_EVENT` approach | Valid reserved flag/group; current-build visibility; active callback/queue replacement; AI/nav success |
| 2 | Native flag → EMEVD event point/request/replan → AI | Event-script command/point/replan sequence; `GetEventRequest` | Custom event protocol; soldier request handling; interruption/order semantics; storage aliasing |
| 3 | Native mailbox → new battle-Lua binding or mapped numeric state | Lua numeric storage declarations/examples | Correct battle VM/object, binding registration or state layout, thread/lifetime handling; no external writer established |
| 4 | Native setter or movable runtime destination object | Region/relative-point concepts, not a verified native endpoint | Function address/ABI or runtime object mapping, cache invalidation and path replacement; arbitrary XYZ unresolved |

The first bridge can publish global state without possessing or even acquiring an NPC pointer; the Lua consumer must enforce which NPC owns the order. Pointer acquisition remains useful for diagnostics and future identity-aware native work, but is not proof of a writable AI module.

Separate destination selection from order freshness. A later protocol should distinguish a new order for the same destination, ownership, acknowledgement and cancellation. A native mailbox or bit-encoded XYZ payload would solve transport only; it would still require a verified navigation endpoint. No protocol or payload is implemented here.

## Arbitrary world-coordinate destination gap

**UNVERIFIED:** a DLL-callable absolute XYZ navigation setter, safe live-region transform update, or mapped NPC AI destination-vector field. Existing target IDs and Lua number slots do not establish any of these.

- `SetEventMoveTarget` accepts a region identifier; `SetEventPoint` accepts a relative entity identifier and reaction distance. Neither declaration carries X/Y/Z.
- Serialized map-region positions do not establish live object positions, runtime lookup, cache invalidation or automatic replanning after memory changes.
- `SetAIFixedMoveTargetSpecifyAngle` supports a documented target-relative endpoint. Absolute coordinate frames, vertical handling and conversion to a stable destination remain unverified.
- `MoveFollowPathSpecifyPos` has documented coordinate slots, but the pinned 529-script scan found only its goal definition, not an invocation. Fresh-path generation and world-coordinate semantics remain unresolved; see the [existing goal reference](../api/ai-goals.md#goal_common_movefollowpathspecifypos).
- `GetNumber`/`SetNumber` are Lua state storage, not a mapped native writer or a destination setter. `CSLuaEventMan` types do not establish access to the battle AI VM.
- Open Enemy Control's transform writes move the original player alongside the NPC; copying them would not supply autonomous NPC navigation.

A later static investigation should locate actual binding/handler implementations and destination storage before proposing native calls or region writes. No executable disassembly, signatures or offsets are invented in this consolidation.

## Current project gate

Latest, 2026-10-13: the user reports Experiment003 fixed-region navigation verified in-game. It reaches the point, then wanders without attacking and returns. [Experiment003B](../../agent/experiments/EXPERIMENT_003B_ARRIVAL_WAIT.md) is separately prepared to test arrival/waiting and the parent completion policy. Source/mocks/static packaging checks passed; 003B gameplay and future command reception remain pending. This update supersedes the historical fixed-region runtime-pending status in the following preparation records, without proving a native bridge or arbitrary coordinates.

The [saved-map check](../../agent/experiments/EXPERIMENT_003_SAVED_MAP_CHECK.md) records a statically validated `EXP003_destination`, Other/Point, EntityID `67676767`, RegionID `9063`, at `(-108.095,3.183,150.961)`. These identifiers have different roles: Lua region selection uses EntityID, not RegionID. This page cites Agent 1's report; it does not independently reread or alter the map.

During consolidation, newer Agent 1 documentation appeared: the [prepared prototype report](../../agent/experiments/EXPERIMENT_003_PREPARED_PROTOTYPE.md) records that the user authorized carrying region compatibility as an experiment hypothesis, and that Lua/archive/map checks and two-file workspace staging passed. This supersedes the saved-map report's earlier pre-build stop status. The prototype's gameplay test remains pending; current-build region lookup/navigation is not thereby verified. This consolidation preserves that newer authorization record and does not independently implement, stage, deploy or test anything. Fixed-region movement, dynamic replacement, obstacle routing and arbitrary coordinates remain separate unverified outcomes. Experiment 002's user-reported approach success establishes only its tested enemy-target behavior.

## Recommended experiment sequence and criteria

These are future proposed experiments, not implementation instructions being executed. Agent 1 owns the existing experiment artifacts; coordination is through links and documentation. Stage 1 has a prepared prototype under the authorization recorded above, with gameplay results pending. Later native/dynamic stages remain proposals; the earlier waiver is not evidence of their runtime success or authorization to launch the game in this task.

| Stage | Purpose and observations | Success | Failure / stop condition |
|---|---|---|---|
| 1. Fixed-region foundation | Validate the saved point's runtime resolution and engine movement, while player stands elsewhere | Correct region target; observable non-teleport movement and arrival; obstacle detour and stable stop | Missing region, incompatible build, movement toward player, wrong endpoint, no detour, timeout/stuck behavior |
| 2. Access without possession, if needed | Observe selected NPC identity and Lua execution using lookup only | Correct entity identity and ongoing AI callback/marker; safe reacquisition | Ambiguous/wrong target, invalid pointer, disrupted AI or unsupported signature; pointer alone cannot pass |
| 3. State-channel proof | Publish/read back one valid reserved flag; observe the same value in active soldier Lua before changing movement | Native publication and Lua reception both recorded; existing AI stays active | Flag group absent, collision, wrong state/consumer, unread/late callback or unsafe engine call |
| 4. Discrete destination replacement | Two validated regions; issue B while en route to A; then reverse and repeat an endpoint with a fresh order | Order consumed, old movement replaced, reroute/arrival at B through engine AI; repeatable without teleportation | Target value changes but active path does not; stale/mixed orders, AI stops, player following, no valid arrival |
| 5. Lifetime and cancellation | Evaluate map unloading/reloading, idle/arrival, cancellation, command ownership and flag reset | Fresh acquisition/state policy and reproducible safe cancellation/resume | Stale-pointer access, lost orders, cross-NPC consumption or unintended retained state |
| 6. Coordinate endpoint proof | After identifying a concrete bridge, change two predetermined XYZ destinations mid-motion with an obstacle | Recorded coordinate frame/endpoint, newly generated route and correct replacement/arrival | Teleportation, target-relative ambiguity, wrong floor/height, copied coordinates without navigation or no obstacle route |
| 7. Keyboard then mouse | Connect input and world hit testing to the proven command path | One accepted input yields one current destination order; replacement stays responsive | Invalid hit/world frame, duplicate/lost orders or regression in earlier gates |

Stage 2 is optional for the direct flag route, which does not require a native NPC pointer. Use it before identity-sensitive native access rather than making it an artificial prerequisite for global flag publication.

Distinguish native publication, Lua consumption, target resolution, goal replacement and navigation in recorded observations. Queue exhaustion alone is not arrival proof; it may be timeout, cancellation or failure. A successful A/B-region test proves dynamic discrete destinations, not arbitrary world coordinates. No test has been run or milestone accepted by this consolidation.
