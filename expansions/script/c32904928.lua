--Zephyr the Aeonbreaker's Blademaster
function c32904928.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xaa12),c32904928.ffilter,true)
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,32904928)
    e2:SetTarget(c32904928.destg)
    e2:SetOperation(c32904928.desop)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c32904928.spcon)
    e3:SetTarget(c32904928.sptg)
    e3:SetOperation(c32904928.spop)
    c:RegisterEffect(e3)
end
function c32904928.ffilter(c)
    return c:IsRace(RACE_PSYCHO) and c:IsLevelAbove(4)
end
function c32904928.retfilter1(c)
    return c:IsSetCard(0xaa12) and c:IsAbleToDeck()
end
function c32904928.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(c32904928.retfilter1,tp,LOCATION_GRAVE,0,2,nil)
        and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g1=Duel.SelectTarget(tp,c32904928.retfilter1,tp,LOCATION_GRAVE,0,2,2,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g2=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function c32904928.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local g1=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
    if Duel.SendtoDeck(g1,nil,0,REASON_EFFECT)~=0 then
        local og=Duel.GetOperatedGroup()
        if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
        local g2=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
        Duel.Destroy(g2,REASON_EFFECT)
    end
end
function c32904928.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c32904928.filter(c,e,tp)
    return c:IsRace(RACE_PSYCHO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32904928.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(c32904928.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c32904928.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c32904928.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end