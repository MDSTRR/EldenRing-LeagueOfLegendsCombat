# Experiment002 — staged archive and reviewed ModEngine2 setup

2026-10-13. **PASS: workspace staging and static configuration review.** External deployment and in-game testing not performed. Source archive, installed ModEngine files, Git branches and game files unchanged.

## Staging evidence

Fresh recovery verification passed using exact recovered references and the existing manifest; no recompilation/repack or weakened checks. Evidence: `TestingAI/build/experiment002/recovery-20261013-213930-4342346/recovery-verification.json`. Earlier [recovery report](EXPERIMENT_002_RECOVERY_VERIFICATION.md) explains line-ending and missing-path reconciliation.

Verified7728-byte copy staged at:

`C:\Users\creep\Desktop\Projects\Elden Ring - LoL\EldenRing-LeagueOfLegendsCombat\TestingAI\build\experiment002\deployment\approach-only\script\431030_battle.luabnd.dcx`

Source and staged SHA256 both:

`71D1B924524B4811A3CFFC62B0DA516CAF253687443A7B7D69A03AAB17644A17`

Staging manifest: `TestingAI/build/experiment002/staging-20261013-213930.json`. Original preparation manifest and verify-and-stage.ps1 remain unchanged; do not use that old original-path gate to bypass recovery discrepancies.

## Actual configuration review

User supplied `C:\Users\creep\Documents\ModEngine-2.1.0.0-win64\config_eldenring.toml`. Read-only inspection found:

- `launchmod_eldenring.bat` invokes `.\modengine2_launcher.exe -t er -c .\config_eldenring.toml`; relative paths require the ModEngine directory as working directory.
- Mod loader enabled; exactly one enabled entry, `default`, path `mod`; external_dlls empty, loose_paramsfalse, scylla_hidefalse, debugfalse.
- Config comments specify mod paths relative to the launcher. Active root is `C:\Users\creep\Documents\ModEngine-2.1.0.0-win64\mod`.
- Only override found: `mod\script\431030_battle.luabnd.dcx`,11024 bytes, SHA256 `AC76EF91121F2274DDF1D44AC6D51B88790437336F696D255B5D0846E8738B53`, matching Experiment001 compiled-source archive.
- Config SHA256 `4C3986DF4F138B70B14089EBD862573E9855ED102A2B4E445D95187CEEA759F1`; launcher SHA256 `8610BF5AD06E7534C355CCB2D9CB4A336491E4E6935AE889D184CD7923E83953`.

No configuration changes are needed for a manual replacement at the existing relative script path. No competing mod entry or file was found within the inspected configured root. This does not prove runtime redirection. Installed README states its supported Elden Ring launcher disables EAC for offline mods; that behavior was not executed/validated here. User must use the existing offline mod-launch setup and avoid normal anti-cheat-enabled launch. No game installation files were inspected or edited.

## Exact user-run PowerShell commands

Use PowerShell7. Close Elden Ring before **each** operation. Run blocks separately around manual tests; do not paste the entire sequence and skip observations. No command below launches the game.

The prepared helper `TestingAI/build/experiment002/modengine-test.ps1` contains the reviewed absolute installation path and pinned archive/config/launcher/prior-override hashes. It refuses changed setup, unknown overrides, unsafe backup paths, existing backup directories or an open game. It keeps backups and displaced copies in the project, uses no deletion, never edits TOML/launcher, and never targets Steam. Syntax was checked; external write actions were not executed by Codex.

### Back up the current setup and disable the script override for A

```powershell
$ErrorActionPreference = 'Stop'
$repo = 'C:\Users\creep\Desktop\Projects\Elden Ring - LoL\EldenRing-LeagueOfLegendsCombat'
$ops = Join-Path $repo 'TestingAI\build\experiment002\modengine-test.ps1'
$backup = Join-Path $repo ('TestingAI\build\experiment002\modengine-backups\test-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N'))
& $ops -Action Backup -BackupDirectory $backup
if ($LASTEXITCODE -ne 0) { throw 'Backup failed; stop.' }
$backup
& $ops -Action Disable -BackupDirectory $backup
if ($LASTEXITCODE -ne 0) { throw 'Disable failed; stop.' }
```

Keep the printed backup path and use the same `$backup` throughout. If reopening PowerShell, restore `$repo`/`$ops` above and set `$backup` to that exact printed directory; do not generate a new backup directory. Backup contains prior archive, config, launcher and a hash ledger. Disable moves the active archive into that backup directory; the original backup remains intact.

Manually perform A offline: same confirmed NPC, normal detection/approach/attacks for at least30 seconds. Then close the game.

### Deploy Experiment002 for B and verify the installed hash

```powershell
& $ops -Action Deploy -BackupDirectory $backup
if ($LASTEXITCODE -ne 0) { throw 'Deployment failed; stop.' }
& $ops -Action Verify -BackupDirectory $backup
if ($LASTEXITCODE -ne 0) { throw 'Deployed hash check failed; stop.' }
```

Verify requires SHA256 `71D1B924524B4811A3CFFC62B0DA516CAF253687443A7B7D69A03AAB17644A17` at `C:\Users\creep\Documents\ModEngine-2.1.0.0-win64\mod\script\431030_battle.luabnd.dcx`. Stop on error. No config change accompanies deployment.

Manually perform B offline after a full restart/reset: same reachable NPC/player conditions, expected walk/guard approach without ordinary melee attacks for at least30 seconds. Move away slightly to test renewed approach separately. Do not attack/stagger/apply effects to the NPC. Close the game.

### Disable for A again, then restore the pre-test override

```powershell
& $ops -Action Disable -BackupDirectory $backup
if ($LASTEXITCODE -ne 0) { throw 'Disable failed; stop.' }
```

Manually repeat A offline after restart/reset and confirm normal attacks return. Repeat A/B/A at least once; use the same existing backup. Close the game, then roll back:

```powershell
& $ops -Action Rollback -BackupDirectory $backup
if ($LASTEXITCODE -ne 0) { throw 'Rollback failed; stop.' }
Get-FileHash -LiteralPath 'C:\Users\creep\Documents\ModEngine-2.1.0.0-win64\mod\script\431030_battle.luabnd.dcx' -Algorithm SHA256
```

Rollback verifies/restores exact pre-test hash `AC76EF91121F2274DDF1D44AC6D51B88790437336F696D255B5D0846E8738B53`, preserving displaced Experiment002 copies. It can be run immediately to cancel the test without completing A/B/A. Config/launcher never change. If interrupted, inspect errors and backup contents before proceeding; never ignore a hash failure or substitute new expected hashes.

## Manual evidence and stopping point

Follow [the existing A/B/A plan](EXPERIMENT_002_OBSERVABLE_OVERRIDE.md#offline-ab-a-test-after-archive-verification): record build, entity/map/param evidence, active config, installed hashes, conditions, duration and observed attacks/approach/recurrence. The tutorial-boss identity and native/shared interruptions remain unresolved. Only reproducible behavior switching in the same confirmed NPC establishes the experiment's in-game success.

Codex stopped after workspace staging and read-only configuration review. Installed override is still the original Experiment001 copy. No installed directory write, game launch, game-file edit, tool installation, commit or branch change occurred.
