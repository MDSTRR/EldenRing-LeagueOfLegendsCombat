# ELDEN RING → LEAGUE OF LEGENDS MOVEMENT & COMBAT
## Personal project notebook, verified progress, architecture, and return-to-work guide

**Snapshot:** 13 October 2026 (updated with the user's successful EXP-003B observation and Agent 2's humanoid NPC research).  
**Audience:** Me, returning to this project after a break.  
**Purpose:** Explain *what I am building, why the experiments exist, what has actually worked, what is still speculation, and exactly how to resume without destroying a known-good baseline.*  
**Read this first:** This is a **project-state snapshot**, not a claim that every local file, deployment, save, or agent report has been independently inspected on my Windows PC. I should confirm my live ModEngine state before running another test.

---

# 0. THE FIVE-MINUTE VERSION

I am modding **Elden Ring** so that a character in the game can eventually be controlled using **League of Legends-style point-and-click movement and combat**. The design intentionally relies on an **AI-controlled NPC as the playable actor**, rather than trying to retrofit the normal player character's movement system. This lets me attempt to reuse FromSoftware's **native NPC pathfinding, animation, collision, and attack machinery**.

**Most important result so far:**

> **EXP-003B worked in-game.** A Godrick soldier walked to a custom map destination, lowered his shield, and stood still instead of wandering. This is the first observed **MOVE → ARRIVE → WAIT** loop.

What this does **not** prove: that the soldier will remain stationary indefinitely, that the same behavior survives all AI interruptions, that he can accept another command while waiting, or that we can move him to an arbitrary XYZ coordinate. A 90-second hold was requested but the user did not explicitly report completing the full timed observation.

**Next project direction:** move out of the Stranded Graveyard test cave and establish a proper **AI laboratory**: a clean arena (Placidusax is the leading candidate), reliable entry/exit, and a **player-like `c0000` humanoid map NPC** with its own AI configuration. Meanwhile, retain the Godrick soldier as a proven control/reference and continue command-navigation experiments separately.

**Two project names:**

- **Project Pathfinder / EXP series** — movement commands, waiting, destination switching, arbitrary-coordinate navigation, eventual mouse input and combat. Agent 1 primarily owns Lua/movement experimentation.
- **Project Crucible / LAB series** — arena, repeatable test environment, and standalone player-like humanoid NPC. Agent 2 primarily owns research/planning; implementation ownership should be assigned explicitly when work begins.

**Immediate next actions after my break:**

1. Confirm the EXP-003B backup/rollback state and preserve its working build/report.
2. Have Agent 1 record the **new user-observed in-game success**; its original report still says runtime pending because it predates the test.
3. Keep EXP-003B as a frozen, reproducible success; do not casually edit its original staged files.
4. Begin **Crucible LAB-001** as an isolated **empty arena + entry/return** prototype, after read-only inspection of current game data and a rollback plan.
5. In parallel, test a fixed-equipment `c0000` NPC **in the already-working m18 area first** before combining a new actor with an unverified arena.

---

# 1. WHAT I AM TRYING TO BUILD

## 1.1 End goal

The intended experience is closer to a MOBA than to ordinary third-person Elden Ring controls:

1. I click on terrain.
2. The game determines a world-space destination.
3. My **AI-driven character** receives a movement order.
4. The existing game navigation system finds a route around obstacles and moves the character.
5. The character stops at the destination and waits for the next command.
6. Clicking an enemy issues a target/attack command; the character approaches to range, attacks, and respects cooldowns or attack timing.
7. Future additions might include attack-move, targeting rules, abilities, UI, and an isometric camera. **Camera work is intentionally deferred.**

The central architectural bet is that **Elden Ring's NPC movement and combat systems can be reused as an engine**. The mod should supply decisions and destinations rather than reimplement low-level walking or pathfinding.

## 1.2 What I am explicitly NOT trying to do yet

- Control the native player actor directly.
- Build a completely new navigation mesh or steering engine.
- Recreate League of Legends' camera or UI.
- Implement multiplayer/network synchronization.
- Solve all weapons, attack animations, and abilities at once.
- Assume a particular NPC is fully controllable merely because it can navigate autonomously.

## 1.3 Conceptual architecture

```text
USER INPUT (later: right click, attack click)
              |
              v
INPUT / COMMAND BRIDGE (not implemented)
              |
              v
NPC COMMAND CONTROLLER (partly conceptual)
    | MOVE(point)  | ATTACK(target) | STOP
    v
CUSTOM AI / LUA GOAL STATE MACHINE
    | MOVING | ARRIVED | WAITING | ATTACKING
    v
ELDEN RING NATIVE GOALS / NAVIGATION / ANIMATION
              |
              v
STANDALONE NPC ACTOR (today: Godrick soldier;
                     future: fixed-equipment c0000 humanoid)
```

**Proven today:** Lua-driven fixed-region navigation and a successful arrival-to-wait transition on one soldier in m18. Everything upstream of a dynamic command bridge and downstream of player-like combat remains future work.

---

# 2. EVIDENCE LABELS: DON'T CONFUSE RESEARCH WITH RESULTS

Use these exact categories in future reports:

- **IN-GAME VERIFIED:** I observed the behavior in an actual Elden Ring session.
- **STATICALLY VERIFIED:** compiled, unpacked/repacked, hash-checked, source-checked, or mocked; does **not** prove runtime behavior.
- **SOURCE-VERIFIED:** identified in a published game-data dump or tooling source; does **not** prove my installed game version has the same fields/IDs.
- **REASONABLE INFERENCE:** technically motivated hypothesis/design, not yet demonstrated.
- **UNVERIFIED:** no suitable evidence yet.

**Important:** An agent's earlier document may correctly say “runtime pending” even after I later test the build. Record the observation in a **new dated addendum**; do not silently rewrite old evidence.

