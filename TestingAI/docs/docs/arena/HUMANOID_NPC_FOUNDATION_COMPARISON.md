# Humanoid NPC foundation comparison

Agent 2 research, 2026-10-13. No implementation or runtime test. Existing experiments, arena implementation artifacts, installed ModEngine, game and saves were not modified.

## Recommendation

**REASONABLE INFERENCE:** keep the dedicated Godrick soldier as the immediate navigation/control reference. It has the strongest project evidence and the fewest new dependencies. For the eventual player-like permanent NPC, investigate a **fixed-equipment c0000 map Enemy**, using a normal humanoid NPC template such as Nepheli, with isolated AI configuration. It can share a spirit puppet's character/equipment foundation without being spawned through the spirit-ash manager. Do not begin with the actual Mimic copying lifecycle.

This is a proposed future direction, not a change to DEC-003 or acceptance of a new foundation. A c0000 actor's independent custom-Lua activation is a proof-of-concept gate. It is not established merely by finding a human Enemy part, a ThinkParam name, or a shared player-NPC Lua file.

Read alongside [arena architecture](ARENA_ARCHITECTURE.md), [arena feasibility](PLACIDUSAX_ARENA_FEASIBILITY.md), [Godrick analysis](../analysis/GODRICK_SOLDIER_AI.md), [configuration reference](../api/humanoid-npc-configuration.md), and [event/AI bridge](../api/event-ai-communication.md).

## Evidence conventions and scope

- **VERIFIED FROM SOURCE:** a declaration, identifier, map reference or code path is directly present in the cited source. It does not certify this installation or runtime behavior.
- **REASONABLE INFERENCE:** design/reuse proposal supported by those sources.
- **UNVERIFIED — REQUIRES IN-GAME TESTING:** behavior requiring a game test; missing row-level data must first be inspected locally.

Experiments 002/003 are user-reported in-game successes on the existing soldier, including unwanted post-arrival movement. The separately prepared 003B remains Agent 1's work. No new runtime result is recorded here. Targeted local inventory found no accessible regulation/parameter-row export for these candidates. Paramdex **Names** files identify labels, not row contents or foreign-key relationships. Published game-source versions are unspecified; all candidate rows must be checked against the current build before editing.

### Source ledger

