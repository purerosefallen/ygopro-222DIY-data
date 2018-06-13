--传灵 鸟居
local m=22600117
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPIRIT))
    e2:SetValue(500)
    c:RegisterEffect(e2)
    --todeck
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(cm.condition)
    e3:SetCost(cm.cost)
    e3:SetTarget(cm.target)
    e3:SetOperation(cm.operation)
    c:RegisterEffect(e3)
    --inactivatable
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
    e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPIRIT))
    e4:SetRange(LOCATION_FZONE)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_SUMMON_SUCCESS)
    e6:SetCondition(cm.sumcon)
    e6:SetOperation(cm.sumsuc)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e7)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker():GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local at=Duel.GetAttacker()
        return at:IsAbleToDeck()
    end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttacker()
	if at:IsRelateToBattle() then
		Duel.SendtoDeck(at,at:GetControler(),2,REASON_EFFECT)
	end
end
function cm.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_SPIRIT)
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.filter,1,nil)
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetChainLimitTillChainEnd(cm.efun)
end
function cm.efun(e,ep,tp)
    return ep==tp
end