RegisterTableGoal(GOAL_RoamArmySpearmen431030_Battle, "RoamArmySpearmen431030_Battle")
REGISTER_GOAL_NO_SUB_GOAL(GOAL_RoamArmySpearmen431030_Battle, true)

Goal.Initialize = function (f1_arg0, f1_arg1, f1_arg2, f1_arg3)
    f1_arg1:EnableUnfavorableAttackCheck(4, 3001)
    f1_arg1:EnableUnfavorableAttackCheck(4, 3002)
    f1_arg1:EnableUnfavorableAttackCheck(4, 3100)
    f1_arg1:EnableUnfavorableAttackCheck(4, 3101)
    f1_arg1:EnableUnfavorableAttackCheck(4, 3102)
    f1_arg1:EnableUnfavorableAttackCheck(4, 3103)
    
end

Goal.Activate = function (f2_arg0, f2_arg1, f2_arg2)
    -- Experiment 002: bypass weighted attacks; preserve original setup.
    Init_Pseudo_Global(f2_arg1, f2_arg2)
    f2_arg1:DeleteObserveSpecialEffectAttribute(TARGET_SELF, 5025)
    f2_arg1:DeleteObserveSpecialEffectAttribute(TARGET_SELF, 5027)
    f2_arg1:DeleteObserveSpecialEffectAttribute(TARGET_SELF, 5030)
    f2_arg2:ClearSubGoal()
    -- Act13 call shape: lifetime, enemy, stop distance, facing, walk, guard.
    f2_arg2:AddSubGoal(GOAL_COMMON_ApproachTarget, 10, TARGET_ENE_0, 3, TARGET_SELF, true, 9910)
end

