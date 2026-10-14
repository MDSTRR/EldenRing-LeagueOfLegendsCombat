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
Goal.Activate = function (f2_arg0, f2_arg1, f2_arg2)
    -- Experiment 003B: retain the verified approach; hold after arrival.
    Init_Pseudo_Global(f2_arg1, f2_arg2)
    f2_arg1:DeleteObserveSpecialEffectAttribute(TARGET_SELF, 5025)
    f2_arg1:DeleteObserveSpecialEffectAttribute(TARGET_SELF, 5027)
    f2_arg1:DeleteObserveSpecialEffectAttribute(TARGET_SELF, 5030)
    f2_arg2:ClearSubGoal()
    -- POINT_EVENT resolves the saved map region; compatibility is the test hypothesis.
    -- Parent-goal slot 0: MOVING=0, ARRIVED=1, WAITING=2, INCOMPLETE_HOLD=3.
    f2_arg2:SetNumber(0, 0)
    f2_arg1:SetEventMoveTarget(67676767)
    f2_arg2:AddSubGoal(GOAL_COMMON_ApproachTarget, 10, POINT_EVENT, 0.5, TARGET_SELF, true, 9910)
end
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