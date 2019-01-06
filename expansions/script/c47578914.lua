--天司长的依代
local m=47578914
local cm=_G["c"..m]
function c47578914.initial_effect(c)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetCondition(c47578914.spcon)
    e1:SetTarget(c47578914.sptg)
    e1:SetOperation(c47578914.spop)
    c:RegisterEffect(e1)
    --salvage
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(c47578914.thcost)
    e2:SetCondition(aux.exccon)
    e2:SetTarget(c47578914.target)
    e2:SetOperation(c47578914.activate)
end
function c47578914.cfilter(c,tp)
    return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and bit.band(c:GetPreviousRaceOnField(),RACE_FAIRY)~=0
        and rp==1-tp and c:IsReason(REASON_EFFECT)
end
function c47578914.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47578914.cfilter,1,e:GetHandler(),tp)
end
function c47578914.spfilter(c,e,tp)
    return c:IsSetCard(0x5de) and c:IsCanBeSpecialSummoned(e,0,tp,false,true) and not c:IsType(TYPE_LINK)
end 
function c47578914.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47578914.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47578914.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47578914.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,true,POS_FACEUP)
    end
end
function c47578914.cfilter(c)
    return c:IsSetCard(0x5de) and c:IsAbleToRemoveAsCost()
end
function c47578914.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
        and Duel.IsExistingMatchingCard(c47578914.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c47578914.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    g:AddCard(e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c47578914.ssfilter(c,e,tp)
    return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47578914.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47578914.ssfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47578914.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47578914.ssfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end