function RoamArmySpearmen431030_Act01(f3_arg0, f3_arg1, f3_arg2)
    local f3_local0 = f3_arg0:GetDist(TARGET_ENE_0)
    local f3_local1 = f3_arg0:GetDist(TARGET_ENE_0)
    local f3_local2 = f3_arg0:GetDist(TARGET_ENE_0)
    local f3_local3 = 1.5
    local f3_local4 = 0
    local f3_local5 = 999
    local f3_local6 = 100
    local f3_local7 = 100
    local f3_local8 = 3
    local f3_local9 = 3
    if f3_arg0:HasSpecialEffectId(TARGET_SELF, 13282) then
        f3_local4 = 100
        f3_local5 = 999
        f3_local6 = 0
        f3_local8 = 5
        f3_local9 = 0
    end
    Approach_Act_Flex(f3_arg0, f3_arg1, f3_local3, f3_local4, f3_local5, f3_local6, f3_local7, f3_local8, f3_local9)
    local f3_local10 = 5
    local f3_local11 = 3102
    local f3_local12 = 6011
    local f3_local13 = 3100
    local f3_local14 = TARGET_ENE_0
    local f3_local15 = 2.5
    local f3_local16 = 1.5
    local f3_local17 = 3
    local f3_local18 = 0
    local f3_local19 = 0
    local f3_local20 = 0
    f3_arg0:AddObserveSpecialEffectAttribute(TARGET_SELF, 13058)
    f3_arg1:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, f3_local10, f3_local11, f3_local14, f3_local15, 0, 0, 0)
    f3_arg1:AddSubGoal(GOAL_COMMON_ComboRepeat, f3_local10, f3_local12, f3_local14, f3_local16, 0, 0, 0)
    f3_arg1:AddSubGoal(GOAL_COMMON_ComboRepeat, f3_local10, f3_local13, f3_local14, f3_local17, 0, 0, 0)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function RoamArmySpearmen431030_Act02(f4_arg0, f4_arg1, f4_arg2)
    local f4_local0 = f4_arg0:GetDist(TARGET_ENE_0)
    if f4_local0 >= 3.2 then
        local f4_local1 = 3.2
        local f4_local2 = 0
        local f4_local3 = 999
        local f4_local4 = 100
        local f4_local5 = 100
        local f4_local6 = 0
        local f4_local7 = 3
        if f4_arg0:HasSpecialEffectId(TARGET_SELF, 13282) then
            f4_local2 = 100
            f4_local3 = 999
            f4_local4 = 0
            f4_local6 = 5
            f4_local7 = 0
        end
        Approach_Act_Flex(f4_arg0, f4_arg1, f4_local1, f4_local2, f4_local3, f4_local4, f4_local5, f4_local6, f4_local7)
    else
        local f4_local1 = f4_arg0:GetRandam_Int(1, 3)
        local f4_local2 = TARGET_ENE_0
        local f4_local3 = 3.2
        local f4_local4 = TARGET_ENE_0
        local f4_local5 = true
        local f4_local6 = f4_arg0:GetDist(TARGET_ENE_0)
        local f4_local7 = 100
        local f4_local8 = f4_arg0:GetRandam_Int(1, 100)
        local f4_local9 = -1
        if f4_local8 <= f4_local7 then
            f4_local9 = 9910
        end
        f4_arg1:AddSubGoal(GOAL_COMMON_LeaveTarget, f4_local1, f4_local2, f4_local3, f4_local4, f4_local5, f4_local9, resultTypeIfGuardSuccess, isLifeSuccessGuard)
    end
    local f4_local1 = 5
    local f4_local2 = 3100
    local f4_local3 = TARGET_ENE_0
    local f4_local4 = 5
    local f4_local5 = 0
    local f4_local6 = 0
    local f4_local7 = 0
    f4_arg0:AddObserveSpecialEffectAttribute(TARGET_SELF, 5030)
    f4_arg0:AddObserveSpecialEffectAttribute(TARGET_SELF, 13066)
    f4_arg0:AddObserveSpecialEffectAttribute(TARGET_ENE_0, 13067)
    f4_arg1:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, f4_local1, f4_local2, f4_local3, f4_local4, 0, 0, 0)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function RoamArmySpearmen431030_Act03(f5_arg0, f5_arg1, f5_arg2)
    local f5_local0 = f5_arg0:GetDist(TARGET_ENE_0)
    if f5_local0 >= 3.2 then
        local f5_local1 = 3.2
        local f5_local2 = 0
        local f5_local3 = 999
        local f5_local4 = 100
        local f5_local5 = 100
        local f5_local6 = 0
        local f5_local7 = 3
        if f5_arg0:HasSpecialEffectId(TARGET_SELF, 13282) then
            f5_local2 = 100
            f5_local3 = 999
            f5_local4 = 0
            f5_local6 = 5
            f5_local7 = 0
            isWalk = true
        end
        Approach_Act_Flex(f5_arg0, f5_arg1, f5_local1, f5_local2, f5_local3, f5_local4, f5_local5, f5_local6, f5_local7)
    else
        local f5_local1 = f5_arg0:GetRandam_Int(1, 3)
        local f5_local2 = TARGET_ENE_0
        local f5_local3 = 3.2
        local f5_local4 = TARGET_ENE_0
        local f5_local5 = true
        local f5_local6 = f5_arg0:GetDist(TARGET_ENE_0)
        local f5_local7 = 100
        local f5_local8 = f5_arg0:GetRandam_Int(1, 100)
        local f5_local9 = -1
        if f5_local8 <= f5_local7 then
            f5_local9 = 9910
        end
        f5_arg1:AddSubGoal(GOAL_COMMON_LeaveTarget, f5_local1, f5_local2, f5_local3, f5_local4, f5_local5, f5_local9, resultTypeIfGuardSuccess, isLifeSuccessGuard)
    end
    local f5_local1 = 5
    local f5_local2 = 3103
    local f5_local3 = TARGET_ENE_0
    local f5_local4 = 5
    local f5_local5 = 0
    local f5_local6 = 0
    local f5_local7 = 0
    f5_arg0:AddObserveSpecialEffectAttribute(TARGET_SELF, 5030)
    f5_arg0:AddObserveSpecialEffectAttribute(TARGET_SELF, 13066)
    f5_arg0:AddObserveSpecialEffectAttribute(TARGET_ENE_0, 13068)
    f5_arg1:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, f5_local1, f5_local2, f5_local3, f5_local4, 0, 0, 0)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function RoamArmySpearmen431030_Act13(f6_arg0, f6_arg1, f6_arg2)
    local f6_local0 = 10
    local f6_local1 = TARGET_ENE_0
    local f6_local2 = 3
    local f6_local3 = TARGET_SELF
    local f6_local4 = false
    local f6_local5 = f6_arg0:GetDist(TARGET_ENE_0)
    if f6_arg0:HasSpecialEffectId(TARGET_SELF, 13282) then
        ForceWalkDist = 100
        ForceRunDist = 999
        Odds_Run = 0
        WalkLife = 5
        RunLife = 0
        f6_local4 = true
    end
    local f6_local6 = 100
    local f6_local7 = f6_arg0:GetRandam_Int(1, 100)
    local f6_local8 = -1
    if f6_local7 <= f6_local6 then
        f6_local8 = 9910
    end
    f6_arg1:AddSubGoal(GOAL_COMMON_ApproachTarget, f6_local0, f6_local1, f6_local2, f6_local3, f6_local4, f6_local8)
    
