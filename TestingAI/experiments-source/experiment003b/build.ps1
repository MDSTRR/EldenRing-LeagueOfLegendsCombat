$ErrorActionPreference = 'Stop'
$repo = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../../..'))
$root = $PSScriptRoot
$report = Join-Path $root 'build-verification.json'
if (Test-Path -LiteralPath $report) { throw 'Experiment003B report exists; refusing to overwrite.' }
function Hash([string]$path) { (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash }
function HashBytes([byte[]]$bytes) { [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($bytes)) }
function RequireHash([string]$path, [string]$expected) {
    if ((Hash $path) -cne $expected) { throw "Hash mismatch: $path" }
}
$protected = @(Get-ChildItem -LiteralPath (Join-Path $repo 'TestingAI/build/experiment001'), (Join-Path $repo 'TestingAI/build/experiment002'), (Join-Path $repo 'TestingAI/build/experiment003') -Recurse -File | ForEach-Object { Get-FileHash -LiteralPath $_.FullName })
$protected | Select-Object Path, Hash | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $root 'baseline-hashes-before.json') -Encoding utf8
$previous = Join-Path $repo 'TestingAI/build/experiment003/source/431030_battle.lua'
$previousArchive = Join-Path $repo 'TestingAI/build/experiment003/fixed-region/431030_battle.luabnd.dcx'
$priorReport = Get-Content -LiteralPath (Join-Path $repo 'TestingAI/build/experiment003/build-verification.json') -Raw | ConvertFrom-Json
RequireHash $previous $priorReport.SourceSHA256
RequireHash $previousArchive '4CAA4E3ECEB7CE182E6AC057969817764E88AF75C3C1EFF757C0EB4A949F7F45'
$map = Join-Path $repo 'TestingAI/build/experiment003/deployment/fixed-region/map/mapstudio/m18_00_00_00.msb.dcx'
$mapHash = '605B02422EE285ABD699107C7A24C8A49BE65DD759B5166A6E71D01AA66D79FD'
RequireHash $map $mapHash
$sourceDir = Join-Path $root 'source'
$binder = Join-Path $root 'arrival-wait/431030_battle-luabnd-dcx'
$verify = Join-Path $root 'verification'
$deploy = Join-Path $root 'deployment/arrival-wait'
foreach ($directory in @($sourceDir, $binder, $verify, $deploy)) {
    if (Test-Path -LiteralPath $directory) { throw "Output already exists: $directory" }
    [IO.Directory]::CreateDirectory($directory) | Out-Null
}
$text = [IO.File]::ReadAllText($previous)
$oldActivate = '    f2_arg1:SetEventMoveTarget(67676767)'
if ([regex]::Matches($text, [regex]::Escape($oldActivate)).Count -ne 1) { throw 'Expected one Activate region setter.' }
$text = $text.Replace($oldActivate, "    -- Parent-goal slot 0: MOVING=0, ARRIVED=1, WAITING=2, INCOMPLETE_HOLD=3.`r`n    f2_arg2:SetNumber(0, 0)`r`n" + $oldActivate)
$updatePattern = '(?s)Goal\.Update = function \(f22_arg0, f22_arg1, f22_arg2\).*?\r?\nend'
if ([regex]::Matches($text, $updatePattern).Count -ne 1) { throw 'Expected exactly one main Update callback.' }
$newUpdate = @'
Goal.Update = function (f22_arg0, f22_arg1, f22_arg2)
    -- Keep this battle goal active; never infer arrival from queue exhaustion.
    local state = f22_arg2:GetNumber(0)
    if state == 0 and f22_arg1:GetDist(POINT_EVENT) <= 0.5 then
        f22_arg2:ClearSubGoal()
        f22_arg2:SetNumber(0, 1)
        state = 1
    end
    if state == 1 then
        f22_arg2:AddSubGoal(GOAL_COMMON_Wait, 1, TARGET_SELF)
        f22_arg2:SetNumber(0, 2)
    elseif f22_arg2:GetSubGoalNum() <= 0 then
        if state == 0 then
            -- Approach ended away from the point: hold without claiming arrival.
            f22_arg2:SetNumber(0, 3)
        end
        f22_arg2:AddSubGoal(GOAL_COMMON_Wait, 1, TARGET_SELF)
    end
    -- A later validated command reader can run here even while waiting.
    -- No command transport or new destination is implemented in 003B.
    return GOAL_RESULT_Continue