---

# 3. MY PROJECT ENVIRONMENT AND PATHS

## 3.1 Main repository

```text
C:\Users\creep\Desktop\Projects\Elden Ring - LoL\EldenRing-LeagueOfLegendsCombat
```

## 3.2 ModEngine 2

```text
C:\Users\creep\Documents\ModEngine-2.1.0.0-win64
```

Test launcher (in the ModEngine installation):

```text
launchmod_eldenring.bat
```

**Steam must be running** before launching through ModEngine. Previously, the launcher returned successfully without actually starting the game when Steam was closed. Use an **offline, anti-cheat-disabled** modding setup and a disposable backed-up save for experiments involving encounter/progression logic. Never run modded gameplay through an online/EAC-enabled setup.

## 3.3 Important project locations

The exact local tree should be checked on return; these are paths recorded from agent reports:

```text
TestingAI/
  decompiled/
    431030_battle.lua                 # soldier battle Lua reference
  build/
    experiment003/
      source/431030_battle.lua        # authenticated EXP-003 source
    experiment003b/
      source/431030_battle.lua        # modified arrival/wait source
      arrival-wait/431030_battle.luabnd.dcx
      deployment/arrival-wait/       # staged mod root
      modengine-test.ps1             # backup/deploy/verify/rollback
      modengine-backups/             # backup directories
      build-verification.json
      verification/
  docs/
    agent/experiments/
      EXPERIMENT_003B_ARRIVAL_WAIT.md
    docs/
      arena/
        PLACIDUSAX_ARENA_FEASIBILITY.md
        ARENA_ARCHITECTURE.md
        ARENA_IMPLEMENTATION_PLAN.md
        ARENA_TEST_MATRIX.md
        HUMANOID_NPC_FOUNDATION_COMPARISON.md  # check actual saved location
      api/
      analysis/
```

**Note:** The `HUMANOID_NPC_FOUNDATION_COMPARISON.md` file was supplied as an attachment. The exact repository destination should be checked rather than assumed. Similarly, folder structure proposed for Pathfinder/Crucible is a **convention**, not proof those folders already exist.

---

# 4. WHAT WE LEARNED FROM EXPERIMENTS 001–003B

## 4.1 EXP-001 — Establish the modding pipeline

**Purpose:** Prove we can modify Elden Ring's AI Lua and package it in a format the game accepts.

- Established a Lua 5.0-compatible compile and binder repack workflow.
- Used ModEngine 2 to load overrides.
- Set up extraction, compilation, and validation processes.

**Lesson:** Packaging correctness matters. A successfully compiled Lua file is not enough; the archive's entry names, IDs, bytecode header, LUAGNL/LUAINFO metadata, ordering, flags, and compression must remain compatible.

## 4.2 EXP-002 — Soldier moves toward player without attacking

**IN-GAME VERIFIED:** A Godrick soldier approached the player without performing normal attacks, but afterward could wander randomly.

**Lesson:** We can override the soldier's battle Lua behavior, but stopping attack selection does not automatically suppress all higher-level movement decisions.

## 4.3 EXP-003 — Soldier navigates to a fixed region

**IN-GAME VERIFIED:** The soldier walked toward a **custom map region** rather than simply chasing the player. It used Elden Ring's native navigation. After arriving, it wandered, then sometimes returned to the region.

**Relevant game/map identity:**

| Item | Value |
|---|---|
| Test map | `m18_00_00_00` (Stranded Graveyard) |
| NPC | Soldier of Godrick |
| Enemy part | `c4311_9007` |
| NPC EntityID | `18000257` |
| NpcParam | `43114006` |
| NpcThinkParam | `43114006` |
| Battle goal | `431030` |
| Battle Lua | `431030_battle.lua` |
| Destination region name | `EXP003_destination` |
| Destination region type | Other / Point |
| Region's internal Region ID | `9063` |
| Destination **EntityID** | `67676767` |
| Destination XYZ | `(-108.095, 3.183, 150.961)` |
| Approximate soldier start XYZ | `(-102.524, 2.849, 157.056)` |

**Critical distinction:** `ai:SetEventMoveTarget(...)` uses the destination's **EntityID**, not the editor's internal Region ID. Confusing `67676767` and `9063` would break the intended lookup.

Representative working movement request:

```lua
goal:ClearSubGoal()
ai:SetEventMoveTarget(67676767)
goal:AddSubGoal(
    GOAL_COMMON_ApproachTarget,
    10,
    POINT_EVENT,
    0.5,
    TARGET_SELF,
    true,
    9910
)
```

The precise signature and flags should be checked against the authenticated source before copying into a different goal. The destination is **pre-authored map data**, not arbitrary world XYZ input.

**Known staged map SHA256:**

```text
605B02422EE285ABD699107C7A24C8A49BE65DD759B5166A6E71D01AA66D79FD
```

## 4.4 Why EXP-003 wandered: working hypothesis

Agent 1 inspected the battle Lua and published shared Lua goal helpers. The main EXP-003 Update delegated to `Update_Default_NoSubGoal`. That shared helper returns **Success** when the subgoal queue becomes empty. Thus, after the approach finishes, the parent goal may complete and hand control to other AI logic that chooses movement or search behavior.

This is a **source-supported explanation**, not a runtime-proven causal trace. Other engine behavior (AI reactivation, aggro/search, path failure, native recovery) could also contribute. A ten-second approach goal can expire before arrival; an empty queue is not proof the soldier reached the destination.

## 4.5 EXP-003B — Arrival and stable waiting

**STATIC BUILD VERIFICATION:** Agent 1 changed only the main Activate and Update callbacks of the soldier's battle Lua; the remaining 25 of 27 Lua functions were unchanged from EXP-003. It retained the same map, target region, movement technique, and overall packaging. Six mocked callback tests passed, and the binder/map were verified.

