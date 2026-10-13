# NPC AI resource references

Updated 2026-10-13 through Handoff004. Status: battle text and manifest locally inspected; logic/common definitions not yet decoded. Installed game build unknown. See [index](INDEX.md), [research](../../agent/RESEARCH.md#handoff-004--decompiled-battle-analysis) and [manual extraction guide](../AI_EXTRACTION.md).

## NpcThinkParam.logicId

Exact field: `logicId`, schema declaration `s32 logicId = -1`. This is a configuration field, not a callable function. The schema default is not the selected row's value. Purpose: identify scripted AI logic.

Local sources: `TestingAI/tools/Smithbox_2_2_6_2026_09_20_b/Assets/PARAM/ER/Defs/NpcThinkParam.xml:29` and `Assets/PARAM/ER/Param Annotations/English/NPC_THINK_PARAM_ST.json:23`. External corroboration: [libER generated param definition](https://dasaav-dsv.github.io/libER/d8/df3/NPC__THINK__PARAM__ST_8hpp_source.html).

Usage evidence: the user reports row 43114006 has logicId 10000. Smithbox's ER file dictionary lists `script/010000_logic.luabnd.dcx`; a [public ER-oriented example](https://github.com/mihai1rus/EldenRingCommonAiFuncs/blob/main/010000_logic.lua) defines `common10000_Logic(ai)` and `common10000_Interupt(ai, goal)`. This supports the candidate mapping; actual archive registration/loading remains to inspect. Do not edit shared logic globally merely to change one NPC.

## NpcThinkParam.battleGoalID

Exact field: `battleGoalID`, schema declaration `s32 battleGoalID = -1`. Purpose: battle-goal selection, separate from logicId. No function signature or call parameters apply.

Local sources: the same definition at line 36 and English annotation at line 28. [ER-focused AI tutorial](https://docs.google.com/document/d/e/2PACX-1vTbygMNnCuicYcs6u0ZVFsKV54YzNb4ZvlZiaTCBFVF5TqXWV7N6axiqR--fieMRMtV-ik1FsKuC7q6/pub) demonstrates using this field to select the battle archive, with `script/310000_battle.luabnd.dcx` as its Bell Bearing Hunter example.

Handoff004 reports battleGoalID **431030** for row43114006. `TestingAI/extracted/431030_battle.luabnd.dcx` now exists; its `_witchy-bnd4.xml:3` confirms filename and lines19–25 list Lua/LUAGNL entries. `TestingAI/decompiled/431030_battle.lua:1` registers GOAL_RoamArmySpearmen431030_Battle. Manifest and readable text independently inspected; param-row selector and numeric goal-constant mapping still not independently decoded. Do not equate model, row, logic and battle IDs. See [complete analysis](../analysis/GODRICK_SOLDIER_AI.md).

## common10000_Logic / common10000_Interupt

Exact source signatures: `common10000_Logic(ai)` and `common10000_Interupt(ai, goal)` (retain the spelling `Interupt`). These are Lua functions in the cited [public example](https://github.com/mihai1rus/EldenRingCommonAiFuncs/blob/main/010000_logic.lua), not new engine APIs. Arguments represent AI and goal objects; the source supplies no defaults. It initializes common logic and delegates to common setup, with event-request branches; its interrupt function returns false. Example contents are modder-published/refactored material, not a verified dump of our installed build. Usage is as script entry logic; registration name/metadata must be read from the local archive before relying on it. Related configuration: logicId above.

## Archive relationships

`script/010000_logic.luabnd.dcx` and `script/aicommon.luabnd.dcx` are exact entries in local `Assets/File Dictionaries/ER-File-Dictionary.json`, lines 40989 and 44717, both associated with `data0`. A LUABND is a binder of AI scripts/metadata; DCX wraps compression. The manifest and any LUAINFO/LUAGNL entries should be retained. Do not infer that the model's CHRBND contains its decision scripts. Common helper/goal definitions and goal-name mappings are separate dependencies to inspect in aicommon.

This confirms local reference metadata, not that the current installation's archives match it. `m18_00_00_00` selects map resources; it does not justify importing older-game map-LUABND organization into ER.
