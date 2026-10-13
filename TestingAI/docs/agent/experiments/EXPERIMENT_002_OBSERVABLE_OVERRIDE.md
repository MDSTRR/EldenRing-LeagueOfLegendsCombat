# Experiment 002 — preparation and verification report

2026-10-13. **Prepared and compiled; interactive repack and in-game A/B results pending. Success criterion not achieved.** The user-provided assignment `EXPERIMENT_002.md` is preserved.

## Prior evidence and NPC selection

Experiment001 independently validated unchanged-bytecode and compiled-source binder payloads, IDs, names, flags and metadata. Untouched-source compilation preserved all 27 functions' instructions, constants and executable shape; debug data differed. The Experiment002 assignment reports a preliminary ModEngine2 game launch with the compiled-source override and normal detection/approach/attacks. This is user-reported runtime evidence, not proof the override loaded. See [Experiment001](EXPERIMENT_001_LUA_ROUNDTRIP.md).

Selected project evidence: Smithbox instance `c4311_9007`, model `c4311`, entity `18000257`, map `m18_00_00_00`, position `(-102.524, 2.849, 157.056)`, NpcParam/NpcThinkParam `43114006`, logicId `10000`, battleGoalID `431030`. These are the user's supplied Smithbox/Handoff004 findings. The inspected battle source registers `GOAL_RoamArmySpearmen431030_Battle`; the archive manifest names `431030_battle.lua`. This supports selecting the specified instance, but does not independently verify its map/param chain or identify it as the Soldier of Godrick tutorial boss. Use Smithbox to confirm the same entity before testing; if the spear soldier tested previously is another instance, record its full mapping first.

An attempted read-only inspection of workspace `TestingAI/regulation.bin` through the existing SoulsFormats `SFUtil.DecryptERRegulation` failed with **Unknown DCX format**. No rows were read or files changed. Do not promote the user-supplied mapping to independently verified data. Installed game build and workspace asset provenance remain unspecified.

## Minimal behavior change

Source copied from `TestingAI/decompiled/431030_battle.lua`. Only the main registration's two callback bodies change:

