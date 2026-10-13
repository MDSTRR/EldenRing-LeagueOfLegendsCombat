# Manual extraction — Godrick Soldier AI

## Handoff004 completion update

The initial battle extraction/decompilation is now user-completed: battleGoalID431030 reported; `TestingAI/decompiled/431030_battle.lua` and the corresponding archive/manifest exist and were read. Logic10000 and aicommon archives also exist, but their readable implementations are still missing. Previous tool/extraction observations below are historical, not current blockers for the completed battle analysis. See [analysis](analysis/GODRICK_SOLDIER_AI.md). Next extraction priority is shared helper/goal/registration evidence, not repeating the battle extraction. Installed build/tool provenance and compiler/repack method still require verification. Git ignore rules were preserved in Handoff004.

Prepared 2026-10-13. Research/preparation only. Codex has not accessed the installation, extracted assets, or changed gameplay. `TestingAI/extracted/` remains read-only to Codex; the following steps are for the user to perform. Evidence and resource table: [RESEARCH.md](../agent/RESEARCH.md#handoff-003--godrick-soldier-resource-trace).

## 1. Record the missing AI selection

In your existing Smithbox project, open Stranded Graveyard (`m18_00_00_00`), select `c4311_9007`, and confirm entity 18000257 and ThinkParamID 43114006. Open NpcThinkParam row 43114006 and record both `logicId` and `battleGoalID`. Do not save edits. Record the installed game version and whether this project uses vanilla or modded data. Keep the tutorial-boss identity unresolved until checked.

## 2. Prepare a private extraction folder

Use `TestingAI/extracted/` under this repository. Keep separate folders for untouched archive copies, unpacked binders, and decompiled text. Preserve internal relative paths such as `script/`.

The current root `.gitignore` has `/extracted/`, which does **not** cover `TestingAI/extracted/`. Before copying assets, add `/TestingAI/extracted/` to the root ignore file yourself and verify that `git check-ignore -v -- TestingAI/extracted/example.lua` reports a match. Ignore rules do not untrack already tracked files; none were found under this extraction directory during research. Do not stage assets or compiled/decompiled game scripts.

## 3. Locate the archives manually

In Steam, use Elden Ring's Manage > Browse local files, then find the directory containing `eldenring.exe`. Codex has not inspected this location. If you already have loose `script` files from an unpack, copy only:

- `script/010000_logic.luabnd.dcx`
- `script/aicommon.luabnd.dcx`
- The actual `script/<battle goal ID>_battle.luabnd.dcx` corresponding to the recorded battleGoalID. Angle brackets denote an unknown value; do not type them as a filename. Confirm the exact spelling/padding in the file list.
- A vanilla `regulation.bin` copy or an exported NpcThinkParam row 43114006 showing both selectors.

The workspace already contains `TestingAI/map/MapStudio/m18_00_00_00.msb.dcx` and `TestingAI/regulation.bin`; their contents/provenance have not been independently verified. Keep them intact. Supply a clean source copy only if needed to establish provenance.

If loose scripts are absent, use [Nuxe](https://github.com/JKAnderson/Nuxe), as recommended by the local WitchyBND README. Nuxe was not found in the inspected workspace tools; obtain an official release manually if required. Use **Advanced > Unpack**, choose Elden Ring (PC) and your Game Directory, enable **Unpack to separate directory**, and choose a new private output folder. Leave overwrite off. Enable the regex filter and use the following first-pass filter:

```text
(?i)(010000_logic|aicommon)\.luabnd\.dcx$
```

After learning battleGoalID, make a second filtered pass for that exact archive, or use `(?i)\.luabnd\.dcx$` to obtain all AI binders when the name cannot be resolved. Inspect output names before copying the relevant ones into the workspace. Do not use Patch, Restore, or Decrypt: they are unnecessary for this task and may write to installation files. Separate output is mandatory here. Nuxe's [actual UI source](https://github.com/JKAnderson/Nuxe/blob/main/Nuxe/Views/MainWindow.xaml) confirms these controls; labels can differ with release version. Stop if the release lacks separate-output support or the filter yields no expected files.

## 4. Unpack copied binders

A `.luabnd.dcx` is a compressed container, not readable Lua. Work on a second copy in your unpacked area. Drag the **file** onto `TestingAI/tools/WitchyBND-3.0.1.0-win-x64/WitchyBND.exe`. Keep its output folder, manifest and all metadata. Follow created folders to the `.lua` entries. Do not drag an unpacked folder back onto Witchy: that is its repack operation, which this task does not need.

If Witchy reports a decompression/dependency error, save the exact error and stop; do not substitute random DLLs. Configure only dependencies requested by the installed tool's documentation. Successful DCX decompression alone is not complete binder extraction.

## 5. Decompile only relevant Lua entries

Extracted `.lua` files may still be binary bytecode. DSLuaDecompiler turns those bytes into inspectable text. The current workspace has its source solution, but no executable was found. Build that solution manually with a compatible Visual Studio/.NET toolchain or supply a compatible trusted build; record its version. No build was performed by Codex.

Witchy supports a separately configured LUA/HKS deferred tool and a DSLuaDecompiler preset. Point that configuration at the real built executable, then explicitly process the relevant `.lua` file; its README says deferred formats are not automatically processed during recursive unpacking. Alternatively, use the built executable directly with explicit input and output:

```text
DSLuaDecompiler.exe "FULL_PATH_TO_EXTRACTED_LUA" --output "FULL_PATH_TO_SEPARATE_OUTPUT.dec.lua"
```

These placeholders are paths you must replace. The exact `--output` option is confirmed in local `DSLuaDecompiler/Program.cs`; the command has not been executed here. Never overwrite the input bytecode. Keep decompiled game text private and excluded from Git.

## 6. Confirm success and provide the trace

- Archive copies and extracted entries are nonempty; Witchy produces no unexplained errors and a binder manifest is retained.
- Decompiler output is readable Lua, with no reported unsupported opcode or decompilation failure. Readability alone does not prove semantic accuracy.
- Locate the logic entry associated with 10000; compare registration/metadata with the public `common10000_Logic` example rather than assuming a match.
- Locate the actual battle script selected by battleGoalID. Record its exact filename and goal registration.
- In aicommon, locate `goal_list.lua`, common setup/helper definitions and any movement-goal implementation actually present. Do not assume every common goal is supplied as Lua.
- Search relevant scripts for `AddSubGoal`, `AddTopGoal`, `GOAL_COMMON_MoveToSomewhere`, `GOAL_COMMON_MoveFollowPathSpecifyPos` and helper names called by the logic. Report filenames and relevant locations; absence in one file does not mean the engine lacks a goal.

Provide the battleGoalID value, untouched binders/metadata and relevant readable outputs inside `TestingAI/extracted/`, plus the tool/version/error notes. Stop before repacking or installing a mod. Once those resources are supplied, the next assignment can inspect them and choose a safe isolated fixed-destination test.
