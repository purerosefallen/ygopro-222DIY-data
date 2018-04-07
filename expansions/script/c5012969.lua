--湿婆
function c5012969.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure2(c,c5012969.synfilter,c5012969.synfilter2)
    --atk/def
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE))
    e1:SetValue(c5012969.val)
    c:RegisterEffect(e1)
    --destroy2
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(5012969,0))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL)
    e2:SetTarget(c5012969.target)
    e2:SetOperation(c5012969.operation)
    c:RegisterEffect(e2)
end
function c5012969.synfilter2(c)
    return c5012969.synfilter(c) and c:IsNotTuner()
end
function c5012969.synfilter(c)
    return c:GetLevel()==6 and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_SYNCHRO)
end
function c5012969.val(e,c)
    return c:GetAttack()*2
end
function c5012969.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
    Duel.SetChainLimit(aux.FALSE)
end
function c5012969.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
end