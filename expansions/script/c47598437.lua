--时空创世•α
function c47598437.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,47598437)
    e1:SetTarget(c47598437.target)
    e1:SetOperation(c47598437.activate)
    c:RegisterEffect(e1) 
    --extra summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,47598438)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c47598437.extg)
    e2:SetOperation(c47598437.exop)
    c:RegisterEffect(e2)   
end
function c47598437.filter(c,e,tp)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAttack(0) and c:IsDefense(1800) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47598437.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47598437.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47598437.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47598437.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
        e3:SetValue(1)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e3)
    end
    Duel.SpecialSummonComplete()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47598437.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c47598437.splimit(e,c)
    return not ((c:IsAttackAbove(2000) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT)) or (c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRank(8))) and c:IsLocation(LOCATION_EXTRA)
end
function c47598437.extg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) end
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c47598437.splimit)
    Duel.RegisterEffect(e2,tp)
end
function c47598437.exop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(47598437,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
    e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e1:SetTarget(c47598437.estg)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47598437.estg(e,c)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelAbove(5) and c:IsAttackAbove(2500)
end