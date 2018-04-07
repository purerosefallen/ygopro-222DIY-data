--连锁束缚
function c60159912.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,60159912+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c60159912.condition)
    e1:SetOperation(c60159912.activate)
    c:RegisterEffect(e1)
end

function c60159912.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentChain()>2
end
function c60159912.activate(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAINING)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetOperation(c60159912.chainop)
    Duel.RegisterEffect(e1,tp)
end
function c60159912.chainop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetChainLimit(aux.FALSE)
end