end

function RoamArmySpearmen431030_Act14(f7_arg0, f7_arg1, f7_arg2)
    local f7_local0 = f7_arg0:GetRandam_Int(1, 3)
    local f7_local1 = TARGET_ENE_0
    local f7_local2 = f7_arg0:GetRandam_Int(0, 1)
    local f7_local3 = 180
    local f7_local4 = 0
    local f7_local5 = TARGET_SELF
    local f7_local6 = true
    local f7_local7 = false
    local f7_local8 = f7_arg0:GetDist(TARGET_ENE_0)
    local f7_local9 = 100
    local f7_local10 = f7_arg0:GetRandam_Int(1, 100)
    local f7_local11 = -1
    if f7_local10 <= f7_local9 then
        f7_local11 = 9910
    end
    f7_arg1:AddSubGoal(GOAL_COMMON_SidewayMove, f7_local0, f7_local1, f7_local2, f7_local3, f7_local6, f7_local7, f7_local11)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function RoamArmySpearmen431030_Act15(f8_arg0, f8_arg1, f8_arg2)
    local f8_local0 = f8_arg0:GetRandam_Int(1, 3)
    local f8_local1 = TARGET_ENE_0
    local f8_local2 = f8_arg0:GetRandam_Int(0, 1)
    local f8_local3 = 180
    local f8_local4 = 0
    local f8_local5 = TARGET_SELF
    local f8_local6 = true
    local f8_local7 = false
    local f8_local8 = f8_arg0:GetDist(TARGET_ENE_0)
    local f8_local9 = 100
    local f8_local10 = f8_arg0:GetRandam_Int(1, 100)
    local f8_local11 = -1
    if f8_local10 <= f8_local9 then
        f8_local11 = 9920
    end
    f8_arg0:AddObserveSpecialEffectAttribute(TARGET_SELF, 13060)
    f8_arg1:AddSubGoal(GOAL_COMMON_ApproachTarget, f8_local0, f8_local1, f8_local4, f8_local5, f8_local6, f8_local11):SetTargetRange(1, 6, 7)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function RoamArmySpearmen431030_Act16(f9_arg0, f9_arg1, f9_arg2)
    local f9_local0 = f9_arg0:GetRandam_Int(1, 3)
    local f9_local1 = TARGET_ENE_0
    local f9_local2 = f9_arg0:GetRandam_Int(0, 1)
    local f9_local3 = 180
    local f9_local4 = 0
    local f9_local5 = TARGET_SELF
    local f9_local6 = true
    local f9_local7 = false
    local f9_local8 = f9_arg0:GetDist(TARGET_ENE_0)
    local f9_local9 = 100
    local f9_local10 = f9_arg0:GetRandam_Int(1, 100)
    local f9_local11 = -1
    if f9_local10 <= f9_local9 then
        f9_local11 = 9920
    end
    f9_arg0:AddObserveSpecialEffectAttribute(TARGET_SELF, 13060)
    f9_arg1:AddSubGoal(GOAL_COMMON_SidewayMove, f9_local0, f9_local1, f9_local2, f9_local3, f9_local6, f9_local7, f9_local11):SetTargetRange(1, 6, 100)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function RoamArmySpearmen431030_Act17(f10_arg0, f10_arg1, f10_arg2)
    local f10_local0 = 2
    local f10_local1 = TARGET_ENE_0
    local f10_local2 = 90
    local f10_local3 = GUARD_GOAL_DESIRE_RET_Continue
    local f10_local4 = true
    local f10_local5 = 100
    local f10_local6 = f10_arg0:GetRandam_Int(1, 100)
    local f10_local7 = -1
    if f10_local6 <= f10_local5 then
        f10_local7 = 9910
    end
    f10_arg1:AddSubGoal(GOAL_COMMON_Turn, f10_local0, f10_local1, f10_local2, f10_local7, f10_local3, f10_local4)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function RoamArmySpearmen431030_Act18(f11_arg0, f11_arg1, f11_arg2)
    local f11_local0 = 1
    local f11_local1 = TARGET_ENE_0
    local f11_local2 = 2
    local f11_local3 = TARGET_ENE_0
    local f11_local4 = true
    local f11_local5 = f11_arg0:GetDist(TARGET_ENE_0)
    local f11_local6 = 100
    local f11_local7 = f11_arg0:GetRandam_Int(1, 100)
    local f11_local8 = -1
    if f11_local7 <= f11_local6 then
        f11_local8 = 9910
    end
    f11_arg1:AddSubGoal(GOAL_COMMON_LeaveTarget, f11_local0, f11_local1, f11_local2, f11_local3, f11_local4, f11_local8, resultTypeIfGuardSuccess, isLifeSuccessGuard)
    
