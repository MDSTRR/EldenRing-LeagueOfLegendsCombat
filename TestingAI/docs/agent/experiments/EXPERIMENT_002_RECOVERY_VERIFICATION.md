# Experiment002 recovery verification

2026-10-13. **PASS — existing archive's static integrity and intended approach-only changes.** Original-path verification still fails; provenance has been reconciled without changing expected hashes. In-game loading/behavior remain unverified. No rebuilding, staging, deployment, game launch or Git mutation performed.

## Reference discrepancy

The restored decompiled source is 41286 bytes with1044 CRLF endings. Converting **only CRLF to LF in memory**, without changing Lua text, produces40242 bytes and the exact expected hash:

- Current raw: `08D41B88A25C742B4426D0FFE55245F36B79E72E8798DFBAB013B564B8A03C8D`.
- LF bytes: `BB170E62F3D24AEFC5CC1B900BD05EB30B9433C2265C7C0404457EFC34A072A4`.
- Raw Git source blob from backup commit `5043ed2bbf060d531b6d69d838ef93095eb0fb2b` matches the expected LF hash and normalized current text exactly.

This establishes a line-ending-only discrepancy, not a lost semantic source revision or evidence of regeneration. `core.autocrlf=true` is consistent with checkout conversion, although the precise historical restoration command was not observed. The old manifest correctly recorded its original raw bytes; assuming those bytes and paths survive a later restore is no longer valid.

All five reference paths were checked, including those masked by the script's first exception:

| Reference | Current original path | Trustworthy reconciliation |
|---|---|---|
| Decompiled source | Present, raw hash differs | Backup Git blob exactly matches expected hash; LF-only normalization proves current text equivalence |
| Original Lua bytecode | Missing | Backup Git blob exactly matches `B12260E8…C9C55`; surviving baseline entry also matches |
| Original LUAGNL | Missing | Backup Git blob exactly matches `2A00F443…DD8CC`; baseline/new archive entries also match |
| Original Witchy XML | Missing | Surviving Experiment001 binder-folder XML exactly matches `319BB705…676F`; Experiment002 copy also matches |
| Original packed archive | Missing | Backup Git blob exactly matches `E17D7A65…28B3` |

Backup XML blob hash `87476743…1F40F` is its LF form: normalizing the exact surviving XML copy to LF reproduces that hash. Its differing raw hash was recorded, not substituted for the manifest's expected hash. All five **exact expected reference byte sequences** were recovered into a new evidence directory; none were restored over existing workspace files.

## Independent artifact verification

- Existing archive: `TestingAI/build/experiment002/approach-only/431030_battle.luabnd.dcx`, **7728 bytes**, SHA256 `71D1B924524B4811A3CFFC62B0DA516CAF253687443A7B7D69A03AAB17644A17`.
- Lua entry1000:46777 bytes, SHA256 `5DDE5015307C7844D98B2E5C27F84665A24B969221F36A82BDE41188E39AB660`, exactly the existing preparation manifest's expected compiled hash.
- LUAGNL entry1000000:1504 bytes, exact original hash `2A00F44377EB2DE66364FD08FE53E7048ED6F5BC9C9D4C59A5EEC2B8142DD8CC`.
- Exactly two entries, full embedded names, `Flag1` flags and per-entry `Zlib` compression match recovered original and unchanged-bytecode baseline. Both baseline payloads match original. Baseline archive hash matches historical `DE1DED63…D22B1`.
- Binder version `07D7R6`, format `IDs, Names1, Names2, Compression`, endian flagsfalse, Unicode true, Extended4, Unk04/05false and outer `DCX_KRAK` match both reference archives. DCX header explicitly identifies KRAK/level6.
- Lua5.0 header matches original. Parsed27 functions; only traversal indices2/main Activate and24/main Interrupt differ in instructions/constants/executable shape. Other25 functions match original.
- Prepared source still matches its recorded hash `666D2258A50707E8697737DDA9B1B6B8413A5A7AC3106B9A5699E5CE37F80A89`. Independently reconstructing only the two reviewed callback substitutions from recovered original source reproduces the prepared source exactly. Raw source text embedded in compiled debug metadata also matches it exactly.
- Callback disassembly confirms observer cleanup, `ClearSubGoal`, and one `AddSubGoal(ApproachTarget,10,TARGET_ENE_0,3,TARGET_SELF,true,9910)` call; Interrupt loadsfalse and returns it. No attack request occurs in either modified callback. Remaining attack helpers are unchanged and still defined. Shared/native behavior remains outside this check.

Archive size/hash differ from Experiment001 because executable callbacks and source/debug data changed. LUAGNL, entry identity and binder configuration did not. This is expected static evidence; no runtime compatibility conclusion follows.

## Revised verification method and safest next step

Leave `preparation-verification.json` and `verify-and-stage.ps1` unchanged. The old combined script fails legitimately on changed/missing original paths and throws before writing its final evidence report; it must not be patched by replacing hashes or skipping checks.

Use a separate, non-staging verifier with a provenance ledger: record raw current-path failures, bind recovered candidates to the exact original expected hashes, identify backup commit/candidate paths and line-ending evidence, verify the known baseline hash, then independently compare archive/payload/metadata/source/callbacks. Keep **original paths intact = false** separate from **reconciled artifact integrity = PASS**. Any future staging gate should require that reconciliation plus all existing artifact checks and pin the verified archive hash; it must not silently accept arbitrary current files.

This method was executed by new `TestingAI/build/experiment002/verify-recovery.ps1`. Evidence and recovered references are in `TestingAI/build/experiment002/recovery-20261013-213506-9256335/`, including `recovery-verification.json`, `callback-disassembly.json`, `references/` and extracted `archive-entries/`. Existing manifest, verifier, preparation script, source, compiled bytecode/archive, baseline and binder copies were hashed before/after and remained unchanged. Git remained on `0.01`; no branches/history/index changes.

**No reconstruction of gameplay code, recompilation or repack is needed.** Safest next step is a separately authorized staging/configuration review using this exact verified archive and reconciled references, followed by the existing [offline A/B/A plan](EXPERIMENT_002_OBSERVABLE_OVERRIDE.md#offline-ab-a-test-after-archive-verification). Current instruction prohibits deployment/game launch, so verification stops here. Same-NPC assignment, current-build loading, attack suppression under shared reactions, and activation recurrence still require the manual test.
