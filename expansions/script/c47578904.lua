--天司叛乱的终局
local m=47578904
local cm=_G["c"..m]
function c47578904.initial_effect(c)
    c:SetUniqueOnField(1,0,47578904)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47578904,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(c47578904.activate)
    c:RegisterEffect(e1)
    --mudeki
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetRange(LOCATION_SZONE)
    e5:SetTargetRange(LOCATION_PZONE+LOCATION_FZONE,0)
    e5:SetTarget(c47578904.atktg)
    e5:SetValue(c47578904.efilter)
    c:RegisterEffect(e5)
end
function c47578904.thf(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5de) and c:IsAbleToHand() and c:IsFaceup()
end
function c47578904.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c47578904.thf,tp,LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(47578904,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function c47578904.atktg(e,c)
    return c:IsSetCard(0x5de)
end
function c47578904.efilter(e,re)
    return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end