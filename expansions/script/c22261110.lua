--欢迎光临，这美妙的残杀空间
function c22261110.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_BATTLE_START)
    e1:SetCountLimit(1,22261110+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c22261110.condition)
    e1:SetTarget(c22261110.atktg)
    e1:SetOperation(c22261110.activate)
    c:RegisterEffect(e1)
end
--
c22261110.Desc_Contain_NanayaShiki=1
function c22261110.IsNanayaShiki(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_NanayaShiki
end
--
function c22261110.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()==PHASE_BATTLE_START and Duel.GetTurnPlayer()==tp
end
function c22261110.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function c22261110.activate(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_EXTRA_ATTACK)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c22261110.indtg)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetValue(16)
    Duel.RegisterEffect(e1,tp)
end
function c22261110.indtg(e,c)
    return c22261110.IsNanayaShiki(c)
end