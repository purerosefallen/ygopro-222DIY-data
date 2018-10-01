--西北西的守护神 瓦吉拉
local m=47520007
local cm=_G["c"..m]
function c47520007.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_MONSTER),3,4,c47520007.lcheck)
    c:EnableReviveLimit()   
    --Immunity
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_EXTRA_ATTACK)
    e1:SetValue(1)
    c:RegisterEffect(e1)  
    --Immunity
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetValue(c47520007.efilter2)
    c:RegisterEffect(e2)  
    --spssummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47520007,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c47520007.sptg)
    e3:SetOperation(c47520007.spop)
    c:RegisterEffect(e3) 
    --kyoufu
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47520007,1))
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(c47520007.kftg)
    e4:SetOperation(c47520007.kfop)
    c:RegisterEffect(e4)
end
function c47520007.lcheck(g)
    return g:IsExists(Card.IsLinkSetCard,1,nil,0x5dd) or g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER)
end
function c47520007.efilter2(e,re,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    return not g:IsContains(e:GetHandler())
end
function c47520007.spfilter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and (c:IsRace(RACE_BEAST) or c:IsRace(RACE_BEASTWARRIOR)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47520007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47520007.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,ev) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47520007.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47520007.spfilter),tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
        tc:RegisterEffect(e2)
        Duel.SpecialSummonComplete()
    end
end
function c47520007.filter(c)
    return c:IsType(TYPE_MONSTER)
end
function c47520007.kftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c47520007.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47520007.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c47520007.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c47520007.kfop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_CANNOT_TRIGGER)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
        e3:SetRange(LOCATION_MZONE)
        e3:SetCode(EFFECT_IMMUNE_EFFECT)
        e3:SetValue(c47520007.efilter)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
    end
end
function c47520007.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end