| Key | Primary source |
|---|---|
| V | soulstruct-vanilla commit `e6de1b79370755152f4f89c4a106a2d67c9ae674`: [m18 enums](https://github.com/Grimrukh/soulstruct-vanilla/blob/e6de1b79370755152f4f89c4a106a2d67c9ae674/eldenring/enums/m18_00_00_00_enums.py), [Stormveil enums](https://github.com/Grimrukh/soulstruct-vanilla/blob/e6de1b79370755152f4f89c4a106a2d67c9ae674/eldenring/enums/m10_00_00_00_enums.py), [Nokron enums](https://github.com/Grimrukh/soulstruct-vanilla/blob/e6de1b79370755152f4f89c4a106a2d67c9ae674/eldenring/enums/m12_02_00_00_enums.py), [Nokron events](https://github.com/Grimrukh/soulstruct-vanilla/blob/e6de1b79370755152f4f89c4a106a2d67c9ae674/eldenring/events/m12_02_00_00.evs.py) |
| P | Paramdex commit `ff7245e524329bc3eab00036723d2bd53384cedf`: ER [Buddy names](https://github.com/soulsmods/Paramdex/blob/ff7245e524329bc3eab00036723d2bd53384cedf/ER/Names/BuddyParam.txt), [Npc names](https://github.com/soulsmods/Paramdex/blob/ff7245e524329bc3eab00036723d2bd53384cedf/ER/Names/NpcParam.txt), [Think names](https://github.com/soulsmods/Paramdex/blob/ff7245e524329bc3eab00036723d2bd53384cedf/ER/Names/NpcThinkParam.txt), [CharaInit names](https://github.com/soulsmods/Paramdex/blob/ff7245e524329bc3eab00036723d2bd53384cedf/ER/Names/CharaInitParam.txt), [ER definitions](https://github.com/soulsmods/Paramdex/tree/ff7245e524329bc3eab00036723d2bd53384cedf/ER/Defs) |
| A | EldenRingAI commit `3b3efb00219026dfba4663b9eb1a1afd94c0a68e`: [logic30000](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/030000_logic.dec.lua), [logic31000](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/031000_logic.dec.lua), [common logic](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/common_logic_func.dec.lua), [WhiteGhost battle](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/npc_whiteghost_battle.dec.lua), [goal constants](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/goal_list.dec.lua), [AI constants](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/ai_define.dec.lua) |
| R | [Summon Randomizer implementation](https://github.com/kingborehaha/Elden-Ring-Summon-Randomizer/blob/acc6afd043996f344049059efa36cc5ff8679e93/ER%20Buddy%20Randomizer/MainForm.cs), commit `acc6afd043996f344049059efa36cc5ff8679e93`; author-authored transformations, not a vanilla row dump |
| F | [Smithbox MSBE Enemy fields](https://github.com/vawser/Smithbox/blob/cbd477a8fd6d436b3e011c8548e1de8fd8876918/src/Andre/SoulsFormats/SoulsFormats/Formats/MSB/MSBE/PartsParam.cs), commit `cbd477a8fd6d436b3e011c8548e1de8fd8876918`; [EldenRingHKS README](https://github.com/soulsmods/EldenRingHKS/blob/main/README.md), unpinned, read2026-10-13 |

## Candidate comparison

All identifiers in this table are **VERIFIED FROM SOURCE** as scoped in the evidence column. Unknown mappings are deliberately retained.

| Candidate | Verified identifiers/configuration | AI/Lua evidence | Native lifecycle and standalone evidence | Assessment |
|---|---|---|---|---|
| Duplicated Godrick soldier | V: m18 Enemy `c4311_9007`, EntityID `18000257`, NpcParam/ThinkParam `43114006`, collision `h002100`. Project: battle goal `431030`, logic `10000`; original `431030_battle.lua` registers `GOAL_RoamArmySpearmen431030_Battle` | Existing binder/source and user-tested movement override. Dedicated row/goal remains a proposed registration, not already proven | Ordinary map Enemy; no ash or invasion creation required. Battle callback depends on normal activation; friendly idle activation is not established | Best immediate control reference. c4311 has its own model/animation/combat set; equipping arbitrary player weapons/armor is not a demonstrated extension |
| Fixed humanoid spirit: Nepheli Loux Puppet | P labels: Buddy `25900000`, NpcParam `100000020`, ThinkParam `100000020`, CharaInit `23342`. **Names only: Buddy→row links and selected logic/battle values not verified.** Related non-spirit V template: Stormveil `c0000_9035`, entity `10000730`, NpcParam `523340014`, ThinkParam `523340000`, CharaInit `23340`, collision `h010200` | A provides player-NPC logic30000/31000 and shared WhiteGhost goal `5000`; no inspected parameter row establishes that the Puppet or Stormveil template selects any of them | Buddy schema selects NPC/Think/CharaInit and player-follow/warp policy. Separate c0000 map Enemy exists in V; this supports the character substrate, not ash-independent operation of the puppet's exact configuration | Best player-like candidate **if** used as a fixed-loadout map NPC with dedicated logic, not through the ash lifecycle |
| Mimic Tear spirit / boss | P labels: Buddy `20700000` and `20700001`; NpcParam/ThinkParam `100000010`, CharaInit `26050`, blob Think `133200000`. R actually assigns human rows100000010/init26050 and a blob NPC133201000/Think133200000; these are tool assignments. V boss: m12 `c0000_9010`, entity `12020850`, NpcParam `526100965`, Think `90603100`, CharaInit `24020`, groups `12025850`,`12025116` | V event `12022860` explicitly sets AI param90603100 and copies player data. Its selected logicId/battleGoalID are unknown here; the trailing3100 digits do not prove logic31000. No standalone Mimic battle archive identified | Boss c0000 map Enemy proves a map representation independent of ash spawning, but vanilla initialization is encounter/transformation-driven. Spirit version has Buddy lifecycle in addition to player-copy behavior | Adds copying, initialization order and repeatability concerns without proving better movement control. Defer until dynamic player-loadout cloning is actually needed |

**REASONABLE INFERENCE:** a fixed c0000 map Enemy is the useful middle ground between a soldier and a true Mimic. The human model/equipment system and the summoning mechanism are separate choices. A spectral visual effect or friendly team alone does not make an actor a spirit summon, nor provide persistent independent activation.

## Activation, command competition and combat

### Soldier

**VERIFIED FROM SOURCE:** the existing project changes its battle callbacks; the selected logic remains separate. A's common dispatch reads `battleGoalID`, considers battle/search state, platoon commands and non-battle goals. It also contains home-return and failed-path recovery. **REASONABLE INFERENCE:** a copied dedicated battle goal isolates attack/movement decisions, but does not alone stop idle logic, reactivation or higher-level replacements.

**UNVERIFIED — REQUIRES IN-GAME TESTING:** a nonhostile soldier receiving movement while no hostile target exists; persistent idle activation; movement replacement after a parent goal completes. Disabling AI prevents these commands too. “Does not attack the player” in002/003 is not equivalent to “does not target the player”: their hostility/faction was not changed.

### Fixed spirit / fixed c0000

**VERIFIED FROM SOURCE:** BuddyParam has `npcParamId`, `npcThinkParamId`, `npcPlayerInitParamId`, `pcFollowType` and `disablePCTargetShare`. NpcThinkParam has `isBuddyAI`. NpcParam has team and activation-condition configuration. R makes spirit rows by changing teamType to47, inserting effects295000/296000/297000 and setting isBuddyAI; this is evidence of the author's recipe, not a recommendation to apply those values to a standalone actor.

**VERIFIED FROM SOURCE:** A's `PLAN_SP_EFFECT_BUDDY_DECLARE` is297000. Common logic detects it and selects `_COMMON_SetBuddyBattleActLogic`; that code considers host-player distance, follow type, active range, aggression/no-follow effects, home return and battle state. Logic30000 separately follows/leaves the host or waits when not fighting. Request10 selects POINT_EVENT movement, but first leaves the host when within3metres. Logic31000 follows the host when calm and uses common setup otherwise. These branches can compete with movement even without hostility.

The shared `GOAL_NPC_WhiteGhost_Battle` is5000 and its Lua exists in aicommon. It responds to event requests, player/enemy distance and heal/item/combat choices, with region-related subgoals in some actions. **REASONABLE INFERENCE:** there are Lua-level hooks in player-NPC behavior. **UNVERIFIED — REQUIRES IN-GAME TESTING:** that a chosen c0000 row invokes our custom battle goal reliably while friendly/idle. Do not assume all c0000 combat is implemented in a bespoke Lua file or globally replace shared goal5000.

**VERIFIED FROM SOURCE:** CharaInit has player equipment fields including `equip_Wep_Right`, `equip_Wep_Left`, `equip_Helm`, `equip_Armer`, inventory slots and `npcPlayerThinkId`. F describes Enemy `CharaInitID` as a human inventory/stats reference. HKS sources describe the layer connecting player/AI inputs to character animation/behavior. **REASONABLE INFERENCE:** fixed c0000 offers a more natural player-equipment foundation than c4311. Adding a weapon does not supply correct attack selection, combo timing or animation commands; those need separate native-AI/HKS validation. No action-script edits are proposed for the first test.

### Mimic

**VERIFIED FROM SOURCE:** event12022860 disables AI, waits for encounter activation, sets Think90603100, copies PLAYER data to MimicTear, initializes update/nest state, and later enables AI/health bar. Event12022865 coordinates the blob and human character's appearance. R special-cases Mimic Buddy rows and warns that careless changes cause issues. Neither source establishes a plug-and-play independent friendly Mimic.

**REASONABLE INFERENCE:** copied equipment/character state creates another configuration dependency and reset variable. **UNVERIFIED — REQUIRES IN-GAME TESTING:** precisely which fields the copy overwrites, whether it changes effective AI/team/initialization, and the required order for custom Think/logic assignment. The copy instruction is not possession and does not prove that all player state or live equipment updates are mirrored.

## Independent AI registration

**VERIFIED FROM SOURCE:** MSBE Enemy holds model/NPC/Think/CharaInit references; ER Think schema exposes separate `logicId` and `battleGoalID`; CharaInit also has `npcPlayerThinkId`. A registers table battle callbacks, and project Lua has passed a compatible compile/binder workflow.

**REASONABLE INFERENCE:** duplicate only the chosen actor's configuration rows and use audited unique goal/logic IDs and archive registration. For c0000, inspect both MSB ThinkParamID and CharaInit npcPlayerThinkId before assuming which wins. A dedicated battle goal may require a dedicated logic layer to run commands while friendly/idle. Custom registration includes numeric/name mapping, callback registration and LUAGNL/LUAINFO/binder metadata as present; a filename alone is insufficient.

**UNVERIFIED — REQUIRES IN-GAME TESTING:** new isolated registration for any candidate, c0000 dispatch precedence and idle command scheduling. No new IDs are reserved. Current-build row inspection must record Buddy foreign keys, Think logic/battle/isBuddyAI, CharaInit Think/type/equipment, Npc team/effects/activation condition, and runtime event overrides. Unknown row contents are an implementation gate, not values to guess.

## Smallest proof of concept

**REASONABLE INFERENCE:** validate the player-like alternative before importing it into Placidusax, using a separate disposable override in the already tested m18 navigation area. Leave all existing experiment files unchanged.

1. Read current-build Nepheli fixed-template and Puppet rows; select the non-ash fixed c0000 template if its dispatch is understandable. Record actual equipment and selectors. Stop if row data or compatible editing/registration is unavailable.
2. Place one duplicated c0000 Enemy with a new EntityID, faithful fixed CharaInit/model configuration and correct local collision/draw groups. Isolate NPC/Think/CharaInit rows where changed. Use a sourced nonhostile team configuration; do not copy quest, invasion or summon sign events.
3. Establish that it loads and remains present without summoning, invasion, boss combat or player hostility. Preserve stock animation files. A brief idle hold tests presence; it does not prove custom command dispatch.
4. In a separately registered logic/battle configuration, request only the already supported movement technique to one new fixed Point region3–5metres away. The callback must be activated without hostile player targeting. After arrival hold position for60seconds. No attacks, input bridge, dynamic equipment copy or arbitrary XYZ.
5. Repeat with the player nearby and far/off-route, then unload/reload three times. Pass requires visible approach to the fixed endpoint, no follow/return/warp/dismissal, no attack/player target dependency, custom-goal evidence and unchanged original NPCs. Rollback must restore the exact prior override set.

If friendly idle scheduling cannot be established, record the blocker; do not trigger hostility just to claim independence. Use Godrick as the control to distinguish c0000 activation/registration failures from floor/region problems. This proof-of-concept is proposed only and needs later implementation authorization.

## Dependencies for the arena plan

**REASONABLE INFERENCE:** the existing plan's empty-arena access, boss suppression and navmesh gates stay unchanged. A player-like option adds a c0000 Enemy/model reference, an audited fixed CharaInit row, isolated Npc/Think rows, and verified custom logic/battle registration. Typical overrides remain MSB, regulation and script binders, with EMEVD only for necessary activation/reset. No BuddyParam/ash item/summoning-area edits are needed for the proposed **map-NPC** design; whether this works is the experiment hypothesis.

Do not place the actual quest actor or copy its EntityID/group/talk events. Do not reuse the actual Puppet or Mimic rows globally. Keep original soldier alongside as a separately selectable control, not as another simultaneous combat actor. Do not transfer m18 collision references to m13. An actor change does not resolve the arena's missing navigation evidence.

## Unresolved runtime questions

All are **UNVERIFIED — REQUIRES IN-GAME TESTING**, after row/source prerequisites:

- Which Think selector is effective for fixed c0000: MSB, CharaInit or event assignment? Does changing one reinitialize the actor?
- Can a nonhostile c0000 dispatch its dedicated movement logic/battle while idle, with no enemy target?
- Can this registration remain entirely local, without aicommon-wide replacements?
- Does absence of Buddy flags/effects prevent following/dismissal, or also remove needed initialization?
- Are native follow, leash, failed-path recovery, perception or event requests able to replace the parent goal?
- Does it stay active with the observing player off-route and across unload/reload/death/reset?
- Can later command replacement cancel current navigation cleanly? Source-backed request paths are not a tested transport.
- Do selected weapons/armor load correctly and native AI execute their actions? Player-like appearance is not combat equivalence.
- For a later Mimic experiment, what exactly is copied and which assignments must follow copying?
- Does either humanoid route navigate the elevated Placidusax floor? Current actor choice cannot certify this.

**Decision boundary:** no permanent NPC foundation is runtime-approved by this research. Immediate recommendation remains dedicated Godrick; best next player-like experiment is a fixed c0000 map NPC; actual Mimic is deferred.
