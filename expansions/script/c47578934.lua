--守护天使 武器幻影
function c47578934.initial_effect(c)
    c:SetSPSummonOnce(47578934)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c47578934.matfilter,1,1)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47578934.splimit)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47578934,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,47578934)
    e2:SetTarget(c47578934.sptg)
    e2:SetOperation(c47578934.spop)
    c:RegisterEffect(e2)
end
function c47578934.matfilter(c)
    return c:IsLevelBelow(4) and c:IsLinkRace(RACE_FAIRY)
end
function c47578934.splimit(e,c,sump,sumtype,sumpos,targetp)
    return not c:IsRace(RACE_FAIRY)
end
function c47578934.lkfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c47578934.spfilter(c,e,tp,zone)
    return c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c47578934.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local zone=aux.GetMultiLinkedZone(tp)
    if chk==0 then return zone~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47578934.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,zone) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c47578934.spop(e,tp,eg,ep,ev,re,r,rp)
    local zone=aux.GetMultiLinkedZone(tp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or zone==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47578934.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,zone)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
    end
end