end

function RoamArmySpearmen431030_Act19(f12_arg0, f12_arg1, f12_arg2)
    local f12_local0 = 10
    local f12_local1 = TARGET_ENE_0
    local f12_local2 = 10
    local f12_local3 = TARGET_SELF
    local f12_local4 = true
    local f12_local5 = f12_arg0:GetDist(TARGET_ENE_0)
    local f12_local6 = 100
    local f12_local7 = f12_arg0:GetRandam_Int(1, 100)
    local f12_local8 = -1
    if f12_local7 <= f12_local6 then
        f12_local8 = 9910
    end
    f12_arg1:AddSubGoal(GOAL_COMMON_ApproachTarget, f12_local0, f12_local1, f12_local2, f12_local3, f12_local4, f12_local8)
    
end

function RoamArmySpearmen431030_Act20(f13_arg0, f13_arg1, f13_arg2)
    local f13_local0 = f13_arg0:GetDist(TARGET_ENE_0)
    local f13_local1 = 3.5
    local f13_local2 = 0
    local f13_local3 = 999
    local f13_local4 = 100
    local f13_local5 = 0
    local f13_local6 = 3
    local f13_local7 = 3
    Approach_Act_Flex(f13_arg0, f13_arg1, f13_local1, f13_local2, f13_local3, f13_local4, f13_local5, f13_local6, f13_local7)
    local f13_local8 = 5
    local f13_local9 = 3008
    local f13_local10 = TARGET_ENE_0
    local f13_local11 = 10
    local f13_local12 = 0
    local f13_local13 = 0
    local f13_local14 = 0
    f13_arg1:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, f13_local8, f13_local9, f13_local10, f13_local11, 0, 0, 0)
    
end

function RoamArmySpearmen431030_Act21(f14_arg0, f14_arg1, f14_arg2)
    local f14_local0 = f14_arg0:GetDist(TARGET_ENE_0)
    local f14_local1 = 3.5
    local f14_local2 = 0
    local f14_local3 = 999
    local f14_local4 = 100
    local f14_local5 = 0
    local f14_local6 = 3
    local f14_local7 = 3
    Approach_Act_Flex(f14_arg0, f14_arg1, f14_local1, f14_local2, f14_local3, f14_local4, f14_local5, f14_local6, f14_local7)
    local f14_local8 = 5
    local f14_local9 = 3009
    local f14_local10 = TARGET_ENE_0
    local f14_local11 = 10
    local f14_local12 = 0
    local f14_local13 = 0
    local f14_local14 = 0
    f14_arg1:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, f14_local8, f14_local9, f14_local10, f14_local11, 0, 0, 0)
    
end

