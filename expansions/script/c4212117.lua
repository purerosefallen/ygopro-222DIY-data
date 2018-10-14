--驱影之阳-星河圣罗
function c4212117.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,nil,2,2,function(g,lc)return g:IsExists(Card.IsCode,1,nil,4212017) end)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(4212117,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,4212117)
    e1:SetCondition(c4212117.hspcon)
    e1:SetTarget(c4212117.hsptg)
    e1:SetOperation(c4212117.hspop)
    c:RegisterEffect(e1)
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c4212117.indtg)
    e2:SetValue(1)
    c:RegisterEffect(e2)
end
function c4212117.hspcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c4212117.hspfilter(c,e,tp)
    return c:IsSetCard(0xa2a) and c:IsType(TYPE_MONSTER) and not c:IsCode(4212017) 
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c4212117.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c4212117.hspfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c4212117.hspop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c4212117.hspfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c4212117.indtg(e,c)
    return c:GetMutualLinkedGroupCount()>0
end