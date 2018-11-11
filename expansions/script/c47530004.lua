--量产型钢加农防御者
local m=47530004
local cm=_G["c"..m]
function c47530004.initial_effect(c)
    c:SetSPSummonOnce(47530004)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c47530004.lfilter,2,2)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47530004.splimit)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47530004,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1,47530004)
    e2:SetCost(c47530004.spcost)
    e2:SetTarget(c47530004.sptg)
    e2:SetOperation(c47530004.spop)
    c:RegisterEffect(e2)
    if aux.GetMultiLinkedZone==nil then
        function aux.GetMultiLinkedZone(tp)
            local lg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
            local multi_linked_zone=0
            local single_linked_zone=0
            for tc in aux.Next(lg) do
                local zone=tc:GetLinkedZone(tp)&0x7f
                multi_linked_zone=single_linked_zone&zone|multi_linked_zone
                single_linked_zone=single_linked_zone~zone
            end
            return multi_linked_zone
        end
    end
end
function c47530004.lfilter(c)
    return c:IsLevel(10) and c:IsRace(RACE_MACHINE)
end
function c47530004.splimit(e,c,sump,sumtype,sumpos,targetp)
    return not c:IsRace(RACE_MACHINE)
end
function c47530004.lkfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c47530004.spcfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c47530004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c47530004.spcfilter,1,nil) end
    local g=Duel.SelectReleaseGroup(tp,c47530004.spcfilter,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function c47530004.spfilter(c,e,tp,zone)
    return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c47530004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local zone=aux.GetMultiLinkedZone(tp)
    if chk==0 then return zone~=0 and Duel.GetLocationCountFromEx(tp)>0
        and Duel.IsExistingMatchingCard(c47530004.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47530004.spop(e,tp,eg,ep,ev,re,r,rp)
    local zone=aux.GetMultiLinkedZone(tp)
    if Duel.GetLocationCountFromEx(tp)<=0 or zone==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47530004.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
    end
end