**IN-GAME OBSERVATION — NEWER THAN AGENT 1'S REPORT:** I launched the EXP-003B build and saw the soldier **move to the designated position, lower his shield, and stand still**. The unwanted immediate wandering seen in EXP-003 did not occur in this observed test. **This is a real runtime success.** A full timed 90-second hold, multiple repetitions, and behavior after interruptions were not explicitly reported.

### 003B state machine

```text
            MAIN ACTIVATE
                  |
                  v
                MOVING
          /                   \
 distance to POINT_EVENT   approach ends outside
       <= 0.5              arrival tolerance
          |                        |
          v                        v
        ARRIVED              INCOMPLETE_HOLD
          |                        |
 clear approach                renewable Wait
 queue Wait                         |
          v                        v
        WAITING              does not falsely
          |                   claim arrival
          +--> renew 1-second Wait when empty
                and keep parent goal alive
```

Important mechanics:

- MOVING checks `ai:GetDist(POINT_EVENT)` against a `0.5` arrival tolerance.
- On arrival, it clears the movement subgoal and queues `GOAL_COMMON_Wait` for one second with `TARGET_SELF`.
- When the Wait ends, it queues another Wait and returns `GOAL_RESULT_Continue`, preventing ordinary empty-subgoal completion.
- If the approach ends *outside* arrival tolerance, it enters `INCOMPLETE_HOLD` rather than pretending it succeeded.
- The parent state is stored in goal-local slots; it is **not** a persistent global command queue.
- No event-flag input, second command, mouse input, or arbitrary XYZ mechanism was added.
- No NPC faction/hostility change was made.

**Why the lowered shield matters:** It is consistent with a normal waiting/idle transition instead of continuously trying to move. The animation itself does not prove the exact internal goal state.

### EXP-003B artifact fingerprints

From Agent 1's original build report:

| Artifact | SHA256 |
|---|---|
| 003B source Lua | `E63DB0CCE475C399AC61EC97BDF08B1214E9D2FCD4C57FB47B98BE0AB99C51B5` |
| 003B compiled bytecode | `DCBCE49F7F21FBE58DE1D23C9B704F901892C802AEA0FDA99E972DC1DB6B87FB` |
| 003B repacked Lua archive | `D9EE71C57520B597CFCD9399A899DBBE241DFF2DE505F28A07523C3044F0BFCB` |
| 003B staged map (same as 003) | `605B02422EE285ABD699107C7A24C8A49BE65DD759B5166A6E71D01AA66D79FD` |

**Do not rebuild or overwrite this working source merely to change documentation.** Make a new experiment variant for future changes.

---

# 5. WHAT TO DO WITH THE EXP-003B DEPLOYMENT AND BACKUP

## 5.1 Why rollback exists

The test script temporarily replaces the **active EXP-003 deployment** with EXP-003B. Rollback restores the exact EXP-003 files that were backed up. It does **not** delete the prepared EXP-003B build in the repository.

**As of this notebook:** I was given rollback instructions, but no explicit confirmation of the final rollback result appears in the conversation. Therefore **current deployed state is UNKNOWN** until I inspect it. Do not assume either 003 or 003B is active.

## 5.2 If the original PowerShell session is still open

Close Elden Ring first. If `$ops` and `$backup` still refer to the original script and backup directory:

```powershell
& $ops -Action Rollback -BackupDirectory $backup
```

## 5.3 If PowerShell was closed

```powershell
$ErrorActionPreference = 'Stop'
$repo = 'C:\Users\creep\Desktop\Projects\Elden Ring - LoL\EldenRing-LeagueOfLegendsCombat'
$ops = Join-Path $repo 'TestingAI\build\experiment003b\modengine-test.ps1'
$backupRoot = Join-Path $repo 'TestingAI\build\experiment003b\modengine-backups'
Get-ChildItem -LiteralPath $backupRoot -Directory | Select-Object FullName, LastWriteTime
```

Locate the **actual original `test-...` backup folder**. Do not guess or create a fresh one for rollback. Then:

```powershell
$backup = 'PASTE_THE_REAL_FULL_BACKUP_DIRECTORY_HERE'
& $ops -Action Rollback -BackupDirectory $backup
```

If the script refuses, stop and inspect its message. It has guardrails for unexpected files/configuration. **Do not manually overwrite hashes, force-copy files, or delete backups to make it pass.** The `Verify` action was designed primarily to check the **deployed 003B** state; it may not be an appropriate post-rollback check. Use the script's rollback validation and, if needed, compare restored files with recorded baseline hashes.

## 5.4 Safety rules

- Elden Ring must be **closed** before swapping overrides.
- Keep Steam/game files untouched; modify only isolated ModEngine override roots.
- Preserve backup directory paths and test logs.
- Never roll back with a backup from a different test.
- A successful file rollback does **not** undo progression written to a save.
- If a launch produces another black screen/system freeze, stop repeated launches and investigate before continuing.

---

# 6. WHY WE ARE MOVING OUT OF THE CAVE

The Stranded Graveyard soldier is a useful **control**, not the ideal permanent laboratory. The current environment has limited space, a hostile NPC whose AI activates through combat, and no convenient foundation for player-like equipment and animations.

The new laboratory should provide:

1. A large, mostly flat, unobstructed area.
2. Reliable native navigation for ordinary humanoid NPCs.
3. A boss-free and enemy-free test zone.
4. An opt-in player entry and safe return.
5. A **standalone** player-like humanoid NPC with its own AI configuration.
6. Several predefined destination points for movement experiments.
7. Repeatable reset/reload behavior.
8. Clean isolation from quests, boss rewards, other maps, and prior experiments.

