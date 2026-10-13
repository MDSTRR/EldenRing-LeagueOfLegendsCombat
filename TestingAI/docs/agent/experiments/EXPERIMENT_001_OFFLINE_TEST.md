# Experiment001 — prepared offline game test

Prepared 2026-10-13 after compiled archive verification. **No game launched, Steam file edited, or override enabled.** This is a manual test procedure, not proof of in-game compatibility.

## Prepared mod roots

Repository root: `C:\Users\creep\Desktop\Projects\Elden Ring - LoL\EldenRing-LeagueOfLegendsCombat`.

| Variant | Mod root relative to repository | Archive inside root |
|---|---|---|
| Unchanged-bytecode baseline | TestingAI/build/experiment001/deployment/baseline | script/431030_battle.luabnd.dcx |
| Compiled unchanged source | TestingAI/build/experiment001/deployment/compiled-source | script/431030_battle.luabnd.dcx |

Compiled override archive SHA256: `AC76EF91121F2274DDF1D44AC6D51B88790437336F696D255B5D0846E8738B53`, size11024 bytes. Baseline archive hash: `DE1DED63C3DB3C8555D91C22B976C37E94B791CC1DC7DCD742A6573B365D22B1`, size5168. No map, regulation or AI logic/common override is included.

## Before enabling anything

Provide the actual ModEngine2 `config_eldenring.toml` and launcher configuration in the workspace so the active mod root, archive priority and supported offline/anti-cheat-disabled launch procedure can be inspected. None was found in the repository; Smithbox project.json is unrelated. Do not move archives into Steam or patch the executable.

Use a separate copied test configuration, preserve the original config and any preexisting conflicting overrides, and enable only one experiment root at a time. Point its existing enabled mod entry to the **mod root**, not the script folder or archive file. Absolute path avoids confusion over launcher working directory. Do not install tools or guess a standalone configuration. Record actual game/loader versions and active config.

Confirm the supported ModEngine offline launch bypasses anti-cheat before testing. Do not launch modded tests through normal Steam anti-cheat-enabled startup. Codex has not validated the actual loader setup or its compatibility with this build.

## Manual sequence

1. Establish ordinary soldier behavior with neither experiment override enabled, using the same controlled test conditions. Record source config/versions and footage.
2. Enable the unchanged-bytecode baseline root only. Confirm archive redirection/loading with actual loader evidence; unchanged visible behavior alone cannot prove loading. Observe NPC activation, movement, attacks, interruptions, and absence of crashes or idle behavior. Avoid drawing conclusions from a single randomized action sequence.
3. If baseline loads and ordinary behavior remains functional, disable it and enable compiled-source root only. Confirm the correct archive loads and repeat comparable observations. Compare outcomes, not identical random attack orders.
4. Record evidence of load/activation, test area/instance, conditions, time, success/failure and any logs. If crash/idle/new behavior occurs, stop, disable the test entry and preserve logs. No behavior corrections are part of this experiment.

The selected c4311_9007/entity18000257/mapm18_00_00_00 uses battleGoalID431030 according to user Smithbox findings; tutorial-boss identity and installed param mapping remain unconfirmed independently. This override applies to all characters using431030, so keep the test controlled.

Success requires verified loading and reproducible ordinary NPC behavior in-game for both stages. Static matching alone cannot establish engine acceptance, activation or behavior preservation. This is not a movement-controller/destination experiment.

## Differences and risks to observe

Compiled source produces larger bytecode due to source name, line tables and local debug records. Instructions, constants and executable function shape match all27 baseline functions. Extra metadata can affect diagnostic/debug introspection and memory/size; acceptance by the actual game remains unverified. Do not strip or rewrite it without a separate justified validation.

## Revert

Disable the experiment mod entry or restore the backed-up test config. Restore any previous conflicting override that was temporarily disabled. Leave experiment outputs outside enabled roots if necessary; no local deletion required. No Steam file restoration is needed because Steam files were never modified. Verify ordinary baseline behavior returns.
