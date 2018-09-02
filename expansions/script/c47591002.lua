--二王的反抗
local m=47591002
local cm=_G["c"..m]
function c47591002.initial_effect(c)
    c:SetUniqueOnField(1,0,47591002)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_INACTIVATE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1,47591002)
    e1:SetCondition(c47591002.con)
    e1:SetValue(c47591002.effectfilter)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_DISEFFECT)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(c47591002.con)
    e3:SetValue(c47591002.effectfilter)
    c:RegisterEffect(e3)
    --Activate2
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47591002,0))
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCountLimit(1,47591002+EFFECT_COUNT_CODE_OATH)
    e2:SetTarget(c47591002.target)
    e2:SetOperation(c47591002.activate)
    c:RegisterEffect(e2)
end
function c47591002.cfilter(c,tp)
    return c:IsCode(47591822) 
end
function c47591002.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47591002.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c47591002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetDecktopGroup(tp,2)
    if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==2
        and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 end
    Duel.DisableShuffleCheck()
    Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c47591002.effectfilter(e,ct)
    local p=e:GetHandler():GetControler()
    local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
    return p==tp and te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and bit.band(loc,LOCATION_ONFIELD)~=0
end
function c47591002.filter(c)
    return c:IsSetCard(0x5d1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c47591002.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47591002.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47591002.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47591002.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end