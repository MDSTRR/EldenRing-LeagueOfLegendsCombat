# Runtime event and AI communication

Consolidated 2026-10-13. Research-only API reference. [Index](INDEX.md) | [Native access](native-runtime.md) | [Architectures and experiments](../analysis/NATIVE_LUA_NAVIGATION.md)

**VERIFIED FROM SOURCE** identifies source operations or declarations, **REASONABLE INFERENCE** identifies proposed connections, and **UNVERIFIED** identifies missing integration/runtime evidence. None of the bridge APIs below has been tested on this project's installed game build. Generated C++ declarations and EMEVD parameter lists are not native exports or established C++ calling conventions.

Detailed traces are in the original [bridge analysis](<../../../../../Research Open Enemy Control/er_enemy_control/native-ai-bridge-analysis.md>) and [evidence ledger](<../../../../../Research Open Enemy Control/er_enemy_control/native-ai-bridge-evidence.md>). Those reports remain in the sibling research checkout rather than being copied here.

## Native event-flag writing

### CSFD4VirtualMemoryFlag.SetEventFlag

Observed external wrapper: `void SetEventFlag(uint flag, bool state)` in Nordgaren/Erd-Tools, pinned dependency commit `a2757f930afa3109dc4816d3f04e7cd11b91fea1`. Parameters are a flag ID and on/off state; neither is a destination or NPC EntityID.

