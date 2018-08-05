--天司的失乐园
local m=47578916
local cm=_G["c"..m]
function c47578916.initial_effect(c)
        --search
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,47578916)
    e2:SetCost(c47578916.cost)
    e2:SetTarget(c47578916.thtg)
    e2:SetOperation(c47578916.thop)
    c:RegisterEffect(e2)
    --salvage
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_ACTIVATE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,47578917+EFFECT_COUNT_CODE_DUEL)
    e3:SetCost(aux.bfgcost)
    e3:SetCondition(c47578916.spcon)
    e3:SetTarget(c47578916.sptg)
    e3:SetOperation(c47578916.spop)
    c:RegisterEffect(e3)
end
function c47578916.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47578916.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c47578916.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
    Duel.SendtoDeck(g,nil,3,REASON_COST)
end
function c47578916.cfilter(c)
    return c:IsSetCard(0x5de) and c:IsAbleToDeckAsCost()
end
function c47578916.filter(c)
    return c:IsSetCard(0x5de) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c47578916.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47578916.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47578916.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47578916.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47578916.filter1(c)
    return c:IsSetCard(0x5de) and c:IsFaceup()
end
function c47578916.spcon(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47578916.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,nil)
    local ct=g:GetClassCount(Card.GetCode)
    return ct>10
end
function c47578916.spfilter2(c,e,tp)
    return c:IsSetCard(0x5de) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c47578916.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47578916.spfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
end
function c47578916.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47578916.spfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
    end
end