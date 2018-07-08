--究极形态 假面骑士Kuuga
function c22260120.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,10,3)
    c:EnableReviveLimit()
    --disable
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetCondition(c22260120.effcon)
    e1:SetTarget(c22260120.disable)
    e1:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e1)
    --CopyEffect
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(22260120,0))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BATTLED)
    e2:SetCondition(c22260120.cpcon)
    e2:SetOperation(c22260120.cpop)
    c:RegisterEffect(e2)
    --destroy replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c22260120.reptg)
    c:RegisterEffect(e3)
end
c22260120.named_with_Kuuga=1
function c22260120.IsKuuga(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_Kuuga
end
c22260120.named_with_KamenRider=1
function c22260120.IsKamenRider(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_KamenRider
end
--
function c22260120.effcon(e)
    return e:GetHandler():GetOverlayCount()>0
end
function c22260120.disable(e,c)
    return c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT
end
--
function c22260120.cpcon(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
    local c=e:GetHandler()
    local a=Duel.GetAttacker()
    if a==c then a=Duel.GetAttackTarget() end
    if a then e:SetLabel(a:GetOriginalCode()) end
    return a and a:IsType(TYPE_EFFECT) and a:IsRelateToBattle()
end
function c22260120.cpop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local code=e:GetLabel()
    if c:IsFacedown() or not c:IsRelateToBattle() then return end
    c:CopyEffect(code,RESET_EVENT+0x1fe0000,0)
end
--
function c22260120.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
        and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    if Duel.SelectEffectYesNo(tp,c,96) then
        c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
        return true
    else return false end
end