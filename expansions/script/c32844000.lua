--- @title 古风（炎族，封印卡组检索和特召，只靠墓地、除外、额外的流转展开）
--- @author 神鹰(455168247@qq.com)
--- @date 2018-2-3 20:13:06

xpcall(function() require("expansions/script/c32800000") end, function() require("script/c32800000") end)
local cm = orion

----------------------------------------------------------------------------------------------------
---------------------------------------------- 过滤器 ----------------------------------------------
----------------------------------------------------------------------------------------------------

--- 是否为炎族怪兽
function cm.isPyroMonster(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PYRO)
end

--- 是否为炎族灵摆怪兽
function cm.isPyroPendulum(c)
    return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_PYRO)
end

--- 是否能特殊召唤
function cm.canPyroSummon(c, e, tp)
    return c:IsCanBeSpecialSummoned(e, 0, tp, false, false) and c:IsRace(RACE_PYRO)
end

--- 是否为正面且能特殊召唤
function cm.canPyroSummonFaceUp(c, e, tp)
    return c:IsFaceup() and cm.canPyroSummon(c, e, tp)
end

--- 是否能送去墓地
function cm.canPyroToGrave(c)
    return c:IsAbleToGrave() and cm.isPyroMonster(c)
end

--- 是否能除外
function cm.canPyroToRemove(c)
    return c:IsAbleToRemove() and cm.isPyroMonster(c)
end

--- 是否为能加入手卡的灵摆怪兽
function cm.canPendulumPyroToHand(c)
    return c:IsAbleToHand() and c:IsFaceup() and cm.isPyroPendulum(c)
end

----------------------------------------------------------------------------------------------------
--------------------------------------------- 注册效果 ---------------------------------------------
----------------------------------------------------------------------------------------------------

--- 灵摆通用自肃
function cm.registerPyroPendulum(c)
    -- pendulum summon
    aux.EnablePendulumAttribute(c)
    -- cannot spsummon
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(1, 0)
    e1:SetTarget(function(e, c, sump, sumtype, sumpos, targetp)
        return not c:IsRace(RACE_PYRO)
    end)
    c:RegisterEffect(e1)
    -- immume self's effect
    e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetValue(function(e, re)
        return e:GetHandlerPlayer() == re:GetHandlerPlayer() and e:GetHandler():GetLocation() == LOCATION_SZONE -- 之前用的LOCATION_PZONE有问题，改为LOCATION_SZONE才有效
    end)
    c:RegisterEffect(e1)
end

--- 灵摆手牌发动
-- @Card c 这张卡
-- @number m 卡片编号
-- @number desNo 提示文本序号
function cm.registerPyroHandEffect(c, m, desNo)
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m, desNo))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1, m)
    e1:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        return not c:IsForbidden() and (Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1))
    end)
    e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        Duel.MoveToField(c, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
    end)
    c:RegisterEffect(e1)
end