--界限审议员 塔尔塔罗斯
local m=62430001
local cm=_G["c"..m]
function cm.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --immune effect
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(LOCATION_ONFIELD,0)
    e1:SetTarget(cm.imtg)
    c:RegisterEffect(e1)
end
function cm.imtg(e,c)
    return c:IsType(TYPE_NORMAL)
end