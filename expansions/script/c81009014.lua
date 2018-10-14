--意外的对视
function c81009014.initial_effect(c)
    --Activate(summon)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_SUMMON)
    e1:SetCountLimit(1,81009014+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c81009014.condition1)
    e1:SetTarget(c81009014.target1)
    e1:SetOperation(c81009014.activate1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_SPSUMMON)
    c:RegisterEffect(e3)
    --Activate(effect)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_ACTIVATE)
    e4:SetCode(EVENT_CHAINING)
    e4:SetCountLimit(1,81009014+EFFECT_COUNT_CODE_OATH)
    e4:SetCondition(c81009014.condition2)
    e4:SetTarget(c81009014.target2)
    e4:SetOperation(c81009014.activate2)
    c:RegisterEffect(e4)
    --act in hand
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e5:SetCondition(c81009014.handcon)
    c:RegisterEffect(e5)
end
function c81009014.cfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)
end
function c81009014.condition1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentChain()==0
        and Duel.IsExistingMatchingCard(c81009014.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81009014.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c81009014.activate1(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateSummon(eg)
    Duel.Destroy(eg,REASON_EFFECT)
end
function c81009014.condition2(e,tp,eg,ep,ev,re,r,rp)
    return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
        and Duel.IsExistingMatchingCard(c81009014.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81009014.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c81009014.activate2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function c81009014.cfilter2(c)
    return c:IsFaceup() and c:IsCode(81010019)
end
function c81009014.handcon(e)
    return Duel.IsExistingMatchingCard(c81009014.cfilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
