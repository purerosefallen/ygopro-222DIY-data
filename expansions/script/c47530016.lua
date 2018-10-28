--死亡骑士
local m=47530016
local cm=_G["c"..m]
function c47530016.initial_effect(c)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),10,2)
    --immune
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47530016,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c47530016.inmcon)
    e1:SetCost(c47530016.cost)
    e1:SetOperation(c47530016.operation)
    c:RegisterEffect(e1)   
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47530016,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,47530016)
    e2:SetCondition(c47530016.spcon)
    e2:SetTarget(c47530016.sptg)
    e2:SetOperation(c47530016.spop)
    c:RegisterEffect(e2)  
end
function c47530016.inmcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c47530016.mfilter(c,xyzc)
    return (c:IsLevel(10) and c:IsRace(RACE_MACHINE)) or (c:IsType(TYPE_LINK) and c:IsLinkAbove(2) and c:IsRace(RACE_MACHINE))
end
function c47530016.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c47530016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47530016.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetValue(c47530016.efilter)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_EXTRA_ATTACK)
        e2:SetValue(1)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        c:RegisterEffect(e2)
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_UPDATE_ATTACK)
        e3:SetValue(1000)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        c:RegisterEffect(e3)
    end
end
function c47530016.efilter(e,re)
    return e:GetHandler()~=re:GetOwner()
end
function c47530016.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c47530016.spfilter2(c,e,tp)
    return c:IsSetCard(0x5d5) and not c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47530016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
        and Duel.IsExistingMatchingCard(c47530016.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47530016.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47530016.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end