# Run only AFTER interactive repacking. No external installation/config writes.
param([string]$ArchiveFile = 'TestingAI/build/experiment002/approach-only/431030_battle.luabnd.dcx')
$ErrorActionPreference = 'Stop'
$repo = (Get-Location).Path
$root = Join-Path $repo 'TestingAI/build/experiment002'
$archive = [IO.Path]::GetFullPath((Join-Path $repo $ArchiveFile))
if (-not (Test-Path -LiteralPath $archive -PathType Leaf)) { throw ('Missing repacked archive: ' + $archive) }
$prep = Get-Content -LiteralPath (Join-Path $root 'preparation-verification.json') -Raw | ConvertFrom-Json
[Runtime.InteropServices.NativeLibrary]::Load((Join-Path $repo 'TestingAI/build/experiment001/witchy-runtime/oo2core_6_win64.dll')) | Out-Null
[Reflection.Assembly]::LoadFrom((Join-Path $repo 'TestingAI/tools/DSLuaDecompiler/SoulsFormats/SoulsFormats/bin/Release/netstandard2.1/SoulsFormats.dll')) | Out-Null
$baseline = [SoulsFormats.BND4]::Read((Join-Path $repo 'TestingAI/build/experiment001/unchanged-bytecode/431030_battle.luabnd.dcx'))
$rebuilt = [SoulsFormats.BND4]::Read($archive)
function HashBytes([byte[]]$bytes) { [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($bytes)) }
$verification = Join-Path $root ('verification-' + [DateTime]::UtcNow.ToString('yyyyMMdd-HHmmss-fffffff'))
[IO.Directory]::CreateDirectory($verification) | Out-Null
$metadata = @(foreach ($key in @('Version','Format','BigEndian','BitBigEndian','Unicode','Extended','Unk04','Unk05','Compression')) {
    [pscustomobject]@{Field=$key; Value=[string]$rebuilt.$key; MatchesBaseline=([string]$rebuilt.$key -ceq [string]$baseline.$key)}
})
$entries = @(foreach ($entry in $rebuilt.Files) {
    $original = @($baseline.Files | Where-Object ID -EQ $entry.ID)
    $name = [IO.Path]::GetFileName($entry.Name)
    if ($name -notin @('431030_battle.lua','431030_battle.luagnl')) { throw 'Unexpected binder filename.' }
    [IO.File]::WriteAllBytes((Join-Path $verification $name), $entry.Bytes)
    $hash = HashBytes $entry.Bytes
    $expectedHash = if ($entry.ID -eq 1000) { $prep.BytecodeSHA256 } else { '2A00F44377EB2DE66364FD08FE53E7048ED6F5BC9C9D4C59A5EEC2B8142DD8CC' }
    [pscustomobject]@{ID=$entry.ID;Name=$entry.Name;Flags=[string]$entry.Flags;CompressionType=[string]$entry.CompressionType;Bytes=$entry.Bytes.Length;SHA256=$hash;PayloadMatchesExpected=($hash -ceq $expectedHash); MetadataMatchesBaseline=($original.Count -eq 1 -and $entry.Name -ceq $original[0].Name -and $entry.Flags -eq $original[0].Flags -and $entry.CompressionType -eq $original[0].CompressionType)}
})
$passed = $rebuilt.Files.Count -eq 2 -and @($rebuilt.Files | Where-Object ID -EQ 1000).Count -eq 1 -and @($rebuilt.Files | Where-Object ID -EQ 1000000).Count -eq 1 -and @($metadata | Where-Object MatchesBaseline -EQ $false).Count -eq 0 -and @($entries | Where-Object { -not $_.PayloadMatchesExpected -or -not $_.MetadataMatchesBaseline }).Count -eq 0
foreach ($ref in $prep.ReferenceHashes) { if ((Get-FileHash -LiteralPath $ref.Path).Hash -cne $ref.Hash) { throw ('Reference changed: ' + $ref.Path) } }
$result = [ordered]@{Passed=$passed;Archive=$archive;ArchiveBytes=(Get-Item -LiteralPath $archive).Length;ArchiveSHA256=(Get-FileHash -LiteralPath $archive).Hash;ExtractionDirectory=$verification;Entries=$entries;Metadata=$metadata;ReferencesUnchanged=$true;InGameTested=$false}
$result | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $verification 'archive-verification.json') -Encoding utf8
if (-not $passed) { throw ('Archive verification failed. No override staged. See ' + $verification) }
$destination = Join-Path $root 'deployment/approach-only/script/431030_battle.luabnd.dcx'
if (Test-Path -LiteralPath $destination) { throw 'Staged override already exists; refusing overwrite.' }
Copy-Item -LiteralPath $archive -Destination $destination
if ((Get-FileHash -LiteralPath $destination).Hash -cne $result.ArchiveSHA256) { throw 'Staged copy hash differs.' }
Write-Output ('Verified and staged inactive workspace override: ' + $destination)
Write-Output ('Evidence: ' + (Join-Path $verification 'archive-verification.json'))
