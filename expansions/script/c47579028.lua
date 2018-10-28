--神掳的丽姬 欧罗巴
local m=47579028
local cm=_G["c"..m]
function c47579028.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,3,c47579028.lcheck)
    c:EnableReviveLimit()
    --extra link
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetTarget(c47579028.mattg)
    e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
    e0:SetTargetRange(LOCATION_SZONE,0)
    e0:SetValue(c47579028.matval)
    c:RegisterEffect(e0)
    --damage
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47579028,0))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,47579027)
    e1:SetCondition(c47579028.spcon)
    e1:SetTarget(c47579028.sptg)
    e1:SetOperation(c47579028.spop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)     
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47579028,0))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,47579028)
    e3:SetTarget(c47579028.mtg)
    e3:SetOperation(c47579028.mop)
    c:RegisterEffect(e3)
    --xyz
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e4:SetCountLimit(1)
    e4:SetCondition(c47579028.sccon)
    e4:SetTarget(c47579028.xyztg)
    e4:SetOperation(c47579028.xyzop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_XYZ_LEVEL)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(8)
    c:RegisterEffect(e5) 
    --destroy
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e6:SetCondition(c47579028.nlcon)
    e6:SetOperation(c47579028.nlop)
    c:RegisterEffect(e6)
end
function c47579028.lcheck(g,lc)
    return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER)
end
function c47579028.matval(e,c,mg)
    return c:IsCode(47579028)
end
function c47579028.mattg(e,c)
    return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c47579028.cfilter(c,ec)
    if c:IsLocation(LOCATION_MZONE) then
        return c:IsFaceup() and ec:GetLinkedGroup():IsContains(c)
    else
        return c:IsPreviousPosition(POS_FACEUP)
            and bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
    end
end
function c47579028.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47579028.cfilter,1,nil,e:GetHandler())
end
function c47579028.spfilter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47579028.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47579028.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c47579028.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47579028.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_TRIGGER)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        Duel.SpecialSummonComplete()
    end
end
function c47579028.mfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c47579028.mtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c47579028.mfilter,tp,LOCATION_SZONE,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c47579028.mfilter,tp,LOCATION_SZONE,0,2,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c47579028.penfilter(c)
    return c:IsType(TYPE_CONTINUOUS)  and not c:IsForbidden()
end
function c47579028.msfilter(c)
    return c:IsType(TYPE_MONSTER) 
end
function c47579028.mop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,c47579028.penfilter,tp,LOCATION_DECK,0,1,1,nil)
        local tc=g:GetFirst()
        if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
            local g1=Duel.SelectMatchingCard(tp,c47579028.msfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
            local tc1=g1:GetFirst()
            if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
            local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
            local nseq=math.log(s,2)
            Duel.MoveSequence(tc1,nseq)
        end
    end
end
function c47579028.sccon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function c47579028.xyzfilter(c)
    return c:IsXyzSummonable(nil) and c:IsRank(8) and (c:IsRace(RACE_FAIRY) or c:IsRace(RACE_WYRM) or c:IsRace(RACE_DRAGON))
end
function c47579028.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47579028.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47579028.xyzop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47579028.xyzfilter,tp,LOCATION_EXTRA,0,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=g:Select(tp,1,1,nil)
        Duel.XyzSummon(tp,tg:GetFirst(),nil)
    end
end
function c47579028.nlcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47579028.nlop(e,tp,eg,ep,ev,re,r,rp)
    --disable spsummon
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47579028.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47579028.splimit(e,c,tp,sumtp,sumpos)
    return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end