1. Main `Goal.Activate` (original lines14–403): retain `Init_Pseudo_Global` and deletion of effect observers5025/5027/5030; clear the current subgoal queue; replace weighted action selection with exactly:

   ```lua
   f2_arg2:AddSubGoal(GOAL_COMMON_ApproachTarget, 10, TARGET_ENE_0, 3, TARGET_SELF, true, 9910)
   ```

   Enclosing arguments: goal ID, lifetime10. Supplied goal slots: moveTarget enemy, stopDistance3, turnTarget self, walk true, guardStateId9910. Act13 (original lines543–566) uses this call shape, stop distance and guard action; its walk flag can be true under effect13282. No undocumented extra slots/defaults are invented. Forcing this observed walk variant bypasses random weights/cooldowns/role branches. See [ApproachTarget reference](../../docs/api/ai-goals.md#target-relative-goals-observed-in-431030).

2. Main `Goal.Interrupt` (original lines916–1030): return false without enqueuing actions. Original interrupt branches clear queues and enqueue attacks/retreats, so changing only weight13 would not isolate the experiment. False is the original callback's fallback return; it does **not** establish that native/shared interrupts are suppressed.

Registration, Initialize, Update, Terminate, every action/helper function, and the separate after-attack registration/callbacks are preserved. Attack functions remain defined but are not selected by the modified main callback. No input/controller/coordinate navigation is implemented. All NPCs selecting battle431030 may be affected; this is not an entity-specific override.

**Prediction, not verification:** after acquiring the player, the NPC walks/guards toward the enemy target, stops near the supplied distance3, and does not enqueue the original script's melee actions. If the battle lifecycle reactivates it, it approaches again when the player moves away. Exact stopping distance, facing, recurrence after goal success/timeout, guard animation and shared/native reactions require the game test. Do not claim the NPC cannot hurt the player under every condition.

## Actual local results

Existing Lua50Compiler/native lua502.dll compiled the disposable source directly with Shift-JIS encoding, without compilation errors. No new tools installed.

| Check | Actual result |
|---|---|
| Source SHA256 | `666D2258A50707E8697737DDA9B1B6B8413A5A7AC3106B9A5699E5CE37F80A89` |
| Bytecode size / SHA256 | 46777 bytes / `5DDE5015307C7844D98B2E5C27F84665A24B969221F36A82BDE41188E39AB660` |
| Header | `1B-4C-75-61-50-01-04-08-04-06-08-09-09-08-B6-09-93-68-E7-F5-7D-41`; matches original Lua5.0 format |
| Parsed function count | 27, unchanged |
| Executable differences | Only traversal indices2 (main Activate) and24 (main Interrupt) |
| Other 25 functions | Bytecode, ordered constants, parameter/upvalue/vararg/stack shape and child counts match original bytecode |
| LUAGNL and manifest copies | Byte-identical to original, including entry1000/1000000, names/flags, BND4 metadata and DCX_KRAK settings |
| Five references | Original source, original bytecode, LUAGNL, manifest and archive hashes unchanged |
| Repacked Experiment002 archive | Not yet produced or verified |
| Deployment archive | Not staged or enabled; inactive directory prepared |

Compiler debug/source metadata also differs; byte-identical archive/source equivalence is neither expected nor claimed. A matching header proves format consistency, not current-build compatibility.

Machine-readable evidence: `TestingAI/build/experiment002/preparation-verification.json`. `prepare.ps1` reproduces preparation using existing compiler/parser and refuses an existing output source. `verify-and-stage.ps1` extracts a repacked archive into a fresh verification directory, checks payload hashes and baseline IDs/names/flags/compression/binder metadata/reference hashes, then copies only a passing archive to the inactive workspace mod root. A negative test using the Experiment001 unchanged-bytecode archive correctly failed the modified-Lua hash check and staged nothing; this tests rejection only, not the pending new archive.

## Output locations and interactive boundary

All paths below are relative to repository root:

- Modified text: `TestingAI/build/experiment002/source/431030_battle.lua`.
- Ready binder folder: `TestingAI/build/experiment002/approach-only/431030_battle-luabnd-dcx/` (compiled Lua, original LUAGNL and original `_witchy-bnd4.xml`).
- Expected repacked archive: `TestingAI/build/experiment002/approach-only/431030_battle.luabnd.dcx` — currently absent.
- Inactive mod root: `TestingAI/build/experiment002/deployment/approach-only/`; its `script/` directory is currently empty.

Prior automated Witchy attempts failed its interactive-console requirements. The user successfully used a normal PowerShell console for Experiment001. Run from repository root, with the game closed:

```powershell
& '.\TestingAI\build\experiment001\witchy-runtime\WitchyBND.exe' '.\TestingAI\build\experiment002\approach-only\431030_battle-luabnd-dcx'
$LASTEXITCODE
```

Require success/exit0 and the expected archive. Then run in **PowerShell 7** from repository root:

```powershell
& '.\TestingAI\build\experiment002\verify-and-stage.ps1'
```

This second step only validates and stages inside the workspace. Stop on any failure and retain output/evidence. Alternatively have the agent perform verification after providing repack results. The external ModEngine2 configuration/launcher is not present in the workspace and was not edited. Before enabling, inspect the actual configuration to identify its mod root and other overrides. Preserve existing settings, prevent competing copies of `script/431030_battle.luabnd.dcx`, and point a single test entry at the verified workspace root using the project's already-working setup. Do not change Steam files.

## Offline A/B/A test after archive verification

Use the existing supported ModEngine2 launch setup, offline with anti-cheat disabled. Do not use the normal anti-cheat-enabled launcher. Game launch was not performed in this session.

1. Record game build, selected entity/map/param evidence, active mod paths, archive hash and other enabled mods. Keep character, equipment, location and terrain constant. Choose a safe reachable stretch; avoid crowds and scripted events. Do not attack, block-hit, stagger or apply effects to the NPC during the test.
2. **A, disabled:** disable only this script override, preserving the existing configuration. Fully restart the game and load/reset the same NPC. Walk into detection range, then melee range. Record detection, approach and normal attack attempts for at least30 seconds. If normal attacks do not occur, the control is invalid.
3. **B, enabled:** close the game, enable only the verified approach-only archive at relative path `script/431030_battle.luabnd.dcx`, then fully restart/reset. Use the exact same NPC and route. Expect walk/guard approach followed by no ordinary melee attacks despite a reachable player, including a short visit inside normal melee range. Stay within aggro range for at least30 seconds. Move away a few meters on flat ground to check renewed approach separately. Record whether it follows, idles, attacks, loses aggro, or hits a timeout.
4. **A again:** close the game, disable only the test entry and restart/reset. Confirm normal attacks return. Repeat the sequence at least once; capture video/timings if possible.

Pass only if the same confirmed NPC reproducibly shows the distinct predicted behavior in B and normal behavior in A. An idle NPC with no prior detection, a different soldier, or a single crash-free launch is not a pass. Unchanged behavior suggests wrong assignment/path/priority or callback not executing; persistent change after disabling suggests another override or incomplete restart. Attacks in B may indicate shared/native behavior or an unexpected script path; stop and document rather than expanding scope. Failure to resume approach can expose the unverified Update/activation lifecycle and should be recorded separately.

## Rollback and remaining work

Close the game, disable only the Experiment002 mod entry (or restore the preserved pre-test configuration), and restart offline. If a user manually copied the file into an existing external mod root, move that test copy out of the root and restore any backed-up prior override; do not delete local files or touch Steam. Recheck A. Original workspace assets remain intact.

Next boundary: interactive repack, fresh archive verification, then user-run offline A/B/A. Compilation/preparation is complete; packaging, actual loading, behavior and milestone acceptance remain pending. No game launch, external deployment/config changes, original edits, commit or push occurred.
