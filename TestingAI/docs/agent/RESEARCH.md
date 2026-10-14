# Elden Ring AI movement goals — research only

Latest Experiment001: compiled archive payload/metadata and27-function executable comparison passed. Debug/source metadata differs; runtime compatibility untested. Separate inactive compiled override prepared. See [current experiment report](experiments/EXPERIMENT_001_LUA_ROUNDTRIP.md). Historical pending-repack statements below are superseded.

Experiment001 continuation: user interactive baseline repack succeeded; decoded payloads/metadata independently match. Untouched source compiled with existing Lua50Compiler; header and all27 functions' instructions/constants/executable shape match. Compiled-source archive and in-game loading still pending. See [round-trip report](experiments/EXPERIMENT_001_LUA_ROUNDTRIP.md). Earlier failed attempts/research-only statements are historical. No movement behavior verified.

Current analysis: [Handoff004 findings](../docs/analysis/GODRICK_SOLDIER_AI.md). Earlier download/missing-resource statements below preserve historical evidence and are superseded where noted at the end.

Researched: 2026-10-13. No game files available; game downloading. No gameplay changes or in-game tests performed. No movement architecture selected.

## Evidence and sources

- **S1 — [Souls Modding Wiki: Elden Ring AI Goals & Params](https://soulsmodding.com/doku.php?id=er-refmat:ai-goals-and-params).** Elden Ring-specific community reference, page last modified 2025-02-25. Supplies positional parameter labels, including unresolved/unused slots. No game build identified.
- **S2 — [ElaDiDu ERAiAPI: Goals.hpp](https://eladidu.github.io/readable-ds-lua/dd/dac/_goals_8hpp.html).** Author-maintained reverse-engineering documentation explicitly for Elden Ring ([introduction](https://eladidu.github.io/readable-ds-lua/)). Supplies types/defaults and movement semantics. No tested game build identified. These C++-style declarations describe goals; they are not new callable Lua APIs.
- **S3 — [ERAiAPI: AiFunc](https://eladidu.github.io/readable-ds-lua/d1/d81/class_ai_func.html).** Documents target setup and pathing operations for Elden Ring.
- **S4 — [ERAiAPI: TARGET constants](https://eladidu.github.io/readable-ds-lua/d4/d1b/_ai_constants_8hpp.html).** Lists the shared target enumeration; enumeration membership alone does not establish that every goal accepts every value meaningfully.
- **S5 — [Lua AI Common Function Repository](https://www.soulsmodding.com/doku.php?id=common-refmat:lua_ai_common_function_repository).** Author's example repository explicitly says it was made for DS1. Useful supporting example, not Elden Ring verification.
- **S6 — [Grimrukh/SoulsAI: non_battle_act.lua](https://github.com/Grimrukh/SoulsAI/blob/master/ai_scripts/aiCommon/non_battle_act.lua).** Older Souls source example using a movement point. Not proof of current Elden Ring behavior.

Credibility: these are community reverse-engineering references/source examples, not official FromSoftware specifications. “Documented” below means supported by these sources; “verified in-game” requires local reproduction, which has not happened. No independent exact-goal Elden Ring call-site example was located in the inspected public examples. The inspected EldenRingCommonAiFuncs `010000_logic.lua` and `common_func_plan.lua` did not supply an example of either exact goal. This is a limited search result, not proof that no examples exist.

## 1. GOAL_COMMON_MoveToSomewhere

### Exact documented positional parameters

S1 uses zero-based goal parameters, after the goal ID and lifetime supplied by the surrounding goal-add operation. Lifetime is not param0. The following preserves S1's labels and aligns S2's alternative names, types and displayed defaults:

| Index | S1 exact label | S2 name; type; displayed default |
|---|---|---|
| 0 | moveTarget | moveTarget; TARGET; TARGET_ENE_0 |
| 1 | orientationFromTarget | directionFromTarget; AI_DIR_TYPE; AI_DIR_TYPE_CENTER |
| 2 | stopDistance | stopDist; float; 0 |
| 3 | turnTarget | turnTarget; TARGET; TARGET_ENE_0 |
| 4 | walk | walk; bool; false |
| 5 | directionalDistance | directionalDistance; float; 0 |
| 6 | NONE_MISTAKE | unused_7; float; none shown |
| 7 | xzDistanceOnly | xzDistanceOnly; bool; false |
| 8 | ROUTEMOVE_UNKBOOL7 | useDefaultArgs; bool; false |
| 9 | isCloseProximityMode | closeProximityMode; bool; false |

S2 describes target-centered spherical-sector pathing through `AiFunc::FollowPath`. It identifies the stopping radius, facing target, walk/run choice, horizontal-only distance option, and the option to force center direction/zero directional distance. Several details remain undescribed; its directional-width note includes a question mark. Displayed defaults are documentation, not locally verified omitted-Lua-argument behavior. S1's slot 8 uncertainty is more conservative than S2's interpretation; retain both. [S1](https://soulsmodding.com/doku.php?id=er-refmat:ai-goals-and-params), [S2](https://eladidu.github.io/readable-ds-lua/dd/dac/_goals_8hpp.html)

### Known target types and examples

- `TARGET_ENE_0`: documented default and demonstrated movement target in S5. Its example passes goal ID, a 20-second lifetime, enemy target, center direction, 1.5 stopping distance, self facing target, false walk flag, and zero directional distance. This is a DS1 example, not a tested ER invocation. S5 describes true as walking and false as dashing.
- `TARGET_SELF`: demonstrated facing target in that example; do not confuse facing with destination.
- `POINT_MOVE_POINT`: demonstrated movement target in S6's `NonBattleAct_Activate`; it uses the current movement point and self facing.
- Elden Ring's shared TARGET enum includes enemy/self, ally (`TARGET_FRI_0`), player (`TARGET_LOCALPLAYER`, `TARGET_HOSTPLAYER`), `POINT_INITIAL`, `POINT_EVENT`, `POINT_MOVE_POINT`, and `POINT_AI_FIXED_POS`. These are documented enum members, not an exhaustive goal-specific compatibility list. [S4](https://eladidu.github.io/readable-ds-lua/d4/d1b/_ai_constants_8hpp.html)
- S3 documents `SetEventMoveTarget(unsigned int regionId)` assigning `POINT_EVENT` to a region, and `SetAIFixedMoveTarget(TARGET targetOrigin, AI_DIR_TYPE directionFromTarget, float lineLength)` assigning `POINT_AI_FIXED_POS` from a target-relative line endpoint. These establish point setup mechanisms, not proof that this soldier/goal combination works. `TARGET_EVENT` and `POINT_EVENT` are separate constants (20 versus 102); they must not be interchanged. [S3](https://eladidu.github.io/readable-ds-lua/d1/d81/class_ai_func.html), [S4](https://eladidu.github.io/readable-ds-lua/d4/d1b/_ai_constants_8hpp.html)

**Destination assessment:** Strong documented candidate for navigation to a destination represented by an AI target/point. It has no direct x/y/z parameter slots. Using a fixed region via POINT_EVENT is a supported research inference combining the goal signature with documented point setup; successful soldier navigation still needs testing.

**Unverified:** obstacle detours in the chosen area, reachable-point constraints, failure/timeout behavior, normal AI interruptions, parameter omission semantics, command replacement, runtime point changes, and Soldier of Godrick compatibility. Do not infer arbitrary coordinate input or guaranteed reachability.

### Minimal proposed experiment A — recommended first

After installation and a new instruction authorizing implementation:

1. Identify the actual Soldier of Godrick map instance, AI configuration/scripts, and installed game version. Inspect a local ER call site/default handling before choosing omitted or unresolved slots; do not guess IDs or defaults.
2. Select one fixed map region on nearby open, reachable ground, away from the player and outside the soldier's initial stopping radius. Verify its entity ID and position. Use a reversible mod override offline, preserving original files.
3. In one isolated AI action, assign that region to POINT_EVENT using the documented setup and request MoveToSomewhere with center direction, zero directional offset, an explicit small stopping tolerance, and walking. Use locally confirmed values for every required slot and a finite lifetime. Keep the player stationary elsewhere so pursuit cannot explain the movement.
4. Compare an unchanged baseline with the test. Record the call's complete arguments, changed file, source instance/IDs, start and destination, footage, and timeout/arrival outcome. Repeat the same start once.

**Pass:** observable locomotion toward the fixed region and arrival within the chosen tolerance on repeated runs, without teleportation. **Fail/inconclusive:** no movement, wrong destination, interruption, or timeout; investigate setup/execution before rejecting the API. This experiment establishes basic destination movement only; obstacle avoidance and replacement require later tests.

## 2. GOAL_COMMON_MoveFollowPathSpecifyPos

### Exact documented positional parameters

Same indexing convention. Preserve the disagreement rather than filling S1's NONE slots with invented meanings:

| Index | S1 exact label | S2 name; type; displayed default |
|---|---|---|
| 0 | moveTargetAlmostUnused | moveTarget; TARGET; TARGET_ENE_0 |
| 1 | NONE | directionFromTarget; AI_DIR_TYPE; AI_DIR_TYPE_CENTER |
| 2 | stopDistance | stopDist; float; 0 |
| 3 | turnTarget | turnTarget; TARGET; TARGET_ENE_0 |
| 4 | NONE | walk; bool; false |
| 5 | NONE | directionalDistance; float; 0 |
| 6 | x | x; float; 0 |
| 7 | y | y; float; 0 |
| 8 | z | z; float; 0 |

S2 provides a declaration without a behavioral explanation. Its names for slots 1/4/5 do not prove those slots affect execution; S1 marks them NONE. “AlmostUnused” also does not establish when slot 0 matters. Both agree on explicit coordinate slots. [S1](https://soulsmodding.com/doku.php?id=er-refmat:ai-goals-and-params), [S2](https://eladidu.github.io/readable-ds-lua/dd/dac/_goals_8hpp.html)

### Known target types and destination assessment

S2 types both moveTarget and turnTarget as TARGET, defaulting to TARGET_ENE_0. S4 supplies the same shared enum described above. No goal-specific target whitelist or exact-goal usage example was found. POINT_EVENT, POINT_MOVE_POINT, TARGET_SELF, and arbitrary entity IDs must not be described as proven accepted destinations for this goal.

**Documented:** goal presence in the ER list, nine positional slots, explicit x/y/z labels, and S2's typed declaration. **Inference:** a plausible explicit-position movement candidate. **Unverified hypotheses:** that coordinates are an absolute world destination; their frame/units; whether it computes a fresh route or consumes an existing path; required route state; which target is consulted; ignored versus active slots; walk behavior; stopping/completion; obstacle avoidance; dynamic updates and interruption. The name alone cannot settle these questions.

### Minimal proposed experiment B — fixed-coordinate discrimination

After installation and separate implementation authorization, first inspect any local goal implementation/call site to establish safe required arguments, coordinate frame, and route prerequisites. If unresolved, document the experiment as exploratory; do not invent a route API or mandatory placeholder values.

Use the same soldier and open-ground baseline. Choose one recorded destination several steps away from both the soldier and any enemy/target position. Keep the moveTarget/facing references stationary and distinguishable from that destination. Request this goal once with the documented coordinate slots and locally confirmed other arguments, finite lifetime, and small explicit tolerance. Record full arguments, initial route state, coordinates/frame, version, override file and footage; repeat from the same start.

**Pass:** locomotion and arrival at the coordinate location rather than at the target reference. **Fail/inconclusive:** no movement, movement toward the reference, wrong location, or timeout. A failed trial cannot distinguish bad frame/arguments, missing path state, interruption, or unsupported behavior without further evidence. A successful trial proves only this fixed-coordinate case, not arbitrary world navigation or dynamic retargeting.

## Recommendation and stopping point

Start with experiment A: fixed region plus MoveToSomewhere. Its pathing semantics and a region-to-point setup mechanism have stronger documentation than the coordinate goal's behavior. Treat experiment B as the next isolated research test, not an approved architecture. Neither experiment has been implemented or run; M1 is not achieved. Research assignment complete; wait for further user instructions.

## 2026-10-13 — Reusable API library

Created [docs/api/INDEX.md](../docs/api/INDEX.md) with the user's Technical Knowledge Management instructions. Promoted existing findings into [AI goals](../docs/api/ai-goals.md), [related AI functions](../docs/api/ai-functions.md) and [target constants](../docs/api/ai-targets.md). Checked for existing entries first; the prior `docs/ai-goals.md`, `docs/ai-targets.md` and `docs/lua-api.md` files were empty. No new engine behavior was verified. Missing usage examples, source disagreements, displayed-default limitations and current-build uncertainty remain explicit. This update organizes completed research; it does not implement either experiment.

## Handoff 003 — Godrick Soldier resource trace

2026-10-13. Research/preparation complete; actual archive trace awaits user resources. Read the handoff, authoritative instructions, index, state and relevant movement findings. No installation access, asset copying, extraction, gameplay changes or tests performed.

### Selected instance

User-confirmed in Smithbox 2.2.6: map `m18_00_00_00` (Stranded Graveyard), instance `c4311_9007`, model `c4311`, entity `18000257`, NpcParam and NpcThinkParam `43114006`, logicId `10000`, position `(-102.524, 2.849, 157.056)`. These are user-observed local findings, not independent Codex binary verification. Tutorial-boss identity remains **unknown**; the approved Soldier of Godrick prototype requirement is unchanged.

### Evidence inspected

**R1 — local schema:** `TestingAI/tools/Smithbox_2_2_6_2026_09_20_b/Assets/PARAM/ER/Defs/NpcThinkParam.xml:29` defines logicId; line 36 defines separate battleGoalID. English annotations at `Assets/PARAM/ER/Param Annotations/English/NPC_THINK_PARAM_ST.json:23` and `:28` describe logic script and battle goal IDs. [libER generated ER schema](https://dasaav-dsv.github.io/libER/d8/df3/NPC__THINK__PARAM__ST_8hpp_source.html) corroborates this. **Locally inspected tool metadata**, not row 43114006 contents.

**R2 — local ER file dictionary:** `TestingAI/tools/Smithbox_2_2_6_2026_09_20_b/Assets/File Dictionaries/ER-File-Dictionary.json`:

| Line | Exact path | Outer archive association |
|---|---|---|
| 40989 | /script/010000_logic.luabnd.dcx | data0 |
| 44717 | /script/aicommon.luabnd.dcx | data0 |
| 5605 | /event/m18_00_00_00.emevd.dcx | data0 |
| 646357 | /map/mapstudio/m18_00_00_00.msb.dcx | data2 |

Also lists `script/aicommon_dlc01.luabnd.dcx`, `script/aicommon_dlc02.luabnd.dcx` and `action/script/c4311.hks` under data0. Tool dictionary Validated=true is its author's status, not verification of the current installation. Physical BHD/BDT pair spelling/casing and current patch-layer precedence were not established through installation inspection. Avoid mixing ER and older-game dictionaries.

**R3 — [ElaDiDu ER-focused tutorial](https://docs.google.com/document/d/e/2PACX-1vTbygMNnCuicYcs6u0ZVFsKV54YzNb4ZvlZiaTCBFVF5TqXWV7N6axiqR--fieMRMtV-ik1FsKuC7q6/pub):** describes Lua 5.0.2 AI, individual battle binders selected by Battle Goal ID, shared aicommon definitions and registration. Map-specific AI binder instructions concern older games; do not invent `m18_00_00_00.luabnd.dcx` for ER.

**R4 — [public ER-oriented 010000_logic.lua](https://github.com/mihai1rus/EldenRingCommonAiFuncs/blob/main/010000_logic.lua):** defines common10000_Logic(ai) and common10000_Interupt(ai, goal), delegating to common setup with event-request branches. The repository includes refactoring/custom additions; not an authenticated dump of our build.

**R5 — local tools:** WitchyBND `README.md` documents binder/DCX/LUAINFO/LUAGNL, file drag/drop and separate deferred decompilation. DSLuaDecompiler `README.md` distinguishes Lua AI and HKS character control; `DSLuaDecompiler/Program.cs:52–56` confirms file input and --output/-o. No built decompiler or Nuxe/UXM executable found in inspected workspace tool paths. [WitchyBND](https://github.com/ividyon/WitchyBND), [DSLuaDecompiler](https://github.com/katalash/DSLuaDecompiler).

**R6 — [Nuxe readme](https://github.com/JKAnderson/Nuxe/blob/main/dist/Readme.txt) and [UI source](https://github.com/JKAnderson/Nuxe/blob/main/Nuxe/Views/MainWindow.xaml):** ER PC support and Advanced separate-output/regex controls enable manual archive extraction without executable patching. No installed-build compatibility tested.

**R7 — [ER event investigation tutorial](https://soulsmodding.wikidot.com/tutorial:intro-to-elden-ring-emevd):** supports optional event/map inspection using DarkScript3 and map/param editors. **R8 — [ERAiAPI GoalFunc](https://eladidu.github.io/readable-ds-lua/d4/d58/class_goal_func.html):** supplies AddSubGoal declaration and queue behavior, now recorded in the API library. No new event instruction is documented without signature evidence.

### Organization and incomplete chain

Documented organization: outer game archives -> compressed LUABND binders -> script entries/metadata -> possibly compiled Lua requiring decompilation. Keep binder manifests, LUAINFO and LUAGNL entries. Model/animation/behavior resources and HavokScript action control are distinct from AI decision scripts. A .lua extension does not guarantee text.

```text
c4311_9007 in m18_00_00_00
  -> NpcThinkParam 43114006               [user-confirmed]
     -> logicId 10000                     [user-confirmed; schema documented]
        -> script/010000_logic.luabnd.dcx [exact documented candidate]
           -> common10000_Logic          [published example; local binding unknown]
     -> battleGoalID UNKNOWN              [field documented; value missing]
        -> corresponding battle binder   [convention documented; filename unknown]
  + script/aicommon.luabnd.dcx            [shared dependencies]
  -> active movement selection           [requires actual scripts/registration]
```

The logic can dispatch shared setup; battle scripts choose actions and queue goals. Common goal definitions can be Lua or engine-backed. Inspect registration, goal-name mappings and metadata before claiming runtime loading. Do not derive a battle filename from `c4311`, row 43114006 or logicId 10000. Shared logic edits could affect unrelated NPCs.

### Required and conditional extraction resources

Paths are relative to the Game directory after outer unpacking. Installation was not browsed. Nuxe handles the outer BHD/BDT layer; dictionary archive associations do not establish the current physical inventory by themselves.

| Expected path / convention | Format and purpose | Tool | Priority / evidence |
|---|---|---|---|
| regulation.bin, or NpcThinkParam row 43114006 export | Parameter container/row; capture battleGoalID and provenance | Smithbox read-only; Witchy if container unpack needed | Essential row evidence; R1; unverified repository copy exists |
| map/MapStudio/m18_00_00_00.msb.dcx | Compressed MSB map; instance/region references | Smithbox, Witchy optional | Essential before experiment; R2; workspace copy exists |
| script/010000_logic.luabnd.dcx | Compressed logic script binder | Nuxe -> Witchy -> DSLuaDecompiler if compiled | Essential; R2/R4 |
| script/aicommon.luabnd.dcx | Shared helpers, goal definitions/lookup dependencies | Same pipeline | Essential; R2/R3 |
| script/<actual battleGoalID>_battle.luabnd.dcx | Selected battle binder | Same pipeline | Essential; R3 convention; exact filename UNKNOWN |
| event/m18_00_00_00.emevd.dcx | Map activation/override and identity evidence | Nuxe; DarkScript3 | Optional now; required if unresolved activation; R2/R7 |
| event/common_func.emevd.dcx | Referenced common events | Nuxe; DarkScript3 | Conditional on map references; R7 |
| script/aicommon_dlc01.luabnd.dcx, script/aicommon_dlc02.luabnd.dcx | DLC shared dependencies | Nuxe/Witchy/decompiler | Conditional on actual references; R2 |
| action/script/c4311.hks | Character action control | Nuxe; DSLuaDecompiler if needed | Optional fallback for action constraints; R2/R5 |

No texture/CHRBND/ANIBND extraction is necessary for initial script tracing. Exact internal soldier script names remain to verify; inspect actual metadata instead of inventing internal paths.

### Local preparation and next step

`TestingAI/extracted/` exists and is empty; untouched/read-only to Codex. `TestingAI/map/MapStudio/m18_00_00_00.msb.dcx` exists (254348 bytes), as does `TestingAI/regulation.bin`; presence checked, contents/provenance not decoded. Root `/extracted/` ignore does not match nested `TestingAI/extracted/`; no tracked files listed there. Manual guide requires user correction before asset copying. No assets staged/committed or ignore edits made.

Follow [AI_EXTRACTION.md](../docs/AI_EXTRACTION.md) for manual capture, separate-output unpacking, copied-binder extraction, decompilation and success checks. Provide battleGoalID/build/provenance, untouched logic/common/battle binders plus metadata and relevant readable outputs. Then perform a read-only trace of active scripts. Confirm tutorial-boss identity independently; report a mismatch rather than changing requirements.

**Recommended experiment:** retain experiment A, one finite-lifetime MoveToSomewhere toward POINT_EVENT on reachable open ground, player elsewhere, baseline/test footage and repeated starting condition. Prerequisites: character identity, active script/registration, required arguments, region ID, installed build and offline mod-loading setup. Later use an isolated instance-specific override rather than a global common-logic edit. No destination ID, battle ID or insertion point invented. No experiment implemented. Stop awaiting resources or next authorization.

## Handoff 004 — Decompiled battle analysis

2026-10-13: fully read all1044 lines of `TestingAI/decompiled/431030_battle.lua`, binder manifest, listed project documents and prior research/extraction/API references. Detailed architecture, Mermaid flow, every movement/helper/attack call tuple and line references are in [GODRICK_SOLDIER_AI.md](../docs/analysis/GODRICK_SOLDIER_AI.md). No original/decompiled assets changed, unpacked, compiled or repacked; no installation access or in-game tests.

User now reports battleGoalID431030 and completed tools/extraction/decompilation. Locally confirmed: supplied battle file, archive/manifest entries and symbolic registrations. Param-row mapping and tutorial-boss identity remain user-reported/unresolved. Logic10000 and aicommon archives exist, but no readable shared versions are available; they were not unpacked. Earlier empty-extraction/missing-battle-ID/tool-build assumptions are historical and superseded by this delivery, not proof of a verified complete toolchain.

Observed: Activate sets relative weights and distinct REGIST_FUNC-bound callable table, then invokes shared selection with six arguments. Enemy-relative Approach/Sideway/Leave/Turn and approach-before-attack patterns are present. Interrupt clears/replaces queues. Unresolved: weight28 without binding; after-callback spelling mismatch; G/L global guard flags; third selection table; damage handler returnsfalse after changes. No fixes made. External helper source signatures/semantics are recorded separately from installed evidence in the API library.

No occurrence of any of the seven requested navigation candidates in the battle file. External pathing/coordinate documentation remains plausible but untested; no arbitrary world-space destination, live destination refresh or obstacle-routing guarantee established. Precise missing evidence and navigation matrix are in the analysis.

Recommendation refined: fixed region via documented SetEventMoveTarget/POINT_EVENT and **observed ApproachTarget**, adapting main Activate/Act13, rather than introducing MoveToSomewhere first. No implementation decision or gameplay success claimed. Region ID, shared update/registration and compatible bytecode compilation/repack/ModEngine loading need verification. Proposal compares target, region, MoveToSomewhere and coordinate approaches; includes controlled success/failure criteria and rollback. Next session limited to fixed-destination implementation/testing after user authorization and prerequisite checks.

## 2026-10-13 — Experiment002 evidence and limits

Main Activate can bypass the original weighted selector by directly queuing the existing Act13 ApproachTarget call shape, with walk=true and guard9910. Main Interrupt must also be isolated: original branches enqueue attacks/retreats despite fallback false. Prepared only these two callback changes; other25 executable functions unchanged after existing Lua5.0 compilation. This establishes static isolation, not runtime harmlessness or activation recurrence. Returning false leaves shared/native reactions unverified. NPC mapping remains supplied Smithbox evidence; read-only SoulsFormats.DecryptERRegulation of workspace regulation.bin failed Unknown DCX format, no rows decoded. User-reported Experiment001 normal-behavior test does not prove custom script loading. Report and exact artifact hashes: agent/experiments/EXPERIMENT_002_OBSERVABLE_OVERRIDE.md. Repack and same-instance offline A/B/A pending; no new APIs or controller implementation.

## 2026-10-13 — Experiment002 recovery verification

PASS for existing archive static integrity, with explicit provenance reconciliation. Source08D41B88 raw hash differs only by CRLF/LF: LF bytes reproduce expectedBB170E62 and backup5043ed2 blob exactly. All four extracted original paths missing; exact expected references recovered into a new evidence directory from backup Git objects and surviving Experiment001 XML. Existing7728-byte archive71D1B924…44A17 contains expected compiled Lua5DDE5015…AB660 and original LUAGNL; original/baseline entry/binder metadata match. Only executable callbacks2/24 change; disassembly confirms approach tuple and returnfalse. Original manifest/verifier and artifact inputs unchanged; no recompilation, repack, staging, deployment, game or Git changes. Detailed result/provenance/proposed future gate: agent/experiments/EXPERIMENT_002_RECOVERY_VERIFICATION.md. New recovery verifier writes evidence only; old original-path gate legitimately fails. Runtime success still pending.

## 2026-10-13 — Experiment002 workspace staging and configuration review

Fresh recovery checks passed; exact approved archive71D1B924…44A17 staged and hash verified inside project. Inspected user's actual ModEngine config/launcher read-only: one enabled mod root at Documents/ModEngine-2.1.0.0-win64/mod, containing only Experiment001 compiled overrideAC76EF91…38B53. No config changes required. Prepared pinned-hash user-run backup/disable/deploy/verify/rollback helper and exact commands; syntax checked, external write actions unexecuted. Original/installed archives unchanged; no game/Git/game-file changes. Review and test-order instructions: agent/experiments/EXPERIMENT_002_STAGING_AND_DEPLOYMENT.md. Next is user-run offline A/B/A, not agent deployment.

## 2026-10-13 — Experiment003 fixed-destination research

User confirms Experiment002 A/B/A behavioral success. Started research for chosen mapm18_00_00_00 destination(-108.095,3.183,150.961), NPC18000257. Scanned529/529 pinned public ER Lua scripts; concrete SetEventMoveTarget/POINT_EVENT approach and distance examples found. Coordinate goal only defined, no use found. Inspected workspace MSBE region metadata read-only:324 regions, no center at target, map hash unchanged. Documented new point-region Smithbox procedure and EntityID versus RegionID uniqueness requirements. Updated relevant API entries/index and created detailed Experiment003 research report/handoff. No gameplay prototype implemented: alternative reported before implementation, awaiting confirmed region/saved test map. Prior artifacts/installed files preserved; no cleanup, launch, deployment, tools installation or Git mutations. See agent/experiments/EXPERIMENT_003_FIXED_DESTINATION_RESEARCH.md.

## 2026-10-13 — Experiment003 saved map mismatch

User authorized implementation only after verifying final destination values. Repository-wide map search found only TestingAI/map/mapstudio/m18_00_00_00.msb.dcx. Read-only direct inspection confirms name/type/shape/XYZ/EntityID67676767, but RegionID remains-1822257825 instead of9063. HashE51E4DE6…64F10 unchanged during inspection. No separate disposable map location found. Stopped before compilation/staging; require exact saved file path or corrected save. Report: agent/experiments/EXPERIMENT_003_SAVED_MAP_CHECK.md. No prior artifacts, installed files or Git branches modified.

## 2026-10-13 — Corrected map verified; runtime prerequisite unresolved

Map changed during verification; re-read now matches EXP003_destination/Other/Point/RegionID9063/EntityID67676767/XYZ(-108.095,3.183,150.961). SHA256605B02422EE285ABD699107C7A24C8A49BE65DD759B5166A6E71D01AA66D79FD unchanged during fresh read. Checked325 regions/4683 parts/27 events/37464 group slots, no target-ID collision. Initial mismatch resolved. Relative map override location established. Available API/ER examples support the mechanism but do not establish this specific region's runtime lookup/availability. Honored explicit runtime-compatibility stop condition: no Lua prototype, build/staging/deployment or game launch. Need additional evidence or permission to test that remaining assumption experimentally. Current report: agent/experiments/EXPERIMENT_003_SAVED_MAP_CHECK.md; new evidence saved-map-605B0242-verification.json. Original/earlier artifacts preserved.

## 2026-10-13 — Experiment003 prepared under authorized runtime hypothesis

User waived pre-build compatibility requirement. Built minimal main Activate change from validated Experiment002: SetEventMoveTarget67676767 and ApproachTargetPOINT_EVENT/0.5; combat isolation unchanged. Lua5.0/header/function checks pass, only Activate changed from Experiment002. Existing BND4 writer verified with unchanged control, then new archive readback payload/metadata checks. Staged7792-byte Lua4CAA4E3E…F7F45 plus exact saved map605B0242…6D79FD. Map comparison against authenticated backup classified106 raw deltas as generated IDs, same-referent composite/RetryPoint index remaps and signed-zero NPC rotation; earlier workspace snapshot remains separately missing. All100 prior experiment files hash-preserved. Prepared two-file user backup/deploy/verify/rollback helper and offline A/B/A plan; external actions unexecuted. Region runtime behavior still unverified. Report: agent/experiments/EXPERIMENT_003_PREPARED_PROTOTYPE.md. No game launch/deployment/Git/Steam changes, installs or cleanup.

## 2026-10-13 — Experiment003B arrival/wait preparation

User reports Experiments002 and003 verified in-game;003 reaches the custom region, then wanders without attacking and returns. Source investigation found the baseline main Update delegates to Update_Default_NoSubGoal, whose published ER implementation succeeds on queue exhaustion; ApproachTarget also delegates guard/lifetime handling. Exact runtime wandering origin remains an inference. Prepared separate003B: only main Activate/Update changed, parent-goal state MOVING→ARRIVED→WAITING, renewable one-second Wait, and INCOMPLETE_HOLD outside arrival tolerance. Existing Interrupt/faction/hostility/map/shared logic untouched. Lua5.0 compilation/header/source/binder/readback checks pass;25/27 functions match003; all140 earlier build files preserved. Six actual-Lua callback tests pass with mocked engine APIs, not gameplay. Separate staged pair under build/experiment003b/deployment/arrival-wait; user-run helper syntax checked, live actions unexecuted. Future command recognition is not implemented/proven. Full analysis/evidence/deploy/rollback/pass-fail plan: [Experiment003B](experiments/EXPERIMENT_003B_ARRIVAL_WAIT.md). Runtime test pending; no game/live-installation/Git changes.

## 2026-10-13 — Agent 2 Placidusax arena research (no implementation)

Completed four research/planning documents in docs/arena: PLACIDUSAX_ARENA_FEASIBILITY, ARENA_ARCHITECTURE, ARENA_IMPLEMENTATION_PLAN and ARENA_TEST_MATRIX. Pinned soulstruct-vanilla source identifies m13_00_00_00, c4520_9000/entity13000830, collision h015000, encounter events13002830/34/35/40/41/46/49, music helper9005822/row452000, arrival regions13002834/36 and multiple death/progression writes. Published player inventory identifies arena Player part13000981. Smithbox source confirms NVA and nvmhktbnd/HKX navigation resources; actual elevated arena coverage remains unverified. No current-build m13 map/events/navigation references found in the targeted workspace inventory. Recommendation: read-only local audit, isolated empty-arena entry/return gate, then one c4311 soldier moving3–5metres to one point. Separate Think/goal registration required for reusable isolation; no new IDs assigned. Fallback is the already tested m18 location. Added exact WarpPlayer/SetPlayerRespawnPoint declarations to docs/api/arena-access.md and indexed them. No implementation, runtime experiment, deployment, save, game, Git or Agent1 artifact changes; user-reported002/003 success is distinguished from arena evidence.

## 2026-10-13 — Agent2 humanoid foundation comparison

Research-only comparison completed in docs/arena/HUMANOID_NPC_FOUNDATION_COMPARISON.md; includes exact source identifiers, lifecycle/activation analysis, candidate table, proposed proof, arena dependencies and unresolved runtime questions. Published map data proves Godrick c4311 and player-like c0000 Enemy templates exist; Nepheli map entity10000730 uses Npc523340014/Think523340000/CharaInit23340. Paramdex labels Puppet Buddy25900000/Npc+Think100000020/CharaInit23342, but Names are not foreign-key or selected logic/battle values. Mimic boss entity12020850/Npc526100965/Think90603100/CharaInit24020 has explicit copy/AI/transform encounter events; its spirit lifecycle adds Buddy dependencies. Public logic30000/31000 and common buddy/WhiteGhost5000 paths follow/leave/replan and can compete with movement. Candidate Think logic/battle mappings unavailable: no current-build row exports found; no guesses substituted. Recommendation: preserve Godrick as immediate movement control; separately validate fixed-equipment c0000 map Enemy for eventual player-like use, without ash spawning or dynamic copying. New API configuration/callback/copy reference indexed. No implementation, artifact/deployment/save/game/Git changes or runtime results; approved initial character decision unchanged.
