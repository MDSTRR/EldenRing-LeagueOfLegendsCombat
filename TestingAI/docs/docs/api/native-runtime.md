# Native runtime NPC access

Consolidated 2026-10-13. Research reference only; no native code implemented or tested. [API index](INDEX.md) | [Architecture and experiment sequence](../analysis/NATIVE_LUA_NAVIGATION.md)

## Verification conventions

- **VERIFIED FROM SOURCE:** the named implementation, declaration or call site exists in the cited revision. This does not establish behavior on the installed game build.
- **REASONABLE INFERENCE:** an interpretation or proposed reuse of those mechanisms that requires validation.
- **UNVERIFIED:** engine semantics, current-build compatibility, lifetime/thread guarantees or integration not established by the evidence.

Full investigation: [Open Enemy Control source analysis](<../../../../../Research Open Enemy Control/er_enemy_control/analysis.md>). The linked report is outside this repository; it requires the sibling research checkout. This page records reusable access mechanisms and limits rather than duplicating the full F1 trace.

## Open Enemy Control source baseline

Repository: [AlpinDale/er_enemy_control](https://github.com/AlpinDale/er_enemy_control/tree/8056f10c0864e3e10d6c20cc85827676fac36ab4), commit `8056f10c0864e3e10d6c20cc85827676fac36ab4`. The first investigation checked seven local core files against their committed Git blob identities. Game-build support is **UNVERIFIED**: the reviewed source/README specifies no validated executable hash or supported-build matrix.

### Initialization and address acquisition

**VERIFIED FROM SOURCE:** `DllMain` starts `mod_thread`; it loads configuration, calls `resolve_addresses` once, then polls `tick` with a 10 ms sleep. No engine-update detour or input interception hook is installed in this path. Source: [`src/dllmain.cpp:1364–1396`](https://github.com/AlpinDale/er_enemy_control/blob/8056f10c0864e3e10d6c20cc85827676fac36ab4/src/dllmain.cpp#L1364-L1396).

`resolve_addresses()` scans the loaded `eldenring.exe` image for world/player globals and a current-target function. `pattern_scan::find_pattern(base,size,pattern,mask)` returns the first matching address; `pattern_scan::resolve_rel32(instr,offset,instr_len)` resolves a relative reference. **VERIFIED FROM SOURCE:** [`dllmain.cpp:789–840`](https://github.com/AlpinDale/er_enemy_control/blob/8056f10c0864e3e10d6c20cc85827676fac36ab4/src/dllmain.cpp#L789-L840), [`src/pattern_scan.cpp:7–42`](https://github.com/AlpinDale/er_enemy_control/blob/8056f10c0864e3e10d6c20cc85827676fac36ab4/src/pattern_scan.cpp#L7-L42). The third signature match itself becomes the callable target-function address; it is not resolved through its embedded relative call.

### NPC selection

Repository wrapper signature:

```text
uintptr_t get_current_target(uintptr_t world_root, uintptr_t actor_mgr)
TargetFn = void* (__fastcall *)(void* world, void* context)
```

**VERIFIED FROM SOURCE:** the wrapper invokes the scanned function with `world_root` and `actor_mgr + 0x6B0`, returning the character pointer. `tick` reaches its actor/controller context through the world pointer, `+0x10EF8`, a further dereference, and `actor_mgr + 0x190`. Sources: [`dllmain.cpp:984–993`](https://github.com/AlpinDale/er_enemy_control/blob/8056f10c0864e3e10d6c20cc85827676fac36ab4/src/dllmain.cpp#L984-L993), [`:1301–1329`](https://github.com/AlpinDale/er_enemy_control/blob/8056f10c0864e3e10d6c20cc85827676fac36ab4/src/dllmain.cpp#L1301-L1329).

Observed usage: `handle_f1` retrieves the current target before possession; debug code requests lock-on if no target is available. **REASONABLE INFERENCE:** this is a current/lock-on target-selection facility. **UNVERIFIED:** the internal engine getter's implementation and thread requirements. The wrapper contains no explicit memory write but calls external engine code.

**VERIFIED FROM SOURCE:** no entity-ID lookup or NPC enumeration interface is implemented by this repository. It does not directly resolve entity `18000257` by that identifier. `chr_ins_quality`/`is_valid_chr_ins` use readable team data, a selector nibble, and a controller-owner relationship, not a generation-checked identity handle. Source: [`dllmain.cpp:378–417`](https://github.com/AlpinDale/er_enemy_control/blob/8056f10c0864e3e10d6c20cc85827676fac36ab4/src/dllmain.cpp#L378-L417). A plausible pointer is insufficient proof of the map/entity/battle-goal identity.

### Loading, unloading and memory access

**VERIFIED FROM SOURCE:** `tick` attempts release when the target becomes missing/invalid or has the source-named death flag. It also returns early on missing world/controller context before this release check. There is no spawn/despawn subscription or map-unload callback, and other paths retain raw pointers. Source: [`dllmain.cpp:1301–1362`](https://github.com/AlpinDale/er_enemy_control/blob/8056f10c0864e3e10d6c20cc85827676fac36ab4/src/dllmain.cpp#L1301-L1362).

`safe_read`/`safe_write` use structured exception handling with MSVC; ordinary read/write helpers perform raw dereferences. **REASONABLE INFERENCE:** an adaptation needs current-build layout validation, safe acquisition/reacquisition, object identity/generation checks and appropriate engine-thread scheduling. Exception handling and a readable allocation do not establish object lifetime. Source: [`dllmain.cpp:300–434`](https://github.com/AlpinDale/er_enemy_control/blob/8056f10c0864e3e10d6c20cc85827676fac36ab4/src/dllmain.cpp#L300-L434).

## Possession implementation and limits

**VERIFIED FROM SOURCE:** F1 polling invokes `handle_f1`, which retrieves an existing target, links it into player-control structures, applies optional team/player/HP changes, sets control flags and records active pointers. It does not create a replacement NPC or overwrite the main-player pointer in this path. Exact functions: `handle_f1`, `link_target`, `set_control_flags`, `apply_team_override_config`, `apply_player_control_override`, `start_hp_sync`. Source anchors are in the [original F1 trace](<../../../../../Research Open Enemy Control/er_enemy_control/analysis.md#complete-f1-execution-path>).

`link_target` writes the target at `player_root + 0xB8` and a back-link through `(target + 0x58) + 0x3B0`, with an additional `link_a + 0xA8` write. `set_control_flags` changes manager/controller flags and actor state 5/0. **VERIFIED FROM SOURCE:** [`dllmain.cpp:842–926`](https://github.com/AlpinDale/er_enemy_control/blob/8056f10c0864e3e10d6c20cc85827676fac36ab4/src/dllmain.cpp#L842-L926). **REASONABLE INFERENCE:** these relationships redirect ordinary game control. **UNVERIFIED:** whether NPC Lua execution is suspended, continues with its output bypassed, or participates in another arbitration mode. No particular flag is established as an AI-disable bit.

**VERIFIED FROM SOURCE:** `sync_position` copies the linked NPC position into the original player's transform, with Y offset -0.875; `align_player_to_target` removes that offset on release. This is player following, not an NPC navigation command. Source: [`dllmain.cpp:928–982`](https://github.com/AlpinDale/er_enemy_control/blob/8056f10c0864e3e10d6c20cc85827676fac36ab4/src/dllmain.cpp#L928-L982).

The source implements F1–F4 polling, but no mouse hit test, click-to-world conversion, autonomous destination steering, AI goal submission or native-to-Lua command bridge. **VERIFIED FROM SOURCE** within the reviewed implementation. Full absence/search scope and engine-source gaps are documented in the linked investigation; this is not a claim that the game lacks those capabilities.

## Smallest proposed access subset

**REASONABLE INFERENCE:** extract `pattern_scan.h/.cpp`, the world/current-target signatures and image discovery, safe pointer acquisition, adapted identity validation, `get_current_target`, logging and controlled initialization/teardown. Remove the player-signature prerequisite if the new resolver needs only the world/current-target path. Do not adopt possession links, control flags, team overrides, HP mirroring or player position sync. No AI destination setter is included in this subset.

**VERIFIED FROM SOURCE:** [`CMakeLists.txt:1–45`](https://github.com/AlpinDale/er_enemy_control/blob/8056f10c0864e3e10d6c20cc85827676fac36ab4/CMakeLists.txt#L1-L45) builds the DLL from `dllmain.cpp` and `pattern_scan.cpp`, using C++20 and Windows APIs without a declared external possession library. The bundled launcher injects through a remote `LoadLibraryA` thread; it does not initialize ModEngine 2. Sources: [`src/launcher.cpp:216–274`](https://github.com/AlpinDale/er_enemy_control/blob/8056f10c0864e3e10d6c20cc85827676fac36ab4/src/launcher.cpp#L216-L274), [`:278–378`](https://github.com/AlpinDale/er_enemy_control/blob/8056f10c0864e3e10d6c20cc85827676fac36ab4/src/launcher.cpp#L278-L378).

**REASONABLE INFERENCE:** an existing DLL loader could initialize a selectively adapted DLL. **UNVERIFIED:** compatibility with the installed loader/build, other mods, Lua goals, or worker-thread calls. No configuration change is proposed as part of this documentation task.

## Reuse decision

**ADAPT SELECTIVELY** is the research recommendation, not an approved implementation change. The repository contains [Apache License 2.0](https://github.com/AlpinDale/er_enemy_control/blob/8056f10c0864e3e10d6c20cc85827676fac36ab4/LICENSE#L89-L128); copying/distributing code must preserve its actual license and applicable notices. Current-build compatibility and the native destination bridge remain separate gates. See [event/AI communication](event-ai-communication.md).
