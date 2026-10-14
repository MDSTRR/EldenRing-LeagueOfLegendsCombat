# User-run only; no game launch or configuration modification.
param([Parameter(Mandatory)][ValidateSet('Backup','Deploy','Verify','Rollback')][string]$Action,[Parameter(Mandatory)][string]$BackupDirectory)
$ErrorActionPreference='Stop'
$engine='C:\Users\creep\Documents\ModEngine-2.1.0.0-win64'
$activeRoot=Join-Path $engine 'mod';$staged=Join-Path $PSScriptRoot 'deployment/arrival-wait'
$backupRoot=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot 'modengine-backups'))+[IO.Path]::DirectorySeparatorChar
$backup=[IO.Path]::GetFullPath($BackupDirectory)
if(-not $backup.StartsWith($backupRoot,[StringComparison]::OrdinalIgnoreCase)){throw 'Backup must stay under project experiment003b/modengine-backups.'}
if(@(Get-Process -Name eldenring,start_protected_game -ErrorAction SilentlyContinue).Count){throw 'Close Elden Ring first.'}
$config=Join-Path $engine 'config_eldenring.toml';$launcher=Join-Path $engine 'launchmod_eldenring.bat'
$configHash='4C3986DF4F138B70B14089EBD862573E9855ED102A2B4E445D95187CEEA759F1'
$launcherHash='8610BF5AD06E7534C355CCB2D9CB4A336491E4E6935AE889D184CD7923E83953'
$files=@(
 [pscustomobject]@{Relative='script/431030_battle.luabnd.dcx';Expected='D9EE71C57520B597CFCD9399A899DBBE241DFF2DE505F28A07523C3044F0BFCB'},
 [pscustomobject]@{Relative='map/mapstudio/m18_00_00_00.msb.dcx';Expected='605B02422EE285ABD699107C7A24C8A49BE65DD759B5166A6E71D01AA66D79FD'})
