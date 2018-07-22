--九界的繁荣
local m=100001009
local cm=_G["c"..m]
function c100001009.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,100001009+EFFECT_COUNT_CODE_DUEL)
    e1:SetCost(c100001009.cost)
    c:RegisterEffect(e1)
    --Activate
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetCondition(c100001009.cod)
    e3:SetValue(900)
    c:RegisterEffect(e3)
    --activate limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(0,1)
    e2:SetCondition(c100001009.cod)
    e2:SetValue(c100001009.aclimit)
    c:RegisterEffect(e2)
end
function c100001009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,7) end
    Duel.DiscardDeck(tp,7,REASON_COST)
end       
function c100001009.cfilter(c,tp)
    return c:IsCode(1103991299) 
end
function c100001009.cod(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c100001009.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
    local ph=Duel.GetCurrentPhase()
    return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c100001009.aclimit(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and not re:GetHandler():IsImmuneToEffect(e)
end