--- @title 幻象诱导
--- @author 神鹰(455168247@qq.com)
--- @date 2018-2-23 00:33:28

local m = 32828001
local cm = _G["c" .. m]
function cm.initial_effect(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0, TIMING_END_PHASE)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
end

function cm.activate(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    -- atk up
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetTargetRange(0, LOCATION_MZONE)
    e1:SetReset(RESET_PHASE + PHASE_END)
    e1:SetValue(2000)
    Duel.RegisterEffect(e1, tp)
    -- must attack
    e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_MUST_ATTACK)
    e1:SetTargetRange(0, LOCATION_MZONE)
    e1:SetReset(RESET_PHASE + PHASE_END)
    e1:SetValue(1)
    Duel.RegisterEffect(e1, tp)
end
