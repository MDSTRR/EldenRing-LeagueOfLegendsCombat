# Experiment 001 — Lua round-trip validation

2026-10-13 follow-up: the user's Experiment002 assignment reports successful preliminary game launch through ModEngine2 with the compiled-source override installed and normal spear-soldier detection/approach/attacks. This is user-reported evidence, not an independently observed test or proof of custom Lua loading. Static round-trip work is complete. [Experiment002](EXPERIMENT_002_OBSERVABLE_OVERRIDE.md) prepares the observable A/B test; its archive/game results remain pending. Statements below describe the earlier verification session.

Date: 2026-10-13. **Current status: baseline and compiled-source archive verification passed; separate offline-test overrides prepared but not enabled. Actual ModEngine loading/in-game compatibility remain unverified.** Latest results below supersede historical missing-archive statements. No game launch, Steam edits, behavior changes, reference edits, downloads/installs, commit/push.

## Phase A — inspected

Read project instructions/user requirements, agent state/research/experiment/blocker notes, API references and GODRICK_SOLDIER_AI.md. Located:

- Original archive: `TestingAI/extracted/431030_battle.luabnd.dcx`.
- Original bytecode: `TestingAI/extracted/431030_battle-luabnd-dcx/431030_battle.lua`.
- Binder manifest and LUAGNL: same folder, `_witchy-bnd4.xml` and `431030_battle.luagnl`.
- Decompiled source: `TestingAI/decompiled/431030_battle.lua`.

### Bytecode format — directly inspected

First22 bytes: `1B-4C-75-61-50-01-04-08-04-06-08-09-09-08-B6-09-93-68-E7-F5-7D-41`.

| Property | Observed value |
|---|---|
| Signature | ESC Lua |
| Version | 0x50 / Lua5.0; header does not identify patch version |
| Endianness | 1 / little-endian |
| Integer / size_t / instruction bytes | 4 / 8 / 4 |
| Opcode / A / B / C bits | 6 / 8 / 9 / 9 |
| lua_Number bytes | 8 |
| Header test double | 31415926.535897933 |

Interpretation corroborated by existing `TestingAI/tools/DSLuaDecompiler/LuaDecompilerCore/LuaFile.cs:62–139`, which selects Lua50 on0x50 and reads these header fields. This is not Lua5.1, LuaJIT or HKS5.1 bytecode. Compatibility cannot be inferred from `.lua` extension alone.

### Existing compiler — exercised after baseline success

Found built `TestingAI/tools/DSLuaDecompiler/LuaCompiler/bin/Release/net9.0/LuaCompiler.dll` and `LuaNative/lua502.dll`, plus built DecompilerTester and DSLuaDecompiler. Earlier searches without `--no-ignore` missed ignored build outputs; the earlier “no executable” observation was incomplete and is superseded.

`LuaCompiler/Compilers/Lua50Compiler.cs` implements `CompileSource(string source, Encoding encoding)` by loading source, retrieving the Lua closure prototype and calling LuaUDump. `LuaCompiler/Bindings/Lua50.cs` binds `LuaNative/lua502.dll` and `luaL_loadbuffer`/`luaU_dump`. The project copies the native DLL into build output. These are third-party tool functions, not Elden Ring APIs.

`DecompilerTester/Program.cs` uses Lua50Compiler for Lua50 and Shift-JIS encoding, then compares function instructions/child structure. That comparator does not by itself prove complete semantic equivalence or compare every constant/metadata field. The tester regenerates source internally, so it is not automatically a compilation test of our supplied decompiled file.

**Direct recompilation/manual correction:** the supplied source compiled directly using Lua50Compiler and Shift-JIS encoding after baseline verification. No source corrections were needed or made. Header bytes and all27 functions' instructions, ordered constants, NumParams, NumUpValues, IsVarArg, MaxStackSize and child counts matched under the existing LuaFile parser. No source anomalies were repaired. This supports executable structural equivalence under that parser; complete byte identity and in-game equivalence are not claimed. No modern compiler substitution.

### Binder metadata — inspected input only

Manifest records BND4, filename431030_battle.luabnd.dcx, DCX_KRAK level6/KRAK, version07D7R6, IDs/Names1/Names2/Compression, little-endian binder settings, Unicode names and extended0x04. Lua entry ID1000 and LUAGNL ID1000000, each Flag1. Keep the entire manifest/root metadata and both payloads. Do not replace them with a one-entry binder or edit the embedded original build path.