**Design principle:** test the arena and the actor **separately** before combining them. Otherwise, a failure could be caused by navmesh, streaming, NPC registration, AI activation, or event logic, and we would not know which.

---

# 7. PROJECT CRUCIBLE — THE ARENA

## 7.1 Leading candidate: Dragonlord Placidusax's arena

**Status: source-researched, NOT built or in-game tested as a laboratory.**

Why it appeals to us: large, visually simple, open, good for movement and eventual combat. Why it may be a poor *first* lab: special boss events, elevated terrain, map streaming, and unverified humanoid navigation.

Agent 2 identified these references from a published source dump:

| Element | Identifier / meaning |
|---|---|
| Map | `m13_00_00_00` — Crumbling Farum Azula |
| Boss Enemy | `c4520_9000` |
| Boss EntityID | `13000830` |
| Boss NpcParam / ThinkParam | `45200072` / `45200000` |
| Boss groups | `13005830`, `13005122` |
| Boss target dummy | `13000840` |
| Candidate arena collision | `h015000` |
| Lie-down interaction asset | `13001505` |
| Boss battle trigger region | `13002831` |
| Existing Placidusax warp Player part | `c0000_9003`, EntityID `13000981` |
| Published Player part XYZ | `(12.21, 1009.6, 330.07)` |
| Another nearby Player part | `13003111` |
| Boss grace | `13001951` |

**These IDs are source-verified in an older/published dump, not yet confirmed against the installed game files.** Do not assume the XYZ is safe for a newly placed NPC, or that the boss collision reference guarantees navmesh coverage.

## 7.2 Why removing only Placidusax's model is not enough

The boss is controlled by multiple map events:

| Event | Function described by Agent 2 |
|---|---|
| `13002830` | Death, reward/progression flags, weather reset |
| `13002834` | Lie-down interaction, cutscene and arrival |
| `13002835` | Boss initialization, battle activation, health bar |
| `13002840` | Weather / phase effect |
| `13002841` | Camera behavior |
| `13002846` | Phantom music-state helper |
| `13002849` | Music initialization and related helper |

**Do not simulate boss removal by killing the boss or forcing its defeat flag.** That could affect grace, rewards, progression, and persistent save state. Suppress only audited encounter paths in a **disposable copy** of the map event file. Preserve the rest of Farum Azula, including Maliketh and Godskin Duo logic, because this is a shared map.

## 7.3 Planned override components

```text
map/mapstudio/m13_00_00_00.msb.dcx   # NPC, model refs, regions, maybe Player part
event/m13_00_00_00.emevd.dcx         # targeted boss-event isolation
<chosen hub map>/event EMEVD        # opt-in warp interaction
regulation.bin                       # isolated NPC/Think/CharaInit rows
script/<registered AI archive>       # independent Lua goal(s)
```

The exact hub event file, new IDs, and registered archive name are **not yet assigned**. Navigation assets should initially be **inspected, not edited**.

## 7.4 Arena navigation: biggest unknown

A visually flat arena is not evidence of usable NPC navigation. Placidusax's movement may use boss-specific mechanisms. We need to inspect the arena-height navigation instances/triangles and collision using compatible tools (Smithbox / NVA / Havok navigation resources), then verify with a real ordinary NPC.

**Minimum runtime gate:** one known-working soldier walks 3–5 metres between two safe points with the player standing off-route. If that fails, distinguish AI activation, region lookup, draw/streaming, collision, and navigation before declaring the navmesh missing.

## 7.5 Alternative arenas

Possible open-world alternatives include a controlled patch near Gatefront in Limgrave or another ordinary humanoid-patrolled open area. Wailing Dunes is visually spacious but has its own special boss/event complexity. These are **candidate ideas**, not research-verified superior replacements.

**Fallback supported by project evidence:** remain in `m18_00_00_00` while developing the player-like NPC and command controller. We know native navigation works there.

---

# 8. PROJECT CRUCIBLE — WHICH NPC SHOULD WE BUILD?

Agent 2 completed `HUMANOID_NPC_FOUNDATION_COMPARISON.md` on 13 October 2026. Its recommendation is important:

> Keep Godrick as the proven immediate control. For a permanent player-like actor, investigate a **fixed-equipment `c0000` map Enemy**, based on a normal humanoid template such as Nepheli Loux. **Do not start with Mimic Tear's copy-player lifecycle.**

This is a **research recommendation**, not a proven working new NPC.

## 8.1 Why `c0000` matters

`c0000` is the player-like humanoid character substrate used by various human NPC configurations. Its `CharaInitParam` supports equipment/inventory fields such as right/left weapons and armor, which is a more natural starting point for a player-like combatant than the Godrick soldier's dedicated `c4311` character model.

However:

- Player-like appearance does **not** prove player-like combat command execution.
- A map Enemy with `c0000` does **not** automatically use our custom Lua.
- Friendly team settings do **not** guarantee the AI stays active without an enemy.
- Spirit summon follow/warp/dismissal systems may conflict with movement commands.
- We should not assume a specific shared goal (such as WhiteGhost battle `5000`) is selected without inspecting the actual current-build parameter rows.

## 8.2 Candidate comparison

| Candidate | What we know | Verdict |
|---|---|---|
| **Godrick soldier** `c4311` | Existing custom battle Lua and fixed-region movement/wait proven in game | **Keep as navigation control** |
| **Fixed `c0000` humanoid** (Nepheli-style) | Human map Enemy and player equipment architecture source-verified; custom independent idle AI unverified | **Best permanent actor candidate** |
| **Actual humanoid spirit summon** | Buddy lifecycle, follow logic, special effects, player-target sharing may be involved | Don't assume easier to command |
| **Mimic Tear** | Player-copy event and human `c0000` representation exist; setup has boss/spirit dependencies | **Defer** until dynamic equipment cloning is needed |
| **NPC invader** | Player-like actor possible, but invasion/hostility dependencies require separate audit | Not the first choice |

