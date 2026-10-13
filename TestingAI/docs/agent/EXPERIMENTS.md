# Experiments

## Experiment001 — Lua round-trip (2026-10-13)

Current: compiled archive exists and passed fresh verification-03-compiled extraction. Lua matches validated compiler output; LUAGNL/IDs/names/flags/binder metadata match baseline; all27 functions match executable structure. Debug/source data and file sizes differ, runtime impact untested. Separate compiled override prepared, not enabled. Next: actual ModEngine config inspection and manual offline behavior/load evidence; no game launch authorized here.

Latest verification: fresh `verification-02/` extraction matches original Lua/LUAGNL, entry IDs/names/flags and binder metadata. Fresh compilation reproduces validated compiled bytes/header. Compiled-source archive still missing; stop there. No deployment or behavior changes. See report's latest-verification section.

**Continuation: baseline repack verified; compilation/header/27-function comparison passed.** User's interactive Witchy invocation exited0. Independently decoded baseline matches original Lua/LUAGNL payloads and metadata. Untouched source compiled directly with existing Lua50Compiler/native lua502.dll, matching header/instructions/ordered constants/executable shape in all27 functions. Original references unchanged. Compiled binder copy prepared for manual Witchy repack; baseline-only deployment candidate prepared but not enabled. ModEngine config/launcher absent, no game test. Details: [experiment report](experiments/EXPERIMENT_001_LUA_ROUNDTRIP.md). Earlier automatic-console failure and no-experiment statements are historical.

2026-10-13: No experiments performed. Game files unavailable during download. RESEARCH.md proposes experiment A (fixed region / MoveToSomewhere) and experiment B (coordinate discrimination / MoveFollowPathSpecifyPos). These are plans only; neither is implemented or authorized for execution by the research assignment.

Handoff 003: user-reported Smithbox findings are resource evidence, not a movement experiment. No gameplay test or extraction performed. Fixed-region test still awaits identity, scripts, arguments and offline-loading prerequisites.

Handoff004: inspected battle text and manifest only. No experiment run. Current proposal in docs/analysis/GODRICK_SOLDIER_AI.md uses a fixed region via POINT_EVENT and the observed ApproachTarget goal; earlier MoveToSomewhere proposal remains a comparison candidate.

## 2026-10-13 — Experiment002 observable override prepared

Read the Experiment002 assignment and relevant project evidence. Prepared disposable approach-only source and compiled it with the existing Lua5.0 toolchain:46777 bytes, matching header/27 functions; only main Activate/Interrupt executable functions changed. Other25 match original; LUAGNL/manifest copies match and five original reference hashes unchanged. Interactive repack pending; no archive staged, external config edits or game launch. Added detailed report and active experiment002 handoff with exact commands, NPC evidence, limitations, A/B/A and rollback. Negative archive-verifier test correctly rejected unchanged baseline. See agent/experiments/EXPERIMENT_002_OBSERVABLE_OVERRIDE.md. User-reported Experiment001 game test is preliminary and does not prove override loading.
