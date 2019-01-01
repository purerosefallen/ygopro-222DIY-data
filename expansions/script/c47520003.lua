--西南西的守护神 安琪拉
local m=47520003
local cm=_G["c"..m]
function c47520003.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
    c:EnableReviveLimit()
    --shinramanshyou
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47520003,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c47520003.lpcon)
    e1:SetTarget(c47520003.lptg)
    e1:SetOperation(c47520003.lpop)
    c:RegisterEffect(e1) 
    --inactivatable
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_INACTIVATE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetLabelObject(e0)
    e4:SetValue(c47520003.effectfilter)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_DISEFFECT)
    c:RegisterEffect(e5) 
end
function c47520003.effectfilter(e,ct)
    local p=e:GetHandler():GetControler()
    local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
    return p==tp and te:GetHandler():IsType(TYPE_MONSTER) 
end
function c47520003.lpcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47520003.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2000)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function c47520003.lpop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
end