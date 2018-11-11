--Mecha Blade Base Defender
local m=88880212
local cm=_G["c"..m]
function cm.initial_effect(c)
--xyz summon
    aux.AddXyzProcedure(c,cm.mfilter,4,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetCondition(cm.damcon)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CHANGE_DAMAGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,0)
    e3:SetValue(cm.damval)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(cm.atkval)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,1))
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_PHASE+PHASE_END)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(cm.rmtg)
    e5:SetOperation(cm.rmop)
    c:RegisterEffect(e5)
end
function cm.mfilter(c)
    return c:IsSetCard(0xffd)
end
function cm.atkval(e,c)
    return c:GetOverlayCount()*500
end
function cm.damval(e,re,val,r,rp,rc)
    local def=e:GetHandler():GetDefense()
    if val<=def then return 0 else return val end
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetOverlayCount()>0
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
function cm.ovfilter(c)
    return c:IsFaceup()
        and ((c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,88880005))
        or (c:IsCode(88880006) and c:GetOverlayGroup():GetCount()>0))
end
function cm.xyzop(e,tp,chk,mc)
    if chk==0 then return mc:CheckRemoveOverlayCard(tp,1,REASON_COST) end
    mc:RemoveOverlayCard(tp,1,1,REASON_COST)
end