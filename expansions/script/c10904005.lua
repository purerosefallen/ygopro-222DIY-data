--灵刻使 贵妇人
local m=10904005
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_HAND)
    e0:SetCondition(cm.spcon)
    c:RegisterEffect(e0)  
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x237))
    e1:SetCondition(cm.tgcon)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetRange(LOCATION_PZONE)
    e7:SetTargetRange(LOCATION_PZONE,LOCATION_PZONE)
    e7:SetCode(EFFECT_IMMUNE_EFFECT)
    e0:SetCondition(cm.emcon)
    e7:SetValue(cm.efilter)
    c:RegisterEffect(e7)
end
function cm.spcon(e)
    local tp=e:GetHandler():GetControler()
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if not tc1 or not tc2 then return false end
    return tc1:GetLeftScale()==tc2:GetRightScale() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.tgcon(e)
    local tp=e:GetHandler():GetControler()
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if not tc1 or not tc2 then return false end
    return tc1:GetLeftScale()==tc2:GetRightScale() and e:GetHandler():GetLeftScale()>tc1:GetLeftScale()
end
function cm.emcon(e)
    local tp=e:GetHandler():GetControler()
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if not tc1 or not tc2 then return false end
    return tc1:GetLeftScale()==tc2:GetRightScale() 
end
function cm.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
end
    