## Phase B — initial automated attempts (historical)

All outputs are inside ignored `TestingAI/build/experiment001/`. Copied the unpacked binder to:

`TestingAI/build/experiment001/unchanged-bytecode/431030_battle-luabnd-dcx/`

Verified byte-identical Lua, LUAGNL and manifest copies before/after attempts. Copied WitchyBND3.0.1.0 to `witchy-runtime/` so its own settings/runtime extraction do not modify the reference tool installation. Only copied settings changed: Offline=true, EndDelay=0, PauseOnError=false, GitBackup=false. DOTNET_BUNDLE_EXTRACT_BASE_DIR was set process-locally to the experiment's `dotnet-runtime/`; no permanent environment change.

Attempts and actual evidence:

1. Initial sandbox startup failed committing .NET bundle extraction into its temporary directory. A permitted unsandboxed help invocation exited0 with no captured output; this was not a repack.
2. Hidden, redirected help invocation: exit1, `PromptPlus requires a terminal/console without redirection environment!.` Saved in `witchy-help.stderr.txt`.
3. Hidden, redirected baseline invocation with documented `-s` flag and disposable folder: exit1 with the same message. Saved in `baseline-repack.stderr.txt`.
4. Terminal-attached `-s` baseline invocation: Witchy exit **-1**, no explanatory output and no archive generated. The enclosing shell returned0 after reporting that exit; shell status must not be treated as tool success.