end
'@
$newUpdate = $newUpdate.Replace("`r`n", "`n").Replace("`n", "`r`n")
$text = [regex]::Replace($text, $updatePattern, [Text.RegularExpressions.MatchEvaluator]{ param($match) $newUpdate })
$text = $text.Replace('-- Experiment 003: fixed region; retain Experiment 002 combat isolation.', '-- Experiment 003B: retain the verified approach; hold after arrival.')
$source = Join-Path $sourceDir '431030_battle.lua'
[IO.File]::WriteAllText($source, $text, [Text.UTF8Encoding]::new($false))
[Text.Encoding]::RegisterProvider([Text.CodePagesEncodingProvider]::Instance)
$runtime = Join-Path $repo 'TestingAI/build/experiment001/compiled-source/compiler-runtime'
[Reflection.Assembly]::LoadFrom((Join-Path $runtime 'LuaCompiler.dll')) | Out-Null
$bytes = [LuaCompiler.Compilers.Lua50Compiler]::new().CompileSource($text, [Text.Encoding]::GetEncoding('shift_jis'))
[IO.File]::WriteAllBytes((Join-Path $binder '431030_battle.lua'), $bytes)
[Runtime.InteropServices.NativeLibrary]::Load((Join-Path $repo 'TestingAI/build/experiment001/witchy-runtime/oo2core_6_win64.dll')) | Out-Null
[Reflection.Assembly]::LoadFrom((Join-Path $repo 'TestingAI/tools/DSLuaDecompiler/SoulsFormats/SoulsFormats/bin/Release/netstandard2.1/SoulsFormats.dll')) | Out-Null
[Reflection.Assembly]::LoadFrom((Join-Path $repo 'TestingAI/tools/DSLuaDecompiler/DSLuaDecompiler/bin/Release/net9.0/LuaDecompilerCore.dll')) | Out-Null
$baseline = [SoulsFormats.BND4]::Read($previousArchive)
if ($baseline.Files.Count -ne 2) { throw 'Unexpected baseline binder entries.' }
$oldLua = ($baseline.Files | Where-Object ID -EQ 1000).Bytes
if ((HashBytes $oldLua) -cne 'D1760630C35B883A70080E60418A9DFF6326B421A60A90229756844A5D314D3E') { throw 'Baseline003 Lua differs.' }
$luagnl = ($baseline.Files | Where-Object ID -EQ 1000000).Bytes
if ((HashBytes $luagnl) -cne '2A00F44377EB2DE66364FD08FE53E7048ED6F5BC9C9D4C59A5EEC2B8142DD8CC') { throw 'LUAGNL differs.' }
[IO.File]::WriteAllBytes((Join-Path $binder '431030_battle.luagnl'), $luagnl)
Copy-Item -LiteralPath (Join-Path $repo 'TestingAI/build/experiment003/fixed-region/431030_battle-luabnd-dcx/_witchy-bnd4.xml') -Destination $binder
function CompareBinder($value, [string]$luaHash) {
    if ($value.Files.Count -ne 2 -or @($value.Files | Where-Object ID -EQ 1000).Count -ne 1 -or @($value.Files | Where-Object ID -EQ 1000000).Count -ne 1) { throw 'Entry IDs/count differ.' }
    foreach ($key in @('Version', 'Format', 'BigEndian', 'BitBigEndian', 'Unicode', 'Extended', 'Unk04', 'Unk05', 'Compression')) {
        if ([string]$value.$key -cne [string]$baseline.$key) { throw "Binder metadata differs: $key" }
    }
    foreach ($entry in $value.Files) {
        $reference = $baseline.Files | Where-Object ID -EQ $entry.ID
        if ($entry.Name -cne $reference.Name -or $entry.Flags -ne $reference.Flags -or $entry.CompressionType -ne $reference.CompressionType) { throw 'Entry metadata differs.' }
        $expected = if ($entry.ID -eq 1000) { $luaHash } else { HashBytes $luagnl }
        if ((HashBytes $entry.Bytes) -cne $expected) { throw 'Payload readback mismatch.' }
    }
}
$control = Join-Path $verify 'unchanged-writer-control.luabnd.dcx'
$baseline.Write($control)
CompareBinder ([SoulsFormats.BND4]::Read($control)) (HashBytes $oldLua)
$rebuilt = [SoulsFormats.BND4]::Read($previousArchive)
($rebuilt.Files | Where-Object ID -EQ 1000).Bytes = $bytes
$archive = Join-Path $root 'arrival-wait/431030_battle.luabnd.dcx'
$rebuilt.Write($archive)
$readback = [SoulsFormats.BND4]::Read($archive)
CompareBinder $readback (HashBytes $bytes)
foreach ($entry in $readback.Files) { [IO.File]::WriteAllBytes((Join-Path $verify ([IO.Path]::GetFileName($entry.Name))), $entry.Bytes) }
function Parse([byte[]]$value) { [LuaDecompilerCore.LuaFile]::new([LuaDecompilerCore.Utilities.BinaryReaderEx]::new($false, $value)) }
function Flat($fn) { $fn; foreach ($child in $fn.ChildFunctions) { Flat $child } }
function Executable($fn) {
    [ordered]@{ Code = [Convert]::ToBase64String($fn.Bytecode); Constants = @($fn.Constants | ForEach-Object { [ordered]@{ Type = [string]$_.Type; Bool = $_.BoolValue; String = $_.StringValue; Number = $_.NumberValue; Int = $_.IntValue } }); Params = $fn.NumParams; Upvalues = $fn.NumUpValues; Vararg = $fn.IsVarArg; Stack = $fn.MaxStackSize; Children = $fn.ChildFunctions.Count } | ConvertTo-Json -Depth 9 -Compress
}
$oldFns = @(Flat (Parse $oldLua).MainFunction)
$newFns = @(Flat (Parse $bytes).MainFunction)
if ($oldFns.Count -ne 27 -or $newFns.Count -ne 27) { throw 'Function count changed.' }
$delta = @(for ($i = 0; $i -lt 27; $i++) { if ((Executable $oldFns[$i]) -cne (Executable $newFns[$i])) { $i } })
if (($delta -join ',') -cne '2,22') { throw "Unexpected executable delta: $delta" }
if ([BitConverter]::ToString($bytes[0..21]) -cne [BitConverter]::ToString($oldLua[0..21])) { throw 'Lua5.0 header mismatch.' }
$nameSize = [BitConverter]::ToUInt64($bytes, 22)
if ([Text.Encoding]::GetEncoding('shift_jis').GetString($bytes, 30, [int]$nameSize - 1) -cne $text) { throw 'Embedded source mismatch.' }
$callbackEvidence = @(foreach ($index in @(2, 22)) {
    $fn = $newFns[$index]
    [pscustomobject]@{ FunctionIndex = $index; BytecodeSHA256 = HashBytes $fn.Bytecode; Executable = (Executable $fn | ConvertFrom-Json) }
})
$callbackEvidence | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath (Join-Path $verify 'changed-callbacks.json') -Encoding utf8
foreach ($reference in $protected) { RequireHash $reference.Path $reference.Hash }
RequireHash $map $mapHash
[IO.Directory]::CreateDirectory((Join-Path $deploy 'script')) | Out-Null
[IO.Directory]::CreateDirectory((Join-Path $deploy 'map/mapstudio')) | Out-Null
Copy-Item -LiteralPath $archive -Destination (Join-Path $deploy 'script/431030_battle.luabnd.dcx')
Copy-Item -LiteralPath $map -Destination (Join-Path $deploy 'map/mapstudio/m18_00_00_00.msb.dcx')
RequireHash (Join-Path $deploy 'script/431030_battle.luabnd.dcx') (Hash $archive)
RequireHash (Join-Path $deploy 'map/mapstudio/m18_00_00_00.msb.dcx') $mapHash
$result = [pscustomobject]@{
    Passed = $true; Source = $source; SourceSHA256 = Hash $source; BytecodeBytes = $bytes.Length; BytecodeSHA256 = HashBytes $bytes
    Archive = $archive; ArchiveBytes = (Get-Item -LiteralPath $archive).Length; ArchiveSHA256 = Hash $archive; MapSHA256 = $mapHash
    FunctionCount = 27; ChangedFromExperiment003 = $delta; UnchangedExecutableFunctions = 25
    HeaderVerified = $true; EmbeddedSourceVerified = $true; BinderAndPayloadReadbackVerified = $true; UnchangedWriterControlVerified = $true
    LUAGNLUnchanged = $true; BaselineFilesPreserved = $protected.Count; StagedRoot = $deploy; LiveInstallationModified = $false; InGameTested = $false
    CommandReceptionImplemented = $false; States = @{ MOVING = 0; ARRIVED = 1; WAITING = 2; INCOMPLETE_HOLD = 3 }
    Files = @([pscustomobject]@{ RelativePath = 'script/431030_battle.luabnd.dcx'; SHA256 = Hash $archive }, [pscustomobject]@{ RelativePath = 'map/mapstudio/m18_00_00_00.msb.dcx'; SHA256 = $mapHash })
}
$result | ConvertTo-Json -Depth 7 | Set-Content -LiteralPath $report -Encoding utf8
$result | Select-Object Passed, BytecodeBytes, BytecodeSHA256, ArchiveBytes, ArchiveSHA256, ChangedFromExperiment003, BaselineFilesPreserved, StagedRoot, InGameTested | ConvertTo-Json -Depth 4
