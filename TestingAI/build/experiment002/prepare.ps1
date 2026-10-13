# Run from the repository root in PowerShell 7. Uses only existing tools.
$ErrorActionPreference = 'Stop'
$repo = (Get-Location).Path
$root = Join-Path $repo 'TestingAI/build/experiment002'
$source = Join-Path $repo 'TestingAI/decompiled/431030_battle.lua'
$reference = Join-Path $repo 'TestingAI/extracted/431030_battle-luabnd-dcx'
$refs = @($source, (Join-Path $reference '431030_battle.lua'), (Join-Path $reference '431030_battle.luagnl'), (Join-Path $reference '_witchy-bnd4.xml'), (Join-Path $repo 'TestingAI/extracted/431030_battle.luabnd.dcx'))
$before = @($refs | ForEach-Object { Get-FileHash -LiteralPath $_ })
if ((Get-FileHash -LiteralPath $source).Hash -ne 'BB170E62F3D24AEFC5CC1B900BD05EB30B9433C2265C7C0404457EFC34A072A4') { throw 'Reference source differs from the reviewed version.' }
$sourceDir = Join-Path $root 'source'
$binder = Join-Path $root 'approach-only/431030_battle-luabnd-dcx'
if (Test-Path -LiteralPath (Join-Path $sourceDir '431030_battle.lua')) { throw 'Prepared source exists; refusing overwrite.' }
[IO.Directory]::CreateDirectory($sourceDir) | Out-Null
[IO.Directory]::CreateDirectory($binder) | Out-Null
[IO.Directory]::CreateDirectory((Join-Path $root 'deployment/approach-only/script')) | Out-Null
$lines = [IO.File]::ReadAllLines($source)
if ($lines[13] -ne 'Goal.Activate = function (f2_arg0, f2_arg1, f2_arg2)' -or $lines[915] -ne 'Goal.Interrupt = function (f24_arg0, f24_arg1, f24_arg2)' -or $lines[1031] -notlike 'RegisterTableGoal*AfterAttackAct*') { throw 'Callback boundaries differ.' }
$activate = @(
'Goal.Activate = function (f2_arg0, f2_arg1, f2_arg2)',
'    -- Experiment 002: bypass weighted attacks; preserve original setup.',
'    Init_Pseudo_Global(f2_arg1, f2_arg2)',
'    f2_arg1:DeleteObserveSpecialEffectAttribute(TARGET_SELF, 5025)',
'    f2_arg1:DeleteObserveSpecialEffectAttribute(TARGET_SELF, 5027)',
'    f2_arg1:DeleteObserveSpecialEffectAttribute(TARGET_SELF, 5030)',
'    f2_arg2:ClearSubGoal()',
'    -- Act13 call shape: lifetime, enemy, stop distance, facing, walk, guard.',
'    f2_arg2:AddSubGoal(GOAL_COMMON_ApproachTarget, 10, TARGET_ENE_0, 3, TARGET_SELF, true, 9910)',
'end')
$interrupt = @(
'Goal.Interrupt = function (f24_arg0, f24_arg1, f24_arg2)',
'    -- Do not enqueue this script''s interrupt attacks or retreats.',
'    -- Shared/native interrupt behavior is outside this callback.',
'    return false',
'end')
$modified = (@($lines[0..12]) + $activate + @($lines[403..914]) + $interrupt + @($lines[1030..($lines.Length-1)])) -join "`r`n"
$modified += "`r`n"
$outSource = Join-Path $sourceDir '431030_battle.lua'
[IO.File]::WriteAllText($outSource, $modified, [Text.UTF8Encoding]::new($false))
Copy-Item -LiteralPath (Join-Path $reference '431030_battle.luagnl') -Destination $binder
Copy-Item -LiteralPath (Join-Path $reference '_witchy-bnd4.xml') -Destination $binder
$runtime = Join-Path $repo 'TestingAI/build/experiment001/compiled-source/compiler-runtime'
[Reflection.Assembly]::LoadFrom((Join-Path $runtime 'LuaCompiler.dll')) | Out-Null
[Text.Encoding]::RegisterProvider([Text.CodePagesEncodingProvider]::Instance)
$compiler = [LuaCompiler.Compilers.Lua50Compiler]::new()
$compiled = $compiler.CompileSource($modified, [Text.Encoding]::GetEncoding('shift_jis'))
$outBytecode = Join-Path $binder '431030_battle.lua'
[IO.File]::WriteAllBytes($outBytecode, $compiled)
[Reflection.Assembly]::LoadFrom((Join-Path $repo 'TestingAI/tools/DSLuaDecompiler/DSLuaDecompiler/bin/Release/net9.0/LuaDecompilerCore.dll')) | Out-Null
$oldBytes = [IO.File]::ReadAllBytes((Join-Path $reference '431030_battle.lua'))
$old = [LuaDecompilerCore.LuaFile]::new([LuaDecompilerCore.Utilities.BinaryReaderEx]::new($false, $oldBytes))
$new = [LuaDecompilerCore.LuaFile]::new([LuaDecompilerCore.Utilities.BinaryReaderEx]::new($false, $compiled))
function Flatten($fn) { $fn; foreach ($child in $fn.ChildFunctions) { Flatten $child } }
$oldFns = @(Flatten $old.MainFunction)
$newFns = @(Flatten $new.MainFunction)
if ($oldFns.Count -ne 27 -or $newFns.Count -ne 27) { throw 'Function count changed.' }
function Executable($fn) {
    [ordered]@{Bytecode=[Convert]::ToBase64String($fn.Bytecode); Constants=@($fn.Constants | ForEach-Object { [ordered]@{Type=[string]$_.Type;Bool=$_.BoolValue;String=$_.StringValue;Number=$_.NumberValue;Int=$_.IntValue} }); Params=$fn.NumParams; Upvalues=$fn.NumUpValues; Vararg=$fn.IsVarArg; Stack=$fn.MaxStackSize; Children=$fn.ChildFunctions.Count} | ConvertTo-Json -Depth 12 -Compress
}
$changes = @()
for ($i=0; $i -lt 27; $i++) { if ((Executable $oldFns[$i]) -cne (Executable $newFns[$i])) { $changes += $i } }
if (($changes -join ',') -ne '2,24') { throw ('Unexpected executable changes: ' + ($changes -join ',')) }
$header = [BitConverter]::ToString($compiled[0..21])
if ($header -ne [BitConverter]::ToString($oldBytes[0..21])) { throw 'Lua header mismatch.' }
$after = @($refs | ForEach-Object { Get-FileHash -LiteralPath $_ })
for ($i=0; $i -lt $before.Count; $i++) { if ($before[$i].Hash -ne $after[$i].Hash) { throw 'Reference changed.' } }
$report = [ordered]@{Prepared=$true; ArchiveRepacked=$false; InGameTested=$false; Source=$outSource;SourceSHA256=(Get-FileHash $outSource).Hash; Bytecode=$outBytecode; BytecodeSHA256=(Get-FileHash $outBytecode).Hash; BytecodeBytes=$compiled.Length; Header=$header; FunctionCount=$newFns.Count;ChangedExecutableFunctionIndices=$changes;UnchangedExecutableFunctions=25;ReferencesUnchanged=$true;ReferenceHashes=$after;LUAGNLMatchesOriginal=((Get-FileHash (Join-Path $binder '431030_battle.luagnl')).Hash -eq (Get-FileHash (Join-Path $reference '431030_battle.luagnl')).Hash);ManifestMatchesOriginal=((Get-FileHash (Join-Path $binder '_witchy-bnd4.xml')).Hash -eq (Get-FileHash (Join-Path $reference '_witchy-bnd4.xml')).Hash)}
$report | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $root 'preparation-verification.json') -Encoding utf8
[pscustomobject]$report | Select-Object Prepared,BytecodeBytes,BytecodeSHA256,Header,ChangedExecutableFunctionIndices,ReferencesUnchanged,LUAGNLMatchesOriginal,ManifestMatchesOriginal | ConvertTo-Json
