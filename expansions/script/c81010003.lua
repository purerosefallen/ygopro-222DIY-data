--本田未央
function c81010003.initial_effect(c)
    --link summon
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_TOKEN),3,3)
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(c81010003.value)
    c:RegisterEffect(e1)
    --negate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(81010003,1))
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
    e2:SetCode(EVENT_CHAINING)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCountLimit(1)
    e2:SetCondition(c81010003.negcon)
    e2:SetCost(c81010003.negcost)
    e2:SetTarget(c81010003.negtg)
    e2:SetOperation(c81010003.negop)
    c:RegisterEffect(e2)
end
function c81010003.filter(c)
    return c:IsType(TYPE_TOKEN)
end
function c81010003.value(e,c)
    return Duel.GetMatchingGroupCount(c81010003.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)*800
end
function c81010003.negcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
        and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c81010003.cfilter(c)
    return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c81010003.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c81010003.cfilter,1,nil) end
    local g=Duel.SelectReleaseGroup(tp,c81010003.cfilter,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function c81010003.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return re:GetHandler():IsAbleToRemove() end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
    end
end
function c81010003.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
    end
end
