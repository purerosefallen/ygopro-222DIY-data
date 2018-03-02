--绯红色的恶魔 蕾咪
function c2171770.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,6,2)
    c:EnableReviveLimit()
    --Auto Death
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_SELF_DESTROY)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetCondition(c2171770.effcon)
    e2:SetTarget(c2171770.filter)
    e2:SetValue(aux.TRUE)
    c:RegisterEffect(e2)
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(2171770,0))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
    e2:SetCountLimit(1)
    e2:SetCost(c2171770.cost)
    e2:SetOperation(c2171770.atkop)
    c:RegisterEffect(e2)
end
function c2171770.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c2171770.atkop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetValue(-1000)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    Duel.RegisterEffect(e2,tp)
end
function c2171770.effcon(e)
    return e:GetHandler():GetOverlayCount()>0
end
function c2171770.filter(e,c)
    return c:GetAttack()<=1000 and c:IsFaceup() and not c:IsImmuneToEffect(e) and c:IsDestructable()
end