**VERIFIED FROM SOURCE:** [`src/Erd-Tools/Models/CSFD4/CSFD4VirtualMemoryFlag.cs:55–65`](https://github.com/Nordgaren/Erd-Tools/blob/a2757f930afa3109dc4816d3f04e7cd11b91fea1/src/Erd-Tools/Models/CSFD4/CSFD4VirtualMemoryFlag.cs#L55-L65) writes four-byte ID storage in the target process, then executes an assembly call. [`Assembly/SetEventFlag.asm:1–9`](https://github.com/Nordgaren/Erd-Tools/blob/a2757f930afa3109dc4816d3f04e7cd11b91fea1/src/Erd-Tools/Assembly/SetEventFlag.asm) uses RCX for the resolved manager, RDX for a pointer to the flag ID and R8B for the state byte. Do not replace the observed pointer argument with a guessed by-value native signature.

`ErdHook` resolves setter/getter signatures and the manager; `Offsets` stores AOB patterns and layout offsets. Sources: [`Hook/ErdHook.cs:120–140`](https://github.com/Nordgaren/Erd-Tools/blob/a2757f930afa3109dc4816d3f04e7cd11b91fea1/src/Erd-Tools/Hook/ErdHook.cs#L120-L140), [`Hook/Offsets.cs:203–206`](https://github.com/Nordgaren/Erd-Tools/blob/a2757f930afa3109dc4816d3f04e7cd11b91fea1/src/Erd-Tools/Hook/Offsets.cs#L203-L206), [`:569–590`](https://github.com/Nordgaren/Erd-Tools/blob/a2757f930afa3109dc4816d3f04e7cd11b91fea1/src/Erd-Tools/Hook/Offsets.cs#L569-L590). **UNVERIFIED:** current-build signature uniqueness, ABI, manager lifetime and thread safety.

The call route assembles through Keystone in [`ErdHook.AsmExecute:258–280`](https://github.com/Nordgaren/Erd-Tools/blob/a2757f930afa3109dc4816d3f04e7cd11b91fea1/src/Erd-Tools/Hook/ErdHook.cs#L258-L280). Its pinned PropertyHook dependency `ca3c4413ed70786570e82b02851715c5d4adb651`, [`PropertyHook/PHook.cs:341–358`](https://github.com/Nordgaren/PropertyHook/blob/ca3c4413ed70786570e82b02851715c5d4adb651/PropertyHook/PHook.cs#L341-L358), executes through a remote thread. **VERIFIED FROM SOURCE:** this is not an established AI-update-thread scheduling mechanism. Usage evidence is the existing tool call, not a proposed executable snippet for our project.

### Direct flag-memory implementation

**VERIFIED FROM SOURCE:** FromSoftware-rs commit `6933967b176332a37e9ce6773f8dcd74b9feaf42` implements `CSFD4VirtualMemoryFlag::set_flag/get_flag` in [`crates/eldenring/src/cs/event_flag.rs:59–84`](https://github.com/vswarte/eldenring-rs/blob/6933967b176332a37e9ce6773f8dcd74b9feaf42/crates/eldenring/src/cs/event_flag.rs#L59-L84), with bit writes at `:121–138`. Flag-group lookup must succeed; a missing group is not allocated by the setter. A false read can represent a missing group. This implementation writes memory rather than calling the engine setter and does not inherently network-set flags.

**UNVERIFIED:** equivalence to engine setter notifications/persistence and safe access from our DLL. A proposed flag must be both non-conflicting and backed by an available group; no ID is certified free here. Flags are global state, so NPC ownership and a fresh-order protocol must be supplied separately. Existing save/event behavior must be preserved during a later disposable experiment.

## IsEventFlag

Documented Lua-facing declaration: `bool IsEventFlag(unsigned int eventFlagId)`. Purpose: read a flag as a boolean. No default shown. It is not a coordinate reader.

**VERIFIED FROM SOURCE:** generated `AiFunc.hpp:1632`, in readable-ds-lua gh-pages commit `4c78203276c9dd5dbaf8b6d769a30d807cd41233` ([header source view](https://eladidu.github.io/readable-ds-lua/d3/d42/_ai_func_8hpp_source.html)); ER battle Lua [`211010_battle.dec.lua:24–30`](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/211010_battle.dec.lua#L24-L30) calls `arg1:IsEventFlag(13002822)` and related IDs. These are observed vanilla-script examples, not IDs to reuse. All ER Lua links here use commit `3b3efb00219026dfba4663b9eb1a1afd94c0a68e`, with unspecified game-build provenance.

**REASONABLE INFERENCE:** a custom battle goal can read a reserved selector flag and choose a destination region. **UNVERIFIED:** combined native-to-Lua visibility, callback cadence and active-goal replacement for entity `18000257`. Reading only at Activate may miss timely mid-movement orders. Related: [SetEventMoveTarget](ai-functions.md#seteventmovetarget), [POINT_EVENT](ai-targets.md#point-targets).

## GetEventRequest and INTERUPT_EventRequest

Documented Lua-facing declarations: `int GetEventRequest(int slot)` and `int GetEventRequest()`; `AiFunc.hpp:764/770` at the pinned reference above. The reference documents slots 0–3 and the no-argument form as slot 0. These are request values, not automatically interpreted as region IDs or coordinates.

**VERIFIED FROM SOURCE:** [`030000_logic.dec.lua:1–19`](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/030000_logic.dec.lua#L1-L19) reads slots 0/1 and selects `POINT_EVENT` movement for request 10, subject to NPC-specific player-distance guards. Do not import the whole logic or assume command 10 is universal.

`INTERUPT_EventRequest` is a constant, not a function: value 39 at [`aicommon/ai_define.dec.lua:161`](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/ai_define.dec.lua#L161). [`table_ai_common.dec.lua:719–731`](https://github.com/zoloypzuo/EldenRingAI/blob/3b3efb00219026dfba4663b9eb1a1afd94c0a68e/aicommon/table_ai_common.dec.lua#L719-L731) dispatches `Interrupt_EventRequest`. **VERIFIED FROM SOURCE:** a shared handler path exists. **UNVERIFIED:** its registration/reception in our custom soldier goal, especially with Experiment 002's interrupt isolation. No native writer to the request slots is mapped here.

## RequestCharacterAICommand

ER EMEVD instruction 2004[17]: `RequestCharacterAICommand(uint entityId, int commandId, byte slotNumber)`. Purpose: supply an AI request for a character; command semantics depend on its logic. Source: [ER EMEDF](https://soulsmods.github.io/emedf/er-emedf.html#RequestCharacterAICommand), retrieved 2026-10-13, not commit-pinned.

**VERIFIED FROM SOURCE:** Soulstruct-vanilla commit `e6de1b79370755152f4f89c4a106a2d67c9ae674`, [`eldenring/events/common_func.py:9941–9978`](https://github.com/Grimrukh/soulstruct-vanilla/blob/e6de1b79370755152f4f89c4a106a2d67c9ae674/eldenring/events/common_func.py#L9941-L9978), `CommonFunc_90005782`, uses the wrapper `AICommand(character, command_id=10, command_slot=0)` and later `-1`. This is event-script usage, not a DLL-callable function or a universally accepted command protocol. Related: [GetEventRequest](#geteventrequest-and-interupt_eventrequest).

## SetEventPoint

ER EMEVD instruction 2004[18]: `SetEventPoint(uint entityId, uint relativeEntityId, float reactionDistance)`. Parameters identify the affected character, an entity-relative destination reference, and a reaction distance; no XYZ arguments. Source: [ER EMEDF](https://soulsmods.github.io/emedf/er-emedf.html#SetEventPoint).

**VERIFIED FROM SOURCE:** `CommonFunc_90005782` uses `SetEventPoint(character, region=region_1, reaction_range=0.0)` at `common_func.py:9961`, alongside AI command/replan calls and a later region-arrival wait. **REASONABLE INFERENCE:** an EMEVD consumer could select between predefined regions after native flag publication. **UNVERIFIED:** precise storage aliasing with Lua `SetEventMoveTarget`, arbitrary entity-type acceptance, cached-path updates, and a native address/handler ABI. Do not infer that `TARGET_EVENT` is `POINT_EVENT`.

## RequestCharacterAIReplan

ER EMEVD instruction 2004[20]: `RequestCharacterAIReplan(uint entityId)`. One character EntityID; no destination parameter. Source: [ER EMEDF](https://soulsmods.github.io/emedf/er-emedf.html#RequestCharacterAIReplan).

**VERIFIED FROM SOURCE:** `CommonFunc_90005782` calls the `ReplanAI(character)` wrapper at `common_func.py:9960/9978`; [`m30_05_00_00.evs.py:948–972`](https://github.com/Grimrukh/soulstruct-vanilla/blob/e6de1b79370755152f4f89c4a106a2d67c9ae674/eldenring/events/m30_05_00_00.evs.py#L948-L972) contains similar command/event-point/replan usage. **UNVERIFIED:** immediate goal cancellation, ordering guarantees, our soldier's response, or DLL-callable entry point. Replan requests must not be equated with demonstrated arrival or path replacement.

## SetCharacterEventTarget

ER EMEVD instruction 2004[11]: `SetCharacterEventTarget(uint entityId, uint entityId2)`, a separate character event-target relationship. **VERIFIED FROM SOURCE:** the [ER EMEDF declaration](https://soulsmods.github.io/emedf/er-emedf.html#SetCharacterEventTarget). **UNVERIFIED:** mapping to the region destination path or a direct movement command for our NPC. It is documented separately to avoid conflating similarly named mechanisms.

## GetNumber and SetNumber

Documented Lua-facing declarations: `float GetNumber(int index)` and `void SetNumber(int index, float value)`, generated `AiFunc.hpp:1067/2660` at the pinned reference. Purpose: AI-local numeric state; the reference describes indices 0–63. **VERIFIED FROM SOURCE:** the second investigation found these names in 126/148 files respectively among 529 published ER Lua files. Those are textual occurrences, not runtime counts.

**UNVERIFIED:** a native state-array address, AI-object layout, setter ABI, safe lifetime or free slots in the soldier. Numeric values do not automatically become a navigation endpoint. Treat an XYZ mailbox here as a proposed architecture, not an established bridge. The same limit applies to string-indexed AI numbers. Full search paths/hashes are retained in the [original evidence ledger](<../../../../../Research Open Enemy Control/er_enemy_control/native-ai-bridge-evidence.md#search-scope-and-reproducibility>).

## Compatibility and reuse boundary

**REASONABLE INFERENCE:** native flag publication followed by Lua region selection is the smallest supported bridge candidate. Current-build engine calls, event-point lookup, active-goal replacement and actual navigation remain **UNVERIFIED**. No API entry marks a project milestone complete.

Inspect actual licenses before copying dependencies: the reviewed Erd-Tools/PropertyHook listings exposed no license file; FromSoftware-rs contains modified MIT/Apache NON-AI licenses. Do not relabel these as ordinary MIT/Apache. Source availability is evidence of a mechanism, not reuse authorization. Detailed licensing/provenance limits and pinned dependencies remain in the original reports.