function Hash([string]$path){(Get-FileHash -LiteralPath $path).Hash}
function RequireHash([string]$path,[string]$expected){if((Hash $path) -cne $expected){throw ('Hash mismatch: '+$path)}}
RequireHash $config $configHash;RequireHash $launcher $launcherHash
foreach($f in $files){RequireHash (Join-Path $staged $f.Relative) $f.Expected}
$manifest=Join-Path $backup 'backup-manifest.json'
$baselineHashes=@{
 'script/431030_battle.luabnd.dcx'='4CAA4E3ECEB7CE182E6AC057969817764E88AF75C3C1EFF757C0EB4A949F7F45'
 'map/mapstudio/m18_00_00_00.msb.dcx'='605B02422EE285ABD699107C7A24C8A49BE65DD759B5166A6E71D01AA66D79FD'
}
function CheckedTarget([string]$relative){
 $target=[IO.Path]::GetFullPath((Join-Path $activeRoot $relative))
 $allowed=[IO.Path]::GetFullPath($activeRoot)+[IO.Path]::DirectorySeparatorChar
 if(-not $target.StartsWith($allowed,[StringComparison]::OrdinalIgnoreCase)){throw 'Override target escaped the named ModEngine mod root.'}
 return $target
}
if($Action -eq 'Backup'){
 foreach($f in $files){RequireHash (CheckedTarget $f.Relative) $baselineHashes[$f.Relative]}
 if(Test-Path -LiteralPath $backup){throw 'Backup directory already exists.'}
 [IO.Directory]::CreateDirectory($backup)|Out-Null
 Copy-Item -LiteralPath $config -Destination (Join-Path $backup 'config_eldenring.toml')
 Copy-Item -LiteralPath $launcher -Destination (Join-Path $backup 'launchmod_eldenring.bat')
 $prior=@(foreach($f in $files){
  $target=CheckedTarget $f.Relative;$exists=Test-Path -LiteralPath $target -PathType Leaf;$hash=$null
  if($exists){$hash=Hash $target;$saved=Join-Path $backup ('original/'+$f.Relative);[IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($saved))|Out-Null;Copy-Item -LiteralPath $target -Destination $saved;RequireHash $saved $hash;RequireHash $target $hash}
  [pscustomobject]@{Relative=$f.Relative;Existed=$exists;SHA256=$hash}
 })
 RequireHash (Join-Path $backup 'config_eldenring.toml') $configHash;RequireHash (Join-Path $backup 'launchmod_eldenring.bat') $launcherHash
 [pscustomobject]@{Root=$activeRoot;ConfigSHA256=$configHash;LauncherSHA256=$launcherHash;Files=$prior;CreatedUTC=[DateTime]::UtcNow.ToString('o')}|ConvertTo-Json -Depth 5|Set-Content -LiteralPath $manifest -Encoding utf8
 Write-Output ('Backup complete: '+$backup);$prior|Format-Table -AutoSize;exit 0
}
$saved=Get-Content -LiteralPath $manifest -Raw|ConvertFrom-Json
if($saved.Root -cne $activeRoot -or $saved.ConfigSHA256 -cne $configHash -or $saved.LauncherSHA256 -cne $launcherHash -or $saved.Files.Count -ne 2){throw 'Backup manifest does not match setup.'}
RequireHash (Join-Path $backup 'config_eldenring.toml') $configHash;RequireHash (Join-Path $backup 'launchmod_eldenring.bat') $launcherHash
# Only a complete, hash-pinned Experiment003 pair is an acceptable rollback baseline.
foreach($f in $files){
 $baseline=@($saved.Files|Where-Object Relative -CEQ $f.Relative)
 if($baseline.Count -ne 1 -or -not $baseline[0].Existed -or $baseline[0].SHA256 -cne $baselineHashes[$f.Relative]){throw 'Backup is not the verified Experiment003 pair.'}
}
# Preflight BOTH files before any installed-path mutation.
foreach($f in $files){
 $prior=@($saved.Files|Where-Object Relative -CEQ $f.Relative);if($prior.Count -ne 1){throw 'Missing/duplicate backup entry.'}
 if($prior[0].Existed){RequireHash (Join-Path $backup ('original/'+$f.Relative)) $prior[0].SHA256}
 $target=CheckedTarget $f.Relative
 if(Test-Path -LiteralPath $target){$hash=Hash $target;if($hash -cne $f.Expected -and (-not $prior[0].Existed -or $hash -cne $prior[0].SHA256)){throw ('Unexpected override changed since backup: '+$target)}}
}
function Retain([string]$target){
 if(Test-Path -LiteralPath $target){$hash=Hash $target;$dest=Join-Path $backup ('retained-'+[guid]::NewGuid().ToString('N')+'.dcx');Move-Item -LiteralPath $target -Destination $dest;RequireHash $dest $hash}
}
switch($Action){
 'Deploy'{foreach($f in $files){$target=CheckedTarget $f.Relative;if((Test-Path $target) -and (Hash $target) -ceq $f.Expected){continue};Retain $target;[IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($target))|Out-Null;Copy-Item -LiteralPath (Join-Path $staged $f.Relative) -Destination $target;RequireHash $target $f.Expected};Write-Output 'Both Experiment003B overrides deployed and hash-verified.'}
 'Verify'{foreach($f in $files){$target=CheckedTarget $f.Relative;RequireHash $target $f.Expected;Get-FileHash -LiteralPath $target}}
 'Rollback'{foreach($f in $files){$prior=$saved.Files|Where-Object Relative -CEQ $f.Relative;$target=CheckedTarget $f.Relative;if($prior.Existed -and (Test-Path $target) -and (Hash $target) -ceq $prior.SHA256){continue};Retain $target;if($prior.Existed){Copy-Item -LiteralPath (Join-Path $backup ('original/'+$f.Relative)) -Destination $target;RequireHash $target $prior.SHA256}else{if(Test-Path $target){throw 'Rollback failed to restore absence.'}}};Write-Output 'Both prior overrides (or prior absence) restored; displaced copies preserved.'}
}
exit 0
