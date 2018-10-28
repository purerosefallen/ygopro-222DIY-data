--首都袭击战
local m=47530022
local cm=_G["c"..m]
function c47530022.initial_effect(c)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47530022,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCondition(c47530022.descon)
    e1:SetTarget(c47530022.destg)
    e1:SetOperation(c47530022.desop)
    c:RegisterEffect(e1)   
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47530022,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c47530022.spcon)
    e3:SetTarget(c47530022.sptg)
    e3:SetOperation(c47530022.spop)
    c:RegisterEffect(e3)
    local e2=e1:Clone()
    e2:SetCode(EVENT_REMOVE)
    c:RegisterEffect(e2) 
end
c47530022.is_named_with_ZEON=1
function c47530022.cfilter(c,tp)
    return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
        and (c:IsReason(REASON_DESTROY) and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp
            or c:IsReason(REASON_BATTLE) and Duel.GetTurnPlayer()==1-tp)
        and c:GetSummonLocation()==LOCATION_EXTRA and c:IsRace(RACE_MACHINE)
end
function c47530022.descon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47530022.cfilter,1,nil,tp)
end
function c47530022.filter(c)
    return c:IsFaceup() and c:IsAbleToRemove()
end
function c47530022.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47530022.filter,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(c47530022.filter,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c47530022.spfilter(c,e,tp)
    return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47530022.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47530022.filter,tp,0,LOCATION_ONFIELD,nil)
    if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED) and Duel.SelectYesNo(tp,aux.Stringid(47530022,0)) then
        local g1=Duel.SelectMatchingCard(tp,c47530022.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
        Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c47530022.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_EFFECT) and rp==1-tp and c:GetPreviousControler()==tp
        and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c47530022.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_MACHINE)
end
function c47530022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local loc=0
        if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_DECK end
        if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
        return loc~=0 and Duel.IsExistingMatchingCard(c47530022.spfilter,tp,loc,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47530022.spop(e,tp,eg,ep,ev,re,r,rp)
    local loc=0
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_DECK end
    if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
    if loc==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47530022.spfilter,tp,loc,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end