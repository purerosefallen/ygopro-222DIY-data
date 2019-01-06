--闪光高达
function c47530100.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,nil,2,2,c47530100.spcheck)    
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47530100,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,47530100)
    e1:SetCondition(c47530100.hspcon)
    e1:SetTarget(c47530100.hsptg)
    e1:SetOperation(c47530100.hspop)
    c:RegisterEffect(e1)
    --change
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47530100,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c47530100.spcost)
    e2:SetCondition(c47530100.spcon)
    e2:SetTarget(c47530100.sptg)
    e2:SetOperation(c47530100.spop)
    c:RegisterEffect(e2)
end
function c47530100.spcheck(g)
    return g:GetClassCount(Card.GetLinkRace)==g:GetCount() and g:GetClassCount(Card.GetLinkAttribute)==g:GetCount() and g:GetClassCount(Card.GetLevel)==g:GetCount()
end
function c47530100.hspcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47530100.hspfilter(c,e,tp,zone)
    return c:IsLevelBelow(7) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c47530100.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47530100.hspfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,zone) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c47530100.hspop(e,tp,eg,ep,ev,re,r,rp)
    local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or zone<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47530100.hspfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP,zone) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_TRIGGER)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
        e2:SetValue(1)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2)    
        local e3=e2:Clone()
        e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
        tc:RegisterEffect(e3)
        local e4=e2:Clone()
        e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
        tc:RegisterEffect(e4)
    end
    Duel.SpecialSummonComplete()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47530100.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47530100.splimit(e,c)
    return not c:IsRace(RACE_MACHINE) and c:IsLocation(LOCATION_EXTRA)
end
function c47530100.cfilter(c,lg,tp)
    return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and bit.band(c:GetSummonLocation(),LOCATION_EXTRA)~=0 and lg:IsContains(c)
end
function c47530100.spcon(e,tp,eg,ep,ev,re,r,rp)
    local lg=e:GetHandler():GetLinkedGroup()
    return eg:IsExists(c47530100.cfilter,1,nil,lg,tp)
end
function c47530100.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c47530100.spfilter(c,e,tp)
    return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLink(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47530100.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
        and Duel.IsExistingMatchingCard(c47530100.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47530100.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47530100.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47530100.splimit1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c47530100.splimit)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function c47530100.splimit1(e,c)
    return c:IsType(TYPE_LINK)
end