function RoamArmySpearmen431030_Act22(f15_arg0, f15_arg1, f15_arg2)
    local f15_local0 = f15_arg0:GetDist(TARGET_ENE_0)
    local f15_local1 = f15_arg0:GetRandam_Int(1, 100)
    if f15_local0 >= 6 then
        local f15_local2 = f15_arg0:GetDist(TARGET_ENE_0)
        local f15_local3 = 5.5
        local f15_local4 = 0
        local f15_local5 = 999
        local f15_local6 = 100
        local f15_local7 = 100
        local f15_local8 = 3
        local f15_local9 = 3
        Approach_Act_Flex(f15_arg0, f15_arg1, f15_local3, f15_local4, f15_local5, f15_local6, f15_local7, f15_local8, f15_local9)
    elseif f15_local0 <= 3 then
        local f15_local2 = 5
        local f15_local3 = 6001
        local f15_local4 = TARGET_ENE_0
        local f15_local5 = 10
        local f15_local6 = 0
        local f15_local7 = 0
        local f15_local8 = 0
        f15_arg1:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, f15_local2, f15_local3, f15_local4, f15_local5, 0, 0, 0)
    end
    f15_arg0:AddObserveSpecialEffectAttribute(TARGET_SELF, 5025)
    local f15_local2 = 5
    local f15_local3 = 3010
    local f15_local4 = TARGET_ENE_0
    local f15_local5 = 10
    local f15_local6 = 0
    local f15_local7 = 0
    local f15_local8 = 0
    f15_arg1:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, f15_local2, f15_local3, f15_local4, f15_local5, 0, 0, 0)
    
end

function RoamArmySpearmen431030_Act23(f16_arg0, f16_arg1, f16_arg2)
    local f16_local0 = f16_arg0:GetDist(TARGET_ENE_0)
    local f16_local1 = 8.5
    local f16_local2 = 0
    local f16_local3 = 999
    local f16_local4 = 100
    local f16_local5 = 0
    local f16_local6 = 3
    local f16_local7 = 3
    Approach_Act_Flex(f16_arg0, f16_arg1, f16_local1, f16_local2, f16_local3, f16_local4, f16_local5, f16_local6, f16_local7)
    local f16_local8 = 5
    local f16_local9 = 3007
    local f16_local10 = TARGET_ENE_0
    local f16_local11 = 10
    local f16_local12 = 0
    local f16_local13 = 0
    local f16_local14 = 0
    f16_arg1:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, f16_local8, f16_local9, f16_local10, f16_local11, 0, 0, 0)
    
end

function RoamArmySpearmen431030_Act24(f17_arg0, f17_arg1, f17_arg2)
    local f17_local0 = 5
    local f17_local1 = 3026
    local f17_local2 = TARGET_ENE_0
    local f17_local3 = 10
    local f17_local4 = 0
    local f17_local5 = 0
    local f17_local6 = 0
    f17_arg1:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, f17_local0, f17_local1, f17_local2, f17_local3, 0, 0, 0)
    local f17_local7 = 4
    local f17_local8 = TARGET_ENE_0
    local f17_local9 = 0.1
    local f17_local10 = TARGET_SELF
    local f17_local11 = true
    local f17_local12 = f17_arg0:GetDist(TARGET_ENE_0)
    local f17_local13 = 100
    local f17_local14 = f17_arg0:GetRandam_Int(1, 100)
    local f17_local15 = -1
    if f17_local14 <= f17_local13 then
        f17_local15 = 9910
    end
    f17_arg1:AddSubGoal(GOAL_COMMON_ApproachTarget, f17_local7, f17_local8, f17_local9, f17_local10, f17_local11, f17_local15)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function RoamArmySpearmen431030_Act25(f18_arg0, f18_arg1, f18_arg2)
    local f18_local0 = 5
    local f18_local1 = f18_arg0:GetRandam_Int(3027, 3028)
    local f18_local2 = TARGET_ENE_0
    local f18_local3 = 10
    local f18_local4 = 0
    local f18_local5 = 0
    local f18_local6 = 0
    f18_arg1:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, f18_local0, f18_local1, f18_local2, f18_local3, 0, 0, 0)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function RoamArmySpearmen431030_Act26(f19_arg0, f19_arg1, f19_arg2)
    local f19_local0 = f19_arg0:GetDist(TARGET_ENE_0)
    local f19_local1 = f19_arg0:GetRandam_Int(1, 100)
    if f19_local0 >= 3 then
        local f19_local2 = 4
        local f19_local3 = TARGET_ENE_0
        local f19_local4 = 0.1
        local f19_local5 = TARGET_SELF
        local f19_local6 = true
        local f19_local7 = f19_arg0:GetDist(TARGET_ENE_0)
        local f19_local8 = 100
        local f19_local9 = f19_arg0:GetRandam_Int(1, 100)
        local f19_local10 = -1
        if f19_local9 <= f19_local8 then
            f19_local10 = 9910
        end
        f19_arg1:AddSubGoal(GOAL_COMMON_ApproachTarget, f19_local2, f19_local3, f19_local4, f19_local5, f19_local6, f19_local10)
        GetWellSpace_Odds = 0
        return GetWellSpace_Odds
    else
        local f19_local2 = f19_arg0:GetRandam_Int(1, 2)
        local f19_local3 = TARGET_ENE_0
        local f19_local4 = f19_arg0:GetRandam_Int(0, 1)
        local f19_local5 = f19_arg0:GetRandam_Int(30, 45)
        local f19_local6 = 0.1
        local f19_local7 = TARGET_SELF
        local f19_local8 = true
        local f19_local9 = true
        local f19_local10 = f19_arg0:GetDist(TARGET_ENE_0)
        local f19_local11 = 100
        local f19_local12 = f19_arg0:GetRandam_Int(1, 100)
        local f19_local13 = -1
        if f19_local12 <= f19_local11 then
            f19_local13 = 9910
        end
        f19_arg1:AddSubGoal(GOAL_COMMON_SidewayMove, f19_local2, f19_local3, f19_local4, f19_local5, f19_local8, f19_local9, f19_local13)
        GetWellSpace_Odds = 0
        return GetWellSpace_Odds
    end
    
