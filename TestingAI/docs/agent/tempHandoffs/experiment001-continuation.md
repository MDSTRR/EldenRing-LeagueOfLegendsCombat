# Experiment001 continuation — offline loading stage

Status: superseded by [Experiment002 continuation](experiment002-continuation.md), 2026-10-13. Static archive/compiler work complete. User's Experiment002 assignment reports preliminary normal detection/approach/attacks after compiled-source ModEngine2 launch; that does not prove custom Lua execution. Current task permits a separate observable override, but no agent game launch or external installation changes. Below is historical context.

Current findings supersede historical paragraphs below: compiled archive exists,11024 bytes/hashAC76EF91121F2274DDF1D44AC6D51B88790437336F696D255B5D0846E8738B53. Extracted into verification-03-compiled. Lua payload matches validated compiler hash; LUAGNL/IDs/names/flags/binder metadata match baseline; all27 functions match instructions/constants/executable shape. Extra source/debug metadata changes size/hash and may affect diagnostics/memory; runtime acceptance not established. Five reference hashes unchanged.

Prepared separate inactive mod roots: TestingAI/build/experiment001/deployment/baseline and deployment/compiled-source, each with script/431030_battle.luabnd.dcx. No actual ModEngine config/launcher found; no configuration activated. Next session: inspect supplied actual configuration, preserve existing settings/overrides, use only one variant and plan supported offline anti-cheat-disabled baseline/compiled comparisons. User must authorize game launch separately; no game access implied by override preparation. Read agent/experiments/EXPERIMENT_001_OFFLINE_TEST.md and current experiment report. Revert by disabling only test entry/restoring prior config; no Steam changes or file deletions.

## Historical checkpoints

Latest continuation: no deployment authorized by latest instruction. Baseline archive exists, compiled-source archive missing. Extracted baseline entries into fresh `TestingAI/build/experiment001/verification-02/` and matched original payloads/IDs/names/flags/binder metadata. Fresh source compilation there reproduces prior compiled hash68B5E0399D7994EAE9A9B5D9E89342EC338137FE05103E147A081486520EF829/header; reports binder-verification.json and compilation-verification.json. Five reference hashes unchanged. Stopped at missing compiled archive; no deployment actions or NPC changes.

Read experiment report first. User baseline Witchy run succeeded/exit0; decoded payloads/metadata match originals. Existing Lua50Compiler/native lua502.dll compiled untouched source with no corrections; header and all27 functions' instruction/constants/shape comparisons pass. Five original hashes unchanged. Baseline-only deployment candidate exists but is not enabled; no game test.

Outputs in ignored TestingAI/build/experiment001 include baseline-verification.json, compiled-source/function-comparison.json, compile-source.ps1, compiled bytecode and separate compiled binder folder; deployment/baseline/script contains verified unchanged-bytecode archive. Earlier automatic PromptPlus failures are historical; interactive user run works.

Next action: user repacks compiled-source/431030_battle-luabnd-dcx with copied Witchy interactively and provides exit/output. Decode generated compiled archive; confirm compiled Lua hash68B5E0399D7994EAE9A9B5D9E89342EC338137FE05103E147A081486520EF829, original LUAGNL hash and baseline metadata. Keep compiled/baseline roots separate. Do not repair source anomalies or claim runtime equivalence from structural checks alone.

Need actual ModEngine configuration/launcher supplied in workspace before deployment. Smithbox project.json is not that configuration. Test only baseline/compiled-source preservation; no movement, input, camera or combat changes. Any game testing offline with anti-cheat disabled through supported mod launch setup. Do not access Steam installation without authorization or commit/push.

Documents updated: EXPeriment report, EXPERIMENTS, PROGRESS, RESEARCH, STATE, BLOCKERS and this handoff. No modifications to reference resources or user-controlled documents.
