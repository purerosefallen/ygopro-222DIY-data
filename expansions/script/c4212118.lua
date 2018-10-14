--驱影之阳-月咏留奈
function c4212118.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,nil,2,2,function(g,lc)return g:IsExists(Card.IsCode,1,nil,4212018) end) 
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(4212118,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,4212118)
    e1:SetCondition(c4212118.hspcon)
    e1:SetTarget(c4212118.hsptg)
    e1:SetOperation(c4212118.hspop)
    c:RegisterEffect(e1)
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c4212118.indtg)
    e2:SetValue(1)
    c:RegisterEffect(e2)
end
function c4212118.hspcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c4212118.hspfilter(c,e,tp)
    return c:IsSetCard(0xa2a) and c:IsType(TYPE_MONSTER) and not c:IsCode(4212018) and c:IsAbleToHand()
end
function c4212118.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c4212118.hspfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c4212118.hspop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c4212118.hspfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
    Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c4212118.indtg(e,c)
    return c:GetMutualLinkedGroupCount()>0
end