## 8.3 Concrete source-identified humanoid references

### Nepheli Loux-related fixed NPC template

- Stormveil Enemy: `c0000_9035`
- EntityID: `10000730`
- NpcParam: `523340014`
- NpcThinkParam: `523340000`
- CharaInit: `23340`
- Source collision: `h010200` (**only valid for its source map; do not transplant this collision into Farum Azula**)

### Nepheli Loux Puppet-related names

- Buddy label: `25900000`
- NpcParam label: `100000020`
- ThinkParam label: `100000020`
- CharaInit label: `23342`

**Caution:** These Puppet entries came from Paramdex **name tables**; the actual Buddy-to-row relationships and selected battle/logic IDs were **not verified**. Do not assume they can be copied verbatim into an independent map NPC.

### Mimic Tear references

- Spirit Buddy labels: `20700000`, `20700001`
- Spirit-related human Npc/Think labels: `100000010`
- CharaInit label: `26050`
- Nokron boss `c0000_9010`, EntityID `12020850`
- Boss NpcParam `526100965`, ThinkParam `90603100`, CharaInit `24020`
- Event `12022860` performs player-copy/AI setup in the published source

**Do not infer `logicId = 31000` from the digits in `90603100`.** The selected logic and battle goal require actual row inspection.

## 8.4 What a standalone humanoid experiment needs

A future fixed `c0000` map Enemy likely involves:

```text
MSB Enemy part
   ├── Model = c0000
   ├── NpcParamID
   ├── NpcThinkParamID
   ├── CharaInitID (equipment / human stats)
   ├── map-local collision / draw / streaming references
   └── unique EntityID and groups

NpcThinkParam / CharaInit selectors
   ├── logicId
   ├── battleGoalID
   ├── npcPlayerThinkId (inspect precedence!)
   └── team / activation / buddy-related flags (audit, don't guess)

Dedicated registered Lua
   ├── movement goal
   ├── stable wait
   └── eventually command polling and combat
```

**Independent registration is unverified.** Creating a new Lua filename does not establish that the engine will load/dispatch it. The full goal/logic ID mapping and binder metadata need source and runtime validation. Do not globally overwrite shared `aicommon` goal `5000` or the soldier's `431030` to force the humanoid to work.

## 8.5 The crucial idle activation problem

Our Godrick soldier currently enters its custom battle logic via normal combat-related activation. It doesn't attack, but that is **not equivalent** to being friendly or ignoring the player. A permanent player-like NPC should:

- Stay loaded while the player is nearby.
- Accept commands without being hostile to the player.
- Not automatically follow the player when idle.
- Not return home, teleport, or dismiss itself due to Buddy logic.
- Not require us to attack it to wake up its custom Lua.
- Continue dispatching our custom goal after reaching a destination.

This is arguably a bigger architectural risk than changing the model.

## 8.6 The best first humanoid proof of concept

**Do this in the already verified m18 area, NOT in Placidusax yet:**

1. Inspect current-build Nepheli map template, relevant parameter rows, equipment, and logic selectors.
2. Duplicate a `c0000` Enemy into a disposable isolated override with a **new EntityID** and correct m18 collision/draw references.
3. Use fixed equipment, no player-copy, no spirit-ash manager, no quest/talk/invasion lifecycle.
4. Establish that it appears and remains loaded **without hostility**.
5. Give it an independently registered movement/idle Lua configuration.
6. Send it to one new fixed Point region 3–5 metres away, then hold for **60 seconds**.
7. Repeat with the player near/far and across **three reloads**.
8. Confirm the original Godrick soldier and all unrelated NPCs remain unchanged.

If it cannot dispatch custom AI while friendly/idle, **record the blocker**. Do not fake success by provoking hostility.

---

# 9. EXPERIMENT ROADMAP: PATHFINDER AND CRUCIBLE

These are **proposed milestones**, not already completed experiments unless marked.

## 9.1 Project Pathfinder — movement and combat control

| ID | Milestone | State / success gate |
|---|---|---|
| EXP-001 | Lua/ModEngine packaging | Established |
| EXP-002 | Approach without attacking | In-game verified |
| EXP-003 | Navigate to fixed custom map region | In-game verified; wandered after arrival |
| **EXP-003B** | **Navigate → arrive → stable wait** | **Observed in game; timed robustness not fully reported** |
| EXP-004 | Switch destination A → B via a live command | **Not implemented** |
| EXP-005 | Navigate to an arbitrary XYZ | **Not implemented; major unknown** |
| EXP-006 | Convert a mouse click into a world-space move order | **Not implemented** |
| EXP-007+ | Targeted attacks, range, cooldowns, attack-move | **Not implemented** |

### EXP-004 design hypothesis

Try two **pre-placed regions** A and B first. A validated external signal (possibly an EMEVD flag, AI event request, or native-to-Lua bridge) would tell the NPC to change its target. It should be able to receive the signal while MOVING **or** WAITING, cancel/replace the current subgoal, and use native navigation to reach the new region.

**Unknowns:** command visibility to Lua, polling cadence, parent goal replacement, AI replan behavior, and whether a new command works while the NPC is stationary. Do not assume `ai:IsEventFlag`, EMEVD `RequestCharacterAICommand`, or `SetEventPoint` will work for our exact configuration merely because source declarations exist.

### EXP-005 design hypothesis

A region ID is not arbitrary XYZ. A future simple input experiment could record the **player's current world position** after a key press/attack, but that only solves **obtaining a coordinate**. We still need an engine mechanism to route an NPC to that coordinate: movable event target, coordinate-accepting goal, or another native bridge. That mechanism is **not proven**.