end

function RoamArmySpearmen431030_Act30(f20_arg0, f20_arg1, f20_arg2)
    if f20_arg0:HasSpecialEffectId(TARGET_SELF, 13298) then
        local f20_local0 = f20_arg0:GetDist(TARGET_ENE_0)
        local f20_local1 = 8.5
        local f20_local2 = 0
        local f20_local3 = 999
        local f20_local4 = 100
        local f20_local5 = 0
        local f20_local6 = 3
        local f20_local7 = 3
        if f20_arg0:HasSpecialEffectId(TARGET_SELF, 13055) then
            f20_local5 = 0
        end
        if f20_arg0:HasSpecialEffectId(TARGET_SELF, 13282) then
            f20_local2 = 100
            f20_local3 = 999
            f20_local4 = 0
            f20_local6 = 5
            f20_local7 = 0
        end
        Approach_Act_Flex(f20_arg0, f20_arg1, f20_local1, f20_local2, f20_local3, f20_local4, f20_local5, f20_local6, f20_local7)
    end
    local f20_local0 = 5
    local f20_local1 = 3025
    local f20_local2 = TARGET_ENE_0
    local f20_local3 = 10
    local f20_local4 = 0
    local f20_local5 = 0
    local f20_local6 = 0
    f20_arg1:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, f20_local0, f20_local1, f20_local2, f20_local3, 0, 0, 0)
    
end

function RoamArmySpearmen431030_ActAfter_AdjustSpace(f21_arg0, f21_arg1, f21_arg2)
    f21_arg1:AddSubGoal(GOAL_RoamArmySpearmen431030_AfterAttackAct, 10)
    
end

Goal.Update = function (f22_arg0, f22_arg1, f22_arg2)
    return Update_Default_NoSubGoal(f22_arg0, f22_arg1, f22_arg2)
    
end

Goal.Terminate = function (f23_arg0, f23_arg1, f23_arg2)
    
end

Goal.Interrupt = function (f24_arg0, f24_arg1, f24_arg2)
    -- Do not enqueue this script's interrupt attacks or retreats.
    -- Shared/native interrupt behavior is outside this callback.
    return false
end

RegisterTableGoal(GOAL_RoamArmySpearmen431030_AfterAttackAct, "RoamArmySpearmen431030_AfterAttackAct")
REGISTER_GOAL_NO_SUB_GOAL(GOAL_RoamArmySpearmen431030_AfterAttackAct, true)

Goal.Activate = function (f25_arg0, f25_arg1, f25_arg2)
    
end

Goal.Update = function (f26_arg0, f26_arg1, f26_arg2)
    return Update_Default_NoSubGoal(f26_arg0, f26_arg1, f26_arg2)
    
end


