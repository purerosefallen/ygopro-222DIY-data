--九界的繁荣
local m=47591009
local cm=_G["c"..m]
function c47591009.initial_effect(c)
    c:SetUniqueOnField(1,0,47591009)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --Activate
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetCondition(c47591009.cod)
    e3:SetValue(900)
    c:RegisterEffect(e3)
    --activate limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_EXTRA_ATTACK)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetCondition(c47591009.cod)
    e2:SetValue(1)
    c:RegisterEffect(e2)
end
function c47591009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetDecktopGroup(tp,9)
    if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==9
        and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=9 end
    Duel.DisableShuffleCheck()
    Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end     
function c47591009.cfilter(c,tp)
    return c:IsCode(47591299) 
end
function c47591009.cod(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47591009.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c47591009.aclimit(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and not re:GetHandler():IsImmuneToEffect(e)
end