$ErrorActionPreference = 'Stop'
$repo = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../../..'))
$source = Join-Path $PSScriptRoot 'source/431030_battle.lua'
$text = [IO.File]::ReadAllText($source)
$activate = [regex]::Match($text, '(?s)Goal\.Activate = function \(f2_arg0, f2_arg1, f2_arg2\).*?\r?\nend').Value
$update = [regex]::Match($text, '(?s)Goal\.Update = function \(f22_arg0, f22_arg1, f22_arg2\).*?\r?\nend').Value
if (-not $activate -or -not $update) { throw 'Changed callbacks were not found.' }
$fixture = @'
Goal = {}
POINT_EVENT = 102
TARGET_SELF = -1
GOAL_COMMON_Wait = 2000
GOAL_COMMON_ApproachTarget = 2015
GOAL_RESULT_Continue = 0
function check(value)
    if not value then local bad = nil; bad() end
end
function Init_Pseudo_Global(ai, goal) end
function makeAI(distance)
    local ai = {distance = distance, region = 0}
    function ai:DeleteObserveSpecialEffectAttribute(target, effect) end
    function ai:SetEventMoveTarget(region) self.region = region end
    function ai:GetDist(target) check(target == POINT_EVENT); return self.distance end
    return ai
end
function makeGoal(state, count)
    local goal = {state = state, count = count, clears = 0, added = 0}
    function goal:GetNumber(index) check(index == 0); return self.state end
    function goal:SetNumber(index, value) check(index == 0); self.state = value end
    function goal:GetSubGoalNum() return self.count end
    function goal:ClearSubGoal() self.count = 0; self.clears = self.clears + 1 end
    function goal:AddSubGoal(id, life, target, stop, turn, walk, guard)
        self.count = self.count + 1
        self.added = self.added + 1
        self.id = id; self.life = life; self.target = target
        self.stop = stop; self.turn = turn; self.walk = walk; self.guard = guard
    end
    return goal
end
'@
$cases = @'
-- These run the actual changed Lua callbacks against API mocks, not engine code.
local ai = makeAI(4)
local goal = makeGoal(99, 3)
Goal.Activate(Goal, ai, goal)
check(goal.state == 0 and ai.region == 67676767 and goal.count == 1)
check(goal.id == GOAL_COMMON_ApproachTarget and goal.life == 10)
check(goal.target == POINT_EVENT and goal.stop == 0.5 and goal.walk == true and goal.guard == 9910)

goal = makeGoal(0, 1)
check(Goal.Update(Goal, ai, goal) == GOAL_RESULT_Continue)
check(goal.state == 0 and goal.added == 0 and goal.clears == 0)

ai.distance = 0.4
check(Goal.Update(Goal, ai, goal) == GOAL_RESULT_Continue)
check(goal.state == 2 and goal.clears == 1 and goal.count == 1)
check(goal.id == GOAL_COMMON_Wait and goal.life == 1 and goal.target == TARGET_SELF)

goal.count = 0
check(Goal.Update(Goal, ai, goal) == GOAL_RESULT_Continue)
check(goal.state == 2 and goal.count == 1 and goal.id == GOAL_COMMON_Wait)

-- Queue completion outside arrival tolerance must not falsely report ARRIVED.
ai.distance = 4
goal = makeGoal(0, 0)
check(Goal.Update(Goal, ai, goal) == GOAL_RESULT_Continue)
check(goal.state == 3 and goal.id == GOAL_COMMON_Wait and goal.clears == 0)

-- WAITING is latched; increased distance alone is not a new command.
goal = makeGoal(2, 0)
check(Goal.Update(Goal, ai, goal) == GOAL_RESULT_Continue)
check(goal.state == 2 and goal.id == GOAL_COMMON_Wait)
return 6
'@
$testSource = $fixture + "`n" + $activate + "`n" + $update + "`n" + $cases
$luaFile = Join-Path $PSScriptRoot 'verification/callback-mock-tests.lua'
[IO.File]::WriteAllText($luaFile, $testSource, [Text.UTF8Encoding]::new($false))
$dll = Join-Path $repo 'TestingAI/build/experiment001/compiled-source/compiler-runtime/LuaNative/lua502.dll'
$escaped = $dll.Replace('\', '\\')
$wrapper = @"
using System;
using System.Runtime.InteropServices;
public static class Experiment003BMockVM {
    [DllImport("$escaped", CallingConvention=CallingConvention.Cdecl)] public static extern IntPtr lua_open();
    [DllImport("$escaped", CallingConvention=CallingConvention.Cdecl)] public static extern void lua_close(IntPtr state);
    [DllImport("$escaped", CallingConvention=CallingConvention.Cdecl)] public static extern int luaL_loadbuffer(IntPtr state, byte[] bytes, UIntPtr length, string name);
    [DllImport("$escaped", CallingConvention=CallingConvention.Cdecl)] public static extern int lua_pcall(IntPtr state, int args, int results, int err);
    [DllImport("$escaped", CallingConvention=CallingConvention.Cdecl)] public static extern IntPtr lua_tostring(IntPtr state, int index);
    [DllImport("$escaped", CallingConvention=CallingConvention.Cdecl)] public static extern double lua_tonumber(IntPtr state, int index);
}
"@
Add-Type -TypeDefinition $wrapper
$state = [Experiment003BMockVM]::lua_open()
if ($state -eq [IntPtr]::Zero) { throw 'Mock Lua VM initialization failed.' }
try {
    $bytes = [Text.Encoding]::UTF8.GetBytes($testSource)
    $status = [Experiment003BMockVM]::luaL_loadbuffer($state, $bytes, [UIntPtr]$bytes.Length, 'experiment003b-callback-tests')
    if ($status -eq 0) { $status = [Experiment003BMockVM]::lua_pcall($state, 0, 1, 0) }
    if ($status -ne 0) { throw [Runtime.InteropServices.Marshal]::PtrToStringUTF8([Experiment003BMockVM]::lua_tostring($state, -1)) }
    $passed = [Experiment003BMockVM]::lua_tonumber($state, -1)
    if ($passed -ne 6) { throw 'Unexpected mock test result.' }
    [pscustomobject]@{ Passed = $true; Cases = 6; VM = 'Existing Lua5.0.2 toolchain runtime'; ActualChangedCallbacksExecuted = $true; EngineAPIsMocked = $true; InGameTested = $false; CasesCovered = @('baseline approach preserved', 'moving remains active', 'arrival clears movement and waits', 'wait renewal', 'incomplete approach holds without false arrival', 'waiting does not auto-reapproach'); SourceSHA256 = (Get-FileHash -LiteralPath $source).Hash; TestSourceSHA256 = (Get-FileHash -LiteralPath $luaFile).Hash } | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $PSScriptRoot 'verification/callback-mock-tests.json') -Encoding utf8
    Write-Output 'Six actual-Lua callback tests passed with mocked engine APIs; no gameplay verification.'
} finally {
    [Experiment003BMockVM]::lua_close($state)
}
