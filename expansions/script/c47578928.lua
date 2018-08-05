--水之天司 加百利
local m=47578928
local cm=_G["c"..m]
function c47578928.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,3,c47578928.lcheck)
    c:EnableReviveLimit()
       --spsunmmon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,47578928+EFFECT_COUNT_CODE_DUEL)
    e2:SetCondition(c47578928.spcon)
    e2:SetTarget(c47578928.sptg)
    e2:SetOperation(c47578928.spop)
    c:RegisterEffect(e2) 
    --4757
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,47578929)
    e2:SetCost(c47578928.cost)
    e2:SetTarget(c47578928.thtg)
    e2:SetOperation(c47578928.thop)
    c:RegisterEffect(e2)
end
function c47578928.lcheck(g,lc)
    return g:IsExists(Card.IsSetCard,1,nil,0x5de)
end
function c47578928.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47578928.filter2(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x5de)
end
function c47578928.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(c47578928.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c47578928.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47578928.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c47578928.cfilter(c)
    return c:IsRace(RACE_FAIRY) and c:IsDiscardable()
end
function c47578928.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47578928.cfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,c47578928.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c47578928.thfilter(c)
    return c:IsSetCard(0x5de) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c47578928.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47578928.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47578928.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47578928.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end