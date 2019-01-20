--守护天使 炽天摇篮
local m=47578935
function c47578935.initial_effect(c)
    c:SetSPSummonOnce(47578935)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_FAIRY),2,2)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47578935.splimit)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47578935,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,47578935)
    e2:SetTarget(c47578935.sptg)
    e2:SetOperation(c47578935.spop)
    c:RegisterEffect(e2)
end
function c47578935.splimit(e,c,sump,sumtype,sumpos,targetp)
    return not c:IsRace(RACE_FAIRY)
end
function c47578935.lkfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c47578935.spfilter(c,e,tp,zone)
    return c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c47578935.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local zone=aux.GetMultiLinkedZone(tp)
    if chk==0 then return zone~=0 and Duel.GetLocationCountFromEx(tp)>0
        and Duel.IsExistingMatchingCard(c47578935.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47578935.spop(e,tp,eg,ep,ev,re,r,rp)
    local zone=aux.GetMultiLinkedZone(tp)
    if Duel.GetLocationCountFromEx(tp)<=0 or zone==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47578935.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
    end
end