### EXP-006 dependency

Right-click navigation needs both **screen-to-world raycasting** and **validated arbitrary-coordinate movement**. Do not start with camera/input polish before EXP-005 is solved.

## 9.2 Project Crucible — environment and permanent test actor

| ID | Milestone | Pass condition |
|---|---|---|
| LAB-001 | Empty arena and safe entry/return | No boss, music/health bar/cutscene interference, safe floor, repeatable warp |
| LAB-002 | Standalone player-like `c0000` NPC | Loads, stays active, no unwanted summon/quest behavior |
| LAB-003 | Independent custom AI | Dedicated Lua executes without global/shared NPC modifications |
| LAB-004 | Native navigation in chosen arena | Moves 3–5 m to fixed region |
| LAB-005 | Stable waiting | Arrives and holds without follow/wander |
| LAB-006 | Reset and re-entry | Three reproducible test cycles |
| LAB-007 | Dynamic A/B commands in lab | Reuse Pathfinder's proven command mechanism |

**Important scheduling nuance:** LAB-002/003 should first be validated in a **small m18 prototype** while LAB-001 arena access is built separately. Only then combine them in Placidusax. The lab IDs describe capabilities, not necessarily the chronological order of every micro-test.

---

# 10. EXACT GATES FOR THE FIRST ARENA BUILD

**Gate S0 — Provenance:** Identify current installed game build, tool versions, original MSB/EMEVD, hashes, and verify published map/event IDs against the current installation.

**Gate S1 — Safe map copy:** Unique Enemy/Player/region IDs, correct model references, collision and draw groups, MSB readback.

**Gate S2 — Encounter isolation:** Audit every Placidusax boss/dummy/flag caller; don't touch shared Farum Azula events indiscriminately or force boss defeat.

**Gate S3 — Navigation inspection:** Inspect NVA/HKX instances at arena height; don't infer navmesh from visible floor.

**Gate S4 — Lua/binder:** Independent AI goal registration, correct bytecode, metadata, and archive readback. This is only needed when adding an NPC.

**Gate R0 — Entry:** An opt-in interaction warps me to a stable arena Player part; no warp loop or fall-through.

**Gate R1 — Empty encounter:** No Placidusax, boss health bar, music, forced camera/cutscene/weather changes, or progression rewards.

**Gate R2 — Return:** Can exit/re-enter safely without modifying grace or defeat state.

**Gate R3 — NPC presence:** Exactly one expected test NPC loads and activates.

**Gate R4 — Movement:** Known fixed-region movement works with player off-route.

**Gate R5 — Arrival:** Stationary hold is measured separately from movement success.

**Gate R6 — Additional destinations:** Forward, sideways, reverse path connectivity.

**Gate R7 — Reset:** Three reliable re-entry/reload cycles; document death behavior separately.

**Gate R8 — Isolation:** Original m18 soldier and other users of goal `431030` unchanged; other Farum Azula events untouched.

**Gate R9 — Rollback:** A/B/A deployment, exact config/override restoration verified by hashes.

**Stop conditions:** unexpected save/progression changes, missing critical navigation references, unknown boss-event dependencies, wrong layer/streaming, non-unique IDs, or inability to register a dedicated AI goal without globally affecting unrelated NPCs.

---

# 11. AGENT ROLES AND HOW TO USE THEM

## Agent 1 — Pathfinder / runtime experiment engineer

Primary responsibility:

- Preserve and document EXP-003B's working Lua build.
- Update the experiment report with **my actual successful in-game observation**.
- Analyze and implement the next minimal movement/command experiment.
- Compile/repack/read back Lua and binder metadata.
- Provide safe backup/deploy/verify/rollback scripts.
- Keep experiments isolated and reproducible.

**Do not ask Agent 1 to casually edit the proven EXP-003B build.** New behavior belongs in EXP-004 or a separately named variant.

## Agent 2 — Crucible / research and architecture

Primary responsibility:

- Compare arena candidates and audit Placidusax map/event/nav references.
- Research `c0000` human NPC, `NpcParam`, `NpcThinkParam`, `CharaInit`, Lua dispatch, and summon/follow dependencies.
- Recommend small, independently testable implementation gates.
- Maintain source ledgers, unknowns, and architecture documentation.

Agent 2's latest recommendation: **Godrick now, fixed `c0000` humanoid next, Mimic Tear later**.

## Astra — use selectively

Reserve a more expensive, high-effort agent for **bounded difficult integration** when existing evidence identifies a specific blocker, e.g. arbitrary XYZ navigation or independent `c0000` idle dispatch. Do not spend a major session rebuilding broad context or implementing many unverified features simultaneously. Provide it the specific source reports, observed behavior, and a tight acceptance test.

## Rules for all agents

1. Never say a source-backed mechanism is runtime-verified unless we observed it.
2. Never modify unrelated experiments, saves, or installed game files without explicit approval.
3. Work in isolated override roots and produce a changed-files list.
4. Require backup and rollback before any live deployment.
5. Keep experiments narrow: one hypothesis per test.
6. Avoid global shared goal overrides that change unrelated NPCs.
7. Don't invent ID values, event slots, map coordinates, or Lua API signatures.
8. Keep existing working build artifacts immutable; version new variants.
9. If an unexpected black screen or freeze recurs, stop repeated testing.
10. Record the actual runtime observation, including failures and uncertainties.

---

# 12. FIRST SESSION BACK — PRACTICAL CHECKLIST

## Before launching the game

