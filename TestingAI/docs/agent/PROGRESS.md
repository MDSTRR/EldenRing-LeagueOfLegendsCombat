# Progress

## 2026-10-13 — Experiment001 compiled archive verification

Confirmed rebuilt compiled archive; extracted into fresh verification-03-compiled with existing libraries. Verified compiled Lua hash, unchanged LUAGNL, entry IDs/names/flags and binder metadata against baseline. Rechecked all27 functions with exact instruction/constant/executable-shape comparison; documented added debug/source data and size changes. Prepared separate compiled ModEngine override and offline-test procedure. Original references unchanged; no config activation, game launch, Steam edits or behavior changes.

## 2026-10-13 — Experiment001 separate extraction verification

Verified baseline archive exists and compiled-source archive does not. Extracted baseline into fresh ignored verification-02 and matched both original payloads/entry metadata plus binder properties. Re-ran existing compiler into a fresh output; exact prior validated hash/header reproduced. Five references unchanged. Updated experiment/handoff; no deployment or NPC changes. Stopped at missing compiled archive.

## 2026-10-13 — Experiment001 continuation

User interactive Witchy baseline repack exited0. Decoded original/rebuilt with existing SoulsFormats/Oodle libraries and matched both payloads plus entry/binder metadata. Compiled untouched decompiled source using existing Lua50Compiler; header and all27 functions' instructions/constants/executable shape match. No correction needed. Prepared compiled binder copy for user repack and baseline-only deployment root; no actual loader configuration/game test. References unchanged, artifacts ignored, no downloads/tool edits/Steam access/commit/push.

## 2026-10-13 — Experiment001 inspection/baseline attempt

Read authoritative/relevant documents; identified original Lua5.0 header and built Lua50Compiler/native dependency. Prepared ignored disposable binder and copied offline Witchy runtime. Baseline repack failed: redirected PromptPlus console error; terminal silent run returned-1 and no archive. Stopped before compilation/deployment. Verified all reference hashes and disposable payload/manifest equality. Recorded detailed experiment and continuation handoff. No reference edits, downloads/installs, Steam access, game launch, commit or push.

## 2026-10-13 — Git configuration cleanup

Preserved existing root ignore rules and added coverage for nested third-party tools, extracted/decompiled resources, packed game data, build outputs and temporary files. Found DSLuaDecompiler's nested Git repository and its SoulsFormats repository; removed only the parent-index gitlink. Removed 19814 excluded entries from the parent index using cached removal, preserving local files and existing project/documentation/config staging. Previously committed tool files remain staged as deletions until a future user commit. No local deletions, nested-repository changes, game-installation access, commit or push. Verified excluded files and gitlinks no longer remain in the index and protected example source/config/documentation paths are not ignored.

## 2026-10-13 — Movement goal research

Read AGENTS.md and all three user-controlled documents. Completed research on both requested goals, recording exact positional labels, typed-reference differences, target evidence, source limitations, and one proposed experiment per goal in RESEARCH.md. Updated STATE.md. No gameplay implementation or tests; waiting for instructions.

Created `docs/api/INDEX.md` with the user's exact knowledge-management instructions and populated three reusable reference files from the completed research. Added signatures, parameters, purpose, sourced usage or explicit missing-example status, verification limits and cross-references. No gameplay changes.

## 2026-10-13 — Handoff 003 resource preparation

Inspected local Smithbox ER schema/file dictionary and tool documentation; researched primary ER AI/tool references. Recorded user identifiers, exact logic/common candidate archives and missing battleGoalID. Prepared `docs/AI_EXTRACTION.md`, added API resource/schema and AddSubGoal references, and updated research/index/state/blockers. No extraction, installation access, assets staged/committed or gameplay changes. Stopped awaiting resources.

## 2026-10-13 — Handoff004 complete

Read every listed project/reference document and complete1044-line battle source. Inspected supplied binder manifest; cataloged architecture, action selection, all movement/helper/attack calls and interruptions. Documented candidate navigation limits and a concrete region+ApproachTarget test proposal with deployment/rollback prerequisites. Added dedicated analysis and reusable API entries; updated research/state/blockers/extraction status and marked handoff004 analysis complete. No game-resource edits, unpacking/repacking, installation access, tool installs or gameplay tests. Historical missing battleGoalID/extraction blockers superseded.

## 2026-10-13 — Experiment002 observable override prepared

Read the Experiment002 assignment and relevant project evidence. Prepared disposable approach-only source and compiled it with the existing Lua5.0 toolchain:46777 bytes, matching header/27 functions; only main Activate/Interrupt executable functions changed. Other25 match original; LUAGNL/manifest copies match and five original reference hashes unchanged. Interactive repack pending; no archive staged, external config edits or game launch. Added detailed report and active experiment002 handoff with exact commands, NPC evidence, limitations, A/B/A and rollback. Negative archive-verifier test correctly rejected unchanged baseline. See agent/experiments/EXPERIMENT_002_OBSERVABLE_OVERRIDE.md. User-reported Experiment001 game test is preliminary and does not prove override loading.

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

## 2026-10-13 — Agent 2 arena research completed

Added four docs/arena research/design/plan/test documents and reusable arena-access API declarations. Source-confirmed encounter/access identifiers; explicitly unresolved current-build correspondence and ordinary soldier navigation coverage. Research only: no arena prototype or runtime result. Agent1 arrival experiments remain separate. Next arena action is read-only m13 map/event/navigation audit before any implementation. See [feasibility](../docs/arena/PLACIDUSAX_ARENA_FEASIBILITY.md).

## 2026-10-13 — Humanoid foundation research complete

Added [candidate comparison and proposed proof](../docs/arena/HUMANOID_NPC_FOUNDATION_COMPARISON.md) plus reusable API reference/index entries. Identified source-backed c0000 map templates, spirit selectors and Mimic copy lifecycle; left uninspected Think row contents explicitly unknown. Recommended immediate Godrick control, future fixed-equipment c0000 validation; no permanent foundation change. No experiments or arena artifacts modified and no runtime test performed.
