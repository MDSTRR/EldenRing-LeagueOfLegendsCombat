# Humanoid NPC and summon configuration

Research-only reference, 2026-10-13. [Index](INDEX.md) | [Candidate comparison and proposed test](../arena/HUMANOID_NPC_FOUNDATION_COMPARISON.md). **VERIFIED FROM SOURCE** below identifies declarations or code, not current-build/runtime certification. Schema types are not runtime call signatures. Name tables do not establish row links or values.

## Configuration fields

Source: Paramdex commit `ff7245e524329bc3eab00036723d2bd53384cedf`, ER definitions [BuddyParam](https://github.com/soulsmods/Paramdex/blob/ff7245e524329bc3eab00036723d2bd53384cedf/ER/Defs/BuddyParam.xml), [NpcThinkParam](https://github.com/soulsmods/Paramdex/blob/ff7245e524329bc3eab00036723d2bd53384cedf/ER/Defs/NpcThinkParam.xml), [CharaInitParam](https://github.com/soulsmods/Paramdex/blob/ff7245e524329bc3eab00036723d2bd53384cedf/ER/Defs/CharaInitParam.xml), [NpcParam](https://github.com/soulsmods/Paramdex/blob/ff7245e524329bc3eab00036723d2bd53384cedf/ER/Defs/NpcParam.xml). Game build unspecified.

All field declarations/purposes are **VERIFIED FROM SOURCE**; chosen candidate row values/precedence are unverified unless explicitly identified in the comparison.

| Exact field | Schema type | Purpose / limit |
|---|---|---|
| BuddyParam.npcParamId | s32 | Summoned buddy's NpcParam selector |
| BuddyParam.npcThinkParamId | s32 | Summoned buddy's AI selector |
| BuddyParam.npcPlayerInitParamId | s32 | Archetype initialization selector; human candidate's actual link must be read |
| BuddyParam.triggerSpEffectId | s32 | Summon-condition effect selector |
| BuddyParam.pcFollowType | u8 | Player follow/warp type; enum BUDDY_PC_FOLLOW_TYPE, not an arbitrary movement command |
| BuddyParam.disablePCTargetShare | u8 | Whether player-target sharing is skipped; enum BOOL_CIRCLECROSS_TYPE |
| NpcThinkParam.isBuddyAI | u8 | Whether thinking is for a buddy; not proof that a standalone actor will work |
| CharaInitParam.npcPlayerThinkId | s32 | NPC player's ThinkParam; schema says unused for normal player |
| CharaInitParam.npcPlayerType | u8 | NPC player type; enum NPC_TYPE; not the same field as NpcParam.teamType |
| CharaInitParam.equip_Wep_Right, equip_Wep_Left | s32 | Fixed weapon selectors; do not imply attack-selection support |
| CharaInitParam.equip_Helm, equip_Armer | s32 | Fixed armor selectors; retain the source's spelling |
| NpcParam.teamType | u8 | Attack hit/target relationships; team and battle activation must be tested separately |
| NpcParam.chrActivateConditionParamId | u32 | Character appearance/activation-condition configuration; schema enum CHR_ACTIVATE_CONDITION_TYPE |

No selected defaults are supplied. Related existing entries: [logicId/battleGoalID](ai-resources.md). [Smithbox Enemy fields](https://github.com/vawser/Smithbox/blob/cbd477a8fd6d436b3e011c8548e1de8fd8876918/src/Andre/SoulsFormats/SoulsFormats/Formats/MSB/MSBE/PartsParam.cs) include `ThinkParamID`, `NPCParamID`, `CharaInitID`; their relationship to runtime player-NPC selectors requires testing.

Usage evidence: [Summon Randomizer author code](https://github.com/kingborehaha/Elden-Ring-Summon-Randomizer/blob/acc6afd043996f344049059efa36cc5ff8679e93/ER%20Buddy%20Randomizer/MainForm.cs) assigns Buddy NPC/Think/init selectors and sets isBuddyAI while constructing spirit rows. These are the author's mod assignments, not vanilla defaults or a standalone actor recipe.

## npc30000_Logic and npc31000_Logic

Exact Lua entry signatures: `npc30000_Logic(arg0)`, `npc30000_Interupt(arg0, arg1)`, `npc31000_Logic(arg0)`, `npc31000_Interupt(arg0, arg1)`. The `Interupt` spelling is from the source. Logic arg0 is the AI object; interrupt arg1 is the goal context. No defaults are declared. These are source-defined entry callbacks, not engine exports.

**VERIFIED FROM SOURCE:** [030000_logic](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/030000_logic.dec.lua) reads request slots0/1 and the Think battleGoalID. Request10 can approach POINT_EVENT but first leaves TARGET_HOSTPLAYER when within3metres; ordinary branches follow, wait, leave or dispatch the selected battle goal. [031000_logic](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/031000_logic.dec.lua) handles requests100/110/80, follows/waits near host while calm, and otherwise delegates to common setup. Both interrupt callbacks return false. Purpose: player-NPC-style logic dispatch. Source build unspecified.

**UNVERIFIED — REQUIRES IN-GAME TESTING:** selected logic for Nepheli Puppet, Mimic spirit or their related map templates; idle command responsiveness and replacing these callbacks locally. Do not infer row selection from a name or trailing ID digits. Related: [event requests](event-ai-communication.md#geteventrequest-and-interupt_eventrequest), [POINT_EVENT](ai-targets.md#point-targets).

## GOAL_NPC_WhiteGhost_Battle and PLAN_SP_EFFECT_BUDDY_DECLARE

**VERIFIED FROM SOURCE:** constants `GOAL_NPC_WhiteGhost_Battle = 5000` in [goal_list](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/goal_list.dec.lua), and `PLAN_SP_EFFECT_BUDDY_DECLARE = 297000` in [ai_define](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/ai_define.dec.lua). Constants have no function parameters/defaults.

Usage: [npc_whiteghost_battle](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/npc_whiteghost_battle.dec.lua) registers5000 through the existing table-goal mechanism, with `Goal.Activate(arg0, arg1, arg2)` and source actions driven by requests/distances. [Common logic](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/common_logic_func.dec.lua) checks effect297000 to choose buddy dispatch. These shared behaviors can compete with custom movement. The effect is not a destination setter; the goal is not certified as the selected battle goal of any candidate row reviewed here. Do not edit either globally for one test actor.

## CopyPlayerCharacterData and SetAIParamID

**VERIFIED FROM SOURCE:** Soulstruct wrapper declarations at commit `12b69189a2ccebbc623a1b6565be89a18d6c9958`, [instructions.pyi](https://github.com/Grimrukh/soulstruct/blob/12b69189a2ccebbc623a1b6565be89a18d6c9958/src/soulstruct/eldenring/events/instructions.pyi):

```text
CopyPlayerCharacterData(source_character: Character | int,
                       dest_character: Character | int, event_layers=())
SetAIParamID(character: Character | int, ai_param_id: int, event_layers=())
```

First wrapper maps to EMEVD2004[67], source/destination character references and optional compiler event layers. Exact copied fields are not enumerated by the declaration. Second maps to2004[19], character and AI parameter ID. DarkScript3 names the second instruction `SetCharacterAIId(uint entityId, int aiId)` in [ER EMEDF](https://soulsmods.github.io/emedf/er-emedf.html#SetCharacterAIId); wrapper syntax is distinct from instruction syntax. Neither is a Lua AI function or native ABI.

Usage evidence: pinned [vanilla Nokron event12022860](https://github.com/Grimrukh/soulstruct-vanilla/blob/e6de1b79370755152f4f89c4a106a2d67c9ae674/eldenring/events/m12_02_00_00.evs.py) calls `SetAIParamID(Characters.MimicTear, ai_param_id=90603100)` followed by `CopyPlayerCharacterData(source_character=PLAYER, dest_character=Characters.MimicTear)` in its encounter setup. Purpose: configure AI and initialize a character from another character's data.

**UNVERIFIED — REQUIRES IN-GAME TESTING:** current-build copy contents, AI/team overwrite, initialization order, friendly standalone use, continuous loadout mirroring or command dispatch. A copy operation does not imply possession. No runtime calls or save changes were made.