- [ ] Open this notebook and review Section 0.
- [ ] Check the repository's current Git status and recent changes **without resetting or cleaning anything**.
- [ ] Find Agent 1's `EXPERIMENT_003B_ARRIVAL_WAIT.md` and the 003B build-verification files.
- [ ] Confirm whether the EXP-003B deployment was rolled back; if uncertain, inspect backup paths and live override hashes before changing anything.
- [ ] Record the original EXP-003B in-game success in an addendum: **“Reached fixed destination, lowered shield, stood still; 90-second duration not explicitly confirmed.”**
- [ ] Confirm the four arena reports and the humanoid comparison are saved in the main repository.
- [ ] Decide whether the first work session is **LAB-001 empty arena** or **`c0000` proof of concept in m18**; do not combine both on the first test.

## For LAB-001 specifically

- [ ] Read current-build `m13_00_00_00` map/event data read-only.
- [ ] Confirm boss event dependencies and player warp part.
- [ ] Inspect elevated floor collision/navigation and stream groups.
- [ ] Choose a **specific** safe hub entry interaction and return part.
- [ ] Prepare a disposable arena-only override and backed-up offline test save.
- [ ] Validate compiled event/map files before launch.
- [ ] Perform **empty arena entry → walk around → return → re-enter**.
- [ ] Do not add a humanoid NPC until this succeeds.

## For the humanoid `c0000` proof of concept

- [ ] Inspect actual Nepheli map-NPC and Puppet parameter rows; do not rely only on name tables.
- [ ] Determine effective AI selector precedence (`NpcThinkParam`, `CharaInit npcPlayerThinkId`, event overrides).
- [ ] Clone a fixed-loadout `c0000` map Enemy into a disposable m18 test, with new IDs.
- [ ] Verify it loads and remains nonhostile/active without a summon manager.
- [ ] Prove dedicated Lua dispatch before claiming independent control.
- [ ] Reuse fixed-point movement, hold for 60 seconds, test player near/far, then three reloads.
- [ ] Preserve Godrick as an independent reference/control.

---

# 13. READY-TO-PASTE HANDOFF FOR AGENT 1

```text
We have a new user-observed runtime result for EXP-003B:
The Godrick soldier moved to the fixed EXP-003 destination, lowered his
shield, and stood still rather than wandering as he did in EXP-003.
This was observed in Elden Ring after the statically verified 003B build.
Do not claim a timed 90-second hold or dynamic command reception unless
there is additional evidence. The user's final rollback state is not
explicitly confirmed in the conversation.

Please:
1. Preserve the existing 003B source, archive, staged map, and hashes.
2. Create a dated runtime-results addendum to the EXP-003B report.
3. State exactly which claims are runtime-verified vs still untested.
4. Propose the smallest EXP-004 A/B destination-switching test, including
   how to send a new command while WAITING and how to observe success.
5. Research/validate the proposed event-to-Lua transport before
   implementing; do not assume any event flag/API bridge works.
6. Do not deploy, modify saves, or change the live ModEngine root without
   a separate explicit instruction and a rollback plan.
```

# 14. READY-TO-PASTE HANDOFF FOR AGENT 2

```text
The user wants to transition from the Stranded Graveyard soldier to a
reusable Elden Ring AI laboratory (Project Crucible). EXP-003B has now
worked in-game: the soldier reached a fixed point, lowered his shield,
and stood still. No dynamic command has been demonstrated.

Your arena feasibility, architecture, implementation plan, test matrix,
and HUMANOID_NPC_FOUNDATION_COMPARISON reports are our baseline.

Please prepare the smallest independent next implementation proposal:
A. LAB-001: safe, empty arena with opt-in entry and return, no Placidusax
   encounter side effects, with navigation/streaming audit first.
B. A separate fixed-loadout c0000 humanoid proof of concept in the
   already-proven m18 area, using current-build row inspection and
   independently registered AI. Do not mix it with LAB-001 initially.

Identify which prerequisite files are present, which are missing,
current-build identifier verification, exact change surfaces, stop
conditions, test gates, and safe rollback. Keep Godrick as a reference;
do not implement Mimic cloning or global aicommon changes.

Research/plan only unless separately authorized to implement. Do not
change installed ModEngine, saves, or existing experiments.
```

---

# 15. COMMON CONFUSIONS AND QUICK ANSWERS

**Q: Did EXP-003B succeed?**  
**A:** Yes, for the **observed** navigation-and-stop behavior. Long-duration and repeated-interruption robustness remain unmeasured.

**Q: Can I issue a second move command now?**  
**A:** Not yet. EXP-003B has no verified command-reception bridge. That's EXP-004.

**Q: Can I click anywhere and have the NPC walk there?**  
**A:** Not yet. Current navigation targets a **predefined map Point region**. Arbitrary XYZ and click-to-world are separate unsolved problems.

**Q: Why not use a summon directly?**  
**A:** Summons share useful AI infrastructure, but may bring follow, warp, targeting, and dismissal logic. Agent 2 recommends a **standalone fixed `c0000` map Enemy** that borrows the humanoid equipment foundation without relying on the spirit-ash lifecycle.

**Q: Why not use Mimic Tear?**  
**A:** Its player-copy and transformation initialization add dependencies that don't help the first movement tests. Mimic is attractive later if copying the player's current equipment becomes a requirement.

**Q: Why not simply delete Placidusax?**  
**A:** His encounter spans multiple events, flags, dummy entities, music, cutscenes, and rewards; removing one entity is insufficient and forcing death may alter the save.

**Q: Why test `c0000` in the cave if I'm tired of the cave?**  
**A:** Only as a **diagnostic isolation step**. We know navigation works in m18, so it lets us determine whether the new humanoid's AI works without simultaneously debugging a new arena.

**Q: What if Placidusax's arena has no suitable humanoid navmesh?**  
**A:** Switch to a conventional open area or keep m18 as the control. Do not turn this into a navmesh-generation project unless we explicitly choose that scope.