The local README documents folder repacking and `-s`. [Witchy Program.cs](https://github.com/ividyon/WitchyBND/blob/main/WitchyBND/Program.cs) corroborates CLI handling. The redirected console error is known; terminal attempt's reason remains unknown. Stopped at that boundary initially. User subsequently ran Witchy interactively and reported successful BND4 repack/exit0; continuation results follow.

### Baseline continuation — independently verified

Generated archive: `TestingAI/build/experiment001/unchanged-bytecode/431030_battle.luabnd.dcx`, 5168 bytes, SHA256 `DE1DED63C3DB3C8555D91C22B976C37E94B791CC1DC7DCD742A6573B365D22B1`. Original archive is5184 bytes with a different hash.

Read original and rebuilt archives using the **existing** SoulsFormats.dll from DSLuaDecompiler's netstandard2.1 build, with the existing copied oo2core_6_win64.dll explicitly loaded. No replacement packer/writer used. Both decoded successfully as BND4/DCX_KRAK. Matched entry count2; Lua ID1000 and LUAGNL ID1000000; exact embedded names/flags; both payload byte arrays/hashes; Version/Format/BigEndian/BitBigEndian/Unicode/Extended/Unk04/Unk05/Compression. The existing DCX_KRAK reader asserts its level6 header. Results saved as `baseline-verification.json`. Compressed-size/hash difference does not indicate changed Lua content.

### Compiled-source continuation — local checks passed

Untouched source copied to `compiled-source/source-unchanged.lua`. Existing compiler runtime copied to `compiled-source/compiler-runtime/` without altering third-party directories. Compiled output: `compiled-source/431030_battle.lua`, **79749 bytes**, SHA256 `68B5E0399D7994EAE9A9B5D9E89342EC338137FE05103E147A081486520EF829`. No compiler exception or source edit; no full-file byte identity. The native compiler dumps source/debug information as well as executable content; this experiment does not fully inventory all debug/source metadata differences.

Header first22 bytes match exactly. Parsed27 functions (IDs0–26): all instructions, ordered constants and listed executable shape fields match. Detailed rows: `compiled-source/function-comparison.json`. Comparator does not establish every debug field or game-runtime behavior. Source remains unchanged, including earlier callback/global concerns.

Prepared **separate** compiled binder input at `compiled-source/431030_battle-luabnd-dcx/`; replaced only its Lua payload with compiled output. Manifest and LUAGNL hashes remain identical. No compiled-source archive generated yet because Witchy repack requires the user's interactive console in this environment. Reproducible existing-library compilation command is saved in ignored `TestingAI/build/experiment001/compile-source.ps1`; run from repository root with pwsh7/.NET9-compatible runtime. It defaults to a new output and refuses overwrite/outside-experiment paths.

Executed that saved script as a reproducibility check: `compiled-source/recompiled-again.lua` matches the first compiled output's full SHA256 exactly. No source correction or reference write occurred.

### Sizes and hashes

| Reference | Bytes | SHA256 |
|---|---|---|
| Original archive | 5184 | E17D7A650381DFED962EA102670E3B6C1E44BAE93E953041F75697A4B57028B3 |
| Original bytecode | 19737 | B12260E8DDFA94A6BBAD117AAB8A5B965644BC705AFC49AC04E67443F31C9C55 |
| LUAGNL | 1504 | 2A00F44377EB2DE66364FD08FE53E7048ED6F5BC9C9D4C59A5EEC2B8142DD8CC |
| Manifest | 824 | 319BB7058E38974F0262FEF77B019EB1BDE96763AA19FECFCC459937D0DD676F |
| Decompiled source | 40242 | BB170E62F3D24AEFC5CC1B900BD05EB30B9433C2265C7C0404457EFC34A072A4 |

All five reference hashes unchanged after continuation. Original baseline input hashes match. Rebuilt baseline archive and compiled bytecode results are listed above; compiled-source archive remains pending. Compilation completed without a reported error.

Evidence files under experiment001 include original hash/header/error reports, baseline-verification.json and compiled-source/function-comparison.json. Runtime/assets remain ignored. A baseline-only deployment candidate now exists at `deployment/baseline/script/431030_battle.luabnd.dcx`; it has the verified baseline archive hash. It is not configured/enabled or tested in-game.

## Phase C — baseline candidate prepared; local actions needed

No ModEngine2 configuration or launcher was found in a `--hidden --no-ignore` filename search inside TestingAI. `TestingAI/project.json` is Smithbox configuration and names a Steam GameRoot; it is not a ModEngine config. The installation path was not accessed. No game launch occurred.

**Next local step: compiled-source repack in an interactive PowerShell console.** From repository root:

```powershell
& '.\TestingAI\build\experiment001\witchy-runtime\WitchyBND.exe' '.\TestingAI\build\experiment001\compiled-source\431030_battle-luabnd-dcx'
$LASTEXITCODE
```

Capture output/exit. Expected sibling output, not yet created: `TestingAI/build/experiment001/compiled-source/431030_battle.luabnd.dcx`. Stop on error; do not install/update a tool silently. The already successful baseline repack need not be repeated.

Before enabling compiled deployment, decode the generated archive and compare its Lua payload to the compiled output, LUAGNL to the original and binder metadata to baseline. Preserve separate baseline/compiled deployment roots and select only one at a time. Actual ModEngine config/launcher must be supplied for inspection; no guessed configuration has been written.

**Next manual in-game test, conditional on those checks:** provide/inspect actual `config_eldenring.toml` and ModEngine launcher; prepare a separate baseline-only mod root containing `script/431030_battle.luabnd.dcx`. Enable only that test root (avoid competing overrides). Use ModEngine's supported offline/anti-cheat-disabled launch setup; never launch this mod test through the normal anti-cheat-enabled game. Compare the selected soldier's normal activation, movement, attacks and interruptions to an unmodded baseline, recording build, load evidence and footage. Normal behavior alone is not proof the override loaded, since payload is unchanged; verify loader configuration/log/file-redirection evidence separately. Then test a separately labeled compiled-source variant, never confusing it with unchanged-bytecode baseline.

**Revert:** disable only the experiment's ModEngine entry or move its test override out of the enabled mod root. Restore any preexisting conflicting override from its backup. Original Steam files require no restoration because they were not edited. No map/ThinkParam changes are part of Experiment001. Keep outputs for diagnosis; no file deletion needed.

## Remaining verification

### Compiled-source archive — verified and offline override prepared

User reported completed compiled repack. Confirmed `TestingAI/build/experiment001/compiled-source/431030_battle.luabnd.dcx` exists, size **11024 bytes**, SHA256 **AC76EF91121F2274DDF1D44AC6D51B88790437336F696D255B5D0846E8738B53**.

Decoded it using existing SoulsFormats/Oodle libraries and extracted both payloads into the new disposable `TestingAI/build/experiment001/verification-03-compiled/`. Exact embedded entry names and flags match the validated baseline. Lua ID1000 has size79749/hash68B5E0399D7994EAE9A9B5D9E89342EC338137FE05103E147A081486520EF829: byte-identical to validated compiler output, **not** the baseline Lua. LUAGNL ID1000000 has size1504/hash2A00F44377EB2DE66364FD08FE53E7048ED6F5BC9C9D4C59A5EEC2B8142DD8CC: byte-identical to baseline.

Both entries retain Flag1. BND4 Version07D7R6, IDs/Names1/Names2/Compression format, endian settings, Unicode, Extended0x04, Unk04/Unk05 and DCX_KRAK match. Existing reader accepts KRAK level6 header. Entry count2, IDs and exact original embedded path strings match. Report: `verification-03-compiled/archive-verification.json`.

Freshly parsed the archive's Lua versus baseline: matching first22 header bytes and **27/27 functions** with identical instruction bytes, ordered constants (including bitwise numeric comparison), parameters/upvalue counts, vararg flags, stack sizes and child counts.

Differences: baseline archive5168 vs compiled11024 bytes; baseline Lua19737 vs compiled79749 bytes; hashes differ. Debug/source metadata changed: main chunk source-name string length7 vs41286 under parser representation; main line-info count0 vs76; child function1 line-info0 vs25/local records0 vs4; function2 line-info0 vs906/local records0 vs10. Full per-function debug counts are saved in the report. These metadata differences explain increased size and do not change the compared executable structure. They may affect diagnostic/debug introspection or memory/size; engine acceptance and behavior effects cannot be ruled out without actual game testing. No metadata stripping/correction performed.

Copied verified compiled archive to **separate** `TestingAI/build/experiment001/deployment/compiled-source/script/431030_battle.luabnd.dcx`; hash checked identical. Existing baseline root remains separate. No loader config edited/enabled. No actual ModEngine config/launcher available in repository. Next stage documented in [EXPERIMENT_001_OFFLINE_TEST.md](EXPERIMENT_001_OFFLINE_TEST.md): inspect actual configuration, enable only one variant, verify loading and ordinary behavior offline with anti-cheat disabled, record evidence, and revert by disabling the experiment entry. Do not launch yet.

All five reference hashes checked unchanged after extraction/copy. No blocker to static compiled archive verification; next blocker is absent actual ModEngine setup and manual in-game evidence. User's latest instruction authorizes preparing the override only, not game launch or Steam changes.

### Latest requested verification — separate disposable extraction

2026-10-13 continuation: first checked exact archive locations. Unchanged-bytecode archive exists at `TestingAI/build/experiment001/unchanged-bytecode/431030_battle.luabnd.dcx`; compiled-source archive **does not exist** at `TestingAI/build/experiment001/compiled-source/431030_battle.luabnd.dcx`.

Decoded the existing rebuilt baseline with the same installed SoulsFormats/Oodle libraries and wrote its two entries into the fresh `TestingAI/build/experiment001/verification-02/` directory. This is an actual disposable payload extraction, distinct from the prior in-memory comparison. Checked against the original archive: two entries, Lua ID1000/name/Flag1 and LUAGNL ID1000000/name/Flag1; both payloads exactly identical. Compared Version, Format, BigEndian, BitBigEndian, Unicode, Extended, Unk04, Unk05 and Compression; all match. Results: `verification-02/binder-verification.json`.

Extracted Lua size19737/hashB12260E8DDFA94A6BBAD117AAB8A5B965644BC705AFC49AC04E67443F31C9C55; LUAGNL size1504/hash2A00F44377EB2DE66364FD08FE53E7048ED6F5BC9C9D4C59A5EEC2B8142DD8CC. Baseline archive remains5168 bytes/hashDE1DED63C3DB3C8555D91C22B976C37E94B791CC1DC7DCD742A6573B365D22B1. Unchanged-bytecode round trip **passed**.

Then ran the saved compiler script on unchanged decompiled source with a fresh output:

```powershell
& '.\TestingAI\build\experiment001\compile-source.ps1' -OutputFile 'TestingAI/build/experiment001/verification-02/compiled-source.lua'
```

Fresh compilation succeeded without corrections/errors. Output79749 bytes/hash68B5E0399D7994EAE9A9B5D9E89342EC338137FE05103E147A081486520EF829: full-byte identical to the previously validated compilation, and first22-byte header matches original. Consequently it reproduces the prior27-function structural comparison; this is not an in-game equivalence claim. Results: `verification-02/compilation-verification.json`.

All five original reference hashes checked unchanged. No deployment actions taken in this continuation; existing disabled baseline candidate left intact. No source/behavior changes, game launch, install/download, commit/push. **Stopped at missing compiled-source archive**; the user's interactive repack step above is still needed before archive verification can continue. Latest instruction expressly prohibits deployment.

Remaining: actual ModEngine configuration/build/override loading and offline in-game behavior preservation. Baseline packaging, compiler/header/27-function checks and compiled archive payload/metadata verification passed. A complete in-game workflow is not established.
