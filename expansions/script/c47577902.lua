--堕天司的假死 
function c47577902.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,47577902+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c47577902.target)
    e1:SetOperation(c47577902.activate)
    c:RegisterEffect(e1)    
    --material
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47577900,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,47577903)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c47577902.ptg)
    e2:SetOperation(c47577902.pop)
    c:RegisterEffect(e2)  
end
function c47577902.tgfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x95de) and c:IsAbleToGrave()
end
function c47577902.filter(c,e,sp)
    return c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,sp,false,false) and c:IsLevelAbove(7)
end
function c47577902.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47577902.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c47577902.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c47577902.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47577902.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c47577902.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
function c47577902.pfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x95de) and c:IsAbleToHand()
end
function c47577902.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47577902.pfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c47577902.pop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47577902.pfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end