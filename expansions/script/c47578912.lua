--天司长的继承
local m=47578912
local cm=_G["c"..m]
function c47578912.initial_effect(c)
       --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c47578912.condition)
    e1:SetCountLimit(1,47578912)
    e1:SetCost(c47578912.cost)
    e1:SetTarget(c47578912.target)
    e1:SetOperation(c47578912.activate)
    c:RegisterEffect(e1) 
end
function c47578912.cofilter(c)
    return c:IsSetCard(0x5de) and c:IsType(TYPE_MONSTER)
end
function c47578912.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer() and not Duel.IsExistingMatchingCard(c47578912.cofilter,tp,LOCATION_MZONE,0,1,nil) 
end
function c47578912.cfilter(c)
    return c:IsSetCard(0x5de) and c:IsAbleToGraveAsCost()
end
function c47578912.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47578912.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47578912.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c47578912.filter(c,e,tp)
    return c:IsSetCard(0x5de) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(47590008)
end
function c47578912.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47578912.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47578912.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47578912.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
