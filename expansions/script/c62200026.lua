--界限伙伴 清桃
local m=62430002
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
    e1:SetValue(cm.val)
    e1:SetTarget(cm.tg)
    c:RegisterEffect(e1)    
end
function cm.val(e,c)
    return Duel.GetLP(c:GetControler())
end
function cm.tg(e,c)
    return c:IsType(TYPE_NORMAL)
end