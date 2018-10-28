--超级高达
local m=47530009
local cm=_G["c"..m]
function c47530009.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),2,2)
    c:EnableReviveLimit()  
    --effect gian
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e0:SetCode(EVENT_ADJUST)
    e0:SetRange(LOCATION_MZONE)
    e0:SetOperation(c47530009.efop)
    c:RegisterEffect(e0)  
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c47530009.eqtg)
    e1:SetOperation(c47530009.eqop)
    c:RegisterEffect(e1)  
    --dashitsu
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(c47530009.lscon)
    e2:SetTarget(c47530009.lstg)
    e2:SetOperation(c47530009.lsop)
    c:RegisterEffect(e2)
end
function c47530009.filter(c)
    return c:IsRace(RACE_MACHINE) and not c:IsForbidden()
end
function c47530009.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c47530009.filter,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c47530009.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,c47530009.filter,tp,LOCATION_GRAVE,0,1,1,nil,c)
    local tc=g:GetFirst()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        if not Duel.Equip(tp,tc,c,true) then return end
        --Add Equip limit
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c47530009.eqlimit)
        tc:RegisterEffect(e1)
    else Duel.SendtoGrave(tc,REASON_RULE) end
end
function c47530009.eqlimit(e,c)
    return e:GetOwner()==c
end
function c47530009.rtgfilter(c)
    return c:GetOriginalType(TYPE_MONSTER) and c:GetOriginalType(TYPE_EFFECT)
end
function c47530009.efop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()  
    local eq=c:GetEquipGroup(c47530009.rtgfilter,1,nil,tp)
    local wg=eq:Filter(c47530009.rtgfilter,nil,tp)
    local wbc=wg:GetFirst()
    while wbc do
        local code=wbc:GetOriginalCode()
        if c:IsFaceup() and c:GetFlagEffect(code)==0 then
        c:CopyEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING, 1)
        c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)  
        end 
        wbc=wg:GetNext()
    end  
end
function c47530009.lscon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_DESTROY) and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c47530009.spfilter(c,e,tp)
    return c:IsType(TYPE_LINK) and c:IsLinkBelow(2) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function c47530009.lstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
        and Duel.IsExistingMatchingCard(c47530009.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c47530009.lsop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47530009.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,SUMMON_TYPE_LINK,tp,tp,true,false,POS_FACEUP)
        g:CompleteProcedure()
    end
end