# Run from repository root. Uses existing compiler; never edits reference files.
param([string]$OutputFile = 'TestingAI/build/experiment001/compiled-source/recompiled-again.lua')
$ErrorActionPreference = 'Stop'
$repositoryRoot = (Get-Location).Path
$outputPath = [IO.Path]::GetFullPath((Join-Path $repositoryRoot $OutputFile))
$allowedRoot = [IO.Path]::GetFullPath((Join-Path $repositoryRoot 'TestingAI/build/experiment001')) + [IO.Path]::DirectorySeparatorChar
if (-not $outputPath.StartsWith($allowedRoot, [StringComparison]::OrdinalIgnoreCase)) { throw 'Output must remain inside the experiment directory.' }
if (Test-Path -LiteralPath $outputPath) { throw 'Output exists; choose a new output file.' }
$compilerRuntime = Join-Path $repositoryRoot 'TestingAI/build/experiment001/compiled-source/compiler-runtime'
[Reflection.Assembly]::LoadFrom((Join-Path $compilerRuntime 'LuaCompiler.dll')) | Out-Null
[Text.Encoding]::RegisterProvider([Text.CodePagesEncodingProvider]::Instance)
$sourcePath = Join-Path $repositoryRoot 'TestingAI/decompiled/431030_battle.lua'
$sourceText = [IO.File]::ReadAllText($sourcePath)
$compiler = [LuaCompiler.Compilers.Lua50Compiler]::new()
$compiledBytes = $compiler.CompileSource($sourceText, [Text.Encoding]::GetEncoding('shift_jis'))
[IO.File]::WriteAllBytes($outputPath, $compiledBytes)
Get-FileHash -LiteralPath $outputPath
Write-Output ('Bytes: ' + $compiledBytes.Length)
Write-Output ('Header: ' + [BitConverter]::ToString($compiledBytes[0..21]))
