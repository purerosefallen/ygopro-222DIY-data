--界限异端 伊卡洛斯
local m=62430004
local cm=_G["c"..m]
function cm.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetTargetRange(LOCATION_ONFIELD,0)
    e1:SetValue(5000)
    e1:SetTarget(cm.tg)
    c:RegisterEffect(e1)
    --diratk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCode(EFFECT_DIRECT_ATTACK)
    e2:SetTargetRange(LOCATION_ONFIELD,0)
    e2:SetTarget(cm.tg)
    c:RegisterEffect(e2)
end
function cm.tg(e,c)
    return c:IsType(TYPE_NORMAL)
end