**Q: Did rollback remove my successful build?**  
**A:** No. Rollback restores the prior **deployed override files**; the staged 003B source/archive remain in the repository. The actual rollback result still needs confirmation.

**Q: What is the most important technical risk now?**  
**A:** For Pathfinder: reliable command reception and arbitrary-coordinate navigation. For Crucible: usable arena navmesh and **independent friendly/idle custom Lua activation on a `c0000` actor**.

---

# 16. SOURCE MATERIAL AND REPORTS TO REOPEN

## Local project reports

- `TestingAI/docs/agent/experiments/EXPERIMENT_003B_ARRIVAL_WAIT.md` — Agent 1's source analysis, state machine, hashes, build checks, deployment/rollback protocol. **Predates user runtime success.**
- `TestingAI/docs/docs/arena/PLACIDUSAX_ARENA_FEASIBILITY.md` — map/boss identifiers, event dependencies, arena navigation uncertainty.
- `TestingAI/docs/docs/arena/ARENA_ARCHITECTURE.md` — isolated override design, player entry, NPC placement, reset.
- `TestingAI/docs/docs/arena/ARENA_IMPLEMENTATION_PLAN.md` — ordered build/test gates.
- `TestingAI/docs/docs/arena/ARENA_TEST_MATRIX.md` — static and runtime pass/fail criteria.
- `HUMANOID_NPC_FOUNDATION_COMPARISON.md` — Agent 2's NPC candidates and fixed-`c0000` recommendation (verify repository location).
- `TestingAI/docs/docs/analysis/GODRICK_SOLDIER_AI.md` — original soldier AI analysis.
- `TestingAI/docs/docs/api/event-ai-communication.md` — candidate event/Lua bridge mechanisms.
- `TestingAI/docs/docs/api/native-runtime.md` and `analysis/NATIVE_LUA_NAVIGATION.md` — native interfaces/navigation research; source evidence, not runtime proof.

## Published primary/reference sources used by agents

- [Farum Azula events, pinned soulstruct-vanilla commit](https://github.com/Grimrukh/soulstruct-vanilla/blob/e6de1b79370755152f4f89c4a106a2d67c9ae674/eldenring/events/m13_00_00_00.evs.py)
- [Farum Azula map enums](https://github.com/Grimrukh/soulstruct-vanilla/blob/e6de1b79370755152f4f89c4a106a2d67c9ae674/eldenring/enums/m13_00_00_00_enums.py)
- [Stormveil map enums (fixed human NPC example)](https://github.com/Grimrukh/soulstruct-vanilla/blob/e6de1b79370755152f4f89c4a106a2d67c9ae674/eldenring/enums/m10_00_00_00_enums.py)
- [Nokron events (Mimic Tear copy/init)](https://github.com/Grimrukh/soulstruct-vanilla/blob/e6de1b79370755152f4f89c4a106a2d67c9ae674/eldenring/events/m12_02_00_00.evs.py)
- [EldenRingAI decompiled Lua reference](https://github.com/zoloypzuo/EldenRingAI/tree/3b3efb00219026dfba4663b9eb1a1afd94c0a68e)
- [Paramdex ER names/definitions](https://github.com/soulsmods/Paramdex/tree/ff7245e524329bc3eab00036723d2bd53384cedf/ER)
- [Smithbox source](https://github.com/vawser/Smithbox/tree/cbd477a8fd6d436b3e011c8548e1de8fd8876918)
- [Elden Ring EMEVD instruction reference](https://soulsmods.github.io/emedf/er-emedf.html)
- [Open Enemy Control research reference](https://github.com/AlpinDale/er_enemy_control/tree/8056f10c0864e3e10d6c20cc85827676fac36ab4)

**Source caveat:** External repositories may represent older game versions. Check against the local installed build before allocating IDs or modifying params/events.

---

# 17. PROJECT DECISIONS / CHANGE LOG

| Date | Decision / observation | Evidence level |
|---|---|---|
| Before 2026-10-13 | Use an NPC rather than the native player for click-driven control | Architectural choice |
| Before 2026-10-13 | EXP-002: approach without attacks; unwanted wandering remains | In-game verified |
| 2026-10-13 | EXP-003: fixed-region native navigation works in m18 | In-game verified |
| 2026-10-13 | Agent 1 prepares 003B renewable waiting state | Static verification |
| 2026-10-13 | **User observes EXP-003B reaches target, lowers shield, stands still** | **In-game verified observation** |
| 2026-10-13 | Name movement work **Project Pathfinder** | Project convention |
| 2026-10-13 | Name lab work **Project Crucible** | Project convention |
| 2026-10-13 | Agent 2 identifies Placidusax map/event/access candidates | Source verification, runtime pending |
| 2026-10-13 | Agent 2 recommends fixed-equipment `c0000` map NPC; defer Mimic | Research recommendation, runtime pending |
| Next session | Confirm 003B rollback and preserve runtime addendum | **Pending** |
| Next session | Decide/prepare isolated LAB-001 and m18 `c0000` proof of concept | **Pending** |

---

# 18. THE PRINCIPLE TO REMEMBER

**We already proved that Elden Ring can be made to navigate an NPC to a chosen map point and then stop.** That is not the whole mod, but it is a meaningful engine-control result.

From here, the project should become **more modular, not more complicated all at once**:

- **Pathfinder:** make the working movement behavior accept *new commands*.
- **Crucible:** give those experiments a *clean environment* and a *player-like NPC*.
- Keep every milestone reversible and individually demonstrable.

When I return, I should not start by re-learning everything from scratch. **I should start by confirming the known-good EXP-003B artifact, reading the latest agent reports, and choosing one narrowly scoped next experiment.**

*End of personal resume guide.*
