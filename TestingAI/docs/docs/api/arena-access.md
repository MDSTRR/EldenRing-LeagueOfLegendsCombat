# Arena access event instructions

Research-only, 2026-10-13. [Index](INDEX.md) | [Arena evidence](../arena/PLACIDUSAX_ARENA_FEASIBILITY.md). These are DarkScript3 ER EMEVD declarations, not Lua AI functions, C++ exports, or native hook signatures. No local runtime verification.

## WarpPlayer

**VERIFIED FROM SOURCE:** ER EMEDF instruction `2003[14]`:

```text
WarpPlayer(byte areaId, byte blockId, byte regionId, byte indexId,
           uint initialAreaEntityId, int subareaNamePopupMessageId)
```

Source: [official ER EMEDF declaration](https://soulsmods.github.io/emedf/er-emedf.html#WarpPlayer), retrieved2026-10-13. No default values are shown. The first four fields identify the destination map; `initialAreaEntityId` identifies its initial-area destination entity; the final field is a subarea popup message ID. No raw XYZ arguments. `regionId` here is a component of the map ID, not an MSB region EntityID.

Purpose: player map warp. Usage evidence: EMEDF lists vanilla callers including common/common_func and several map event files. Proposed arena use would select map components13/0/0/0 and a verified existing Player start, e.g. published `13000981`, **after** checking current-build source and all arguments. This is a parameter mapping, not an executable six-argument example: no popup ID/default is invented. Soulstruct wrappers use a different surface syntax; do not mix it with this declaration.

**UNVERIFIED — REQUIRES IN-GAME TESTING:** destination acceptance on this build, arena streaming, respawn behavior, interaction/reset guards and safe repeatable entry. A generic Other/Point AI destination is not proven interchangeable with a Player start. Published native Placidusax entry instead uses a cutscene-to-region instruction in event13002834; its region IDs do not prove WarpPlayer compatibility.

## SetPlayerRespawnPoint

**VERIFIED FROM SOURCE:** ER EMEDF instruction `2003[23]`:

```text
SetPlayerRespawnPoint(uint respawnAreaEntityId)
```

Source: [official ER EMEDF declaration](https://soulsmods.github.io/emedf/er-emedf.html#SetPlayerRespawnPoint), retrieved2026-10-13. One respawn-area EntityID, no documented default. Purpose: set player respawn destination; it does not request an immediate move. Usage evidence: EMEDF lists callers including common and m18_00_00_00. No arena-specific usage is established or recommended initially.

**UNVERIFIED — REQUIRES IN-GAME TESTING:** persistence, exact destination requirements, interaction with grace/death state and restoration. Keep entry/return warps distinct from modifying respawn state. No test-save edits were performed.

Related: [region assignment/event AI communication](event-ai-communication.md), [AI point targets](ai-targets.md#point-targets). Player warp destinations and NPC movement destinations use separate mechanisms and must be validated separately.
