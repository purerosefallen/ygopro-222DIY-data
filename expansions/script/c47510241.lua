--半神半魔 阿米拉
local m=47510241
local cm=_G["c"..m]
function c47510241.initial_effect(c)
    --immune
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c47510241.efilter)
    c:RegisterEffect(e1)
    --charnge
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,47510241)
    e3:SetCondition(c47510241.crcon)
    e3:SetOperation(c47510241.crop)
    c:RegisterEffect(e3)    
    --Change
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(47510241,0))
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e7:SetTarget(c47510241.changetg)
    e7:SetOperation(c47510241.changeop)
    c:RegisterEffect(e7)      

end
function c47510241.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c47510241.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c.dfc_front_side and c.dfc_back_side==c:GetOriginalCode() end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c47510241.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
    local tcode=c.dfc_front_side
    c:SetEntityCode(tcode,true)
    c:ReplaceEffect(tcode,0,0)
end
function c47510241.crcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c47510241.crop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_SET_ATTACK_FINAL)
    e3:SetValue(4500)
    e3:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e3)
end