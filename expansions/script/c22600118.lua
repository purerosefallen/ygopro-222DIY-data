--鬼脸精灵 火噬
local m=22600118
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate(effect)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(cm.condition)
    e1:SetCost(cm.cost)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    --act in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e2:SetCondition(cm.handcon)
    c:RegisterEffect(e2)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return rp~=tp and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function cm.filter(c,e)
    return c:IsSetCard(0x261) and c:IsDiscardable() and not e:GetHandler()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e) end
    Duel.DiscardHand(tp,cm.filter,1,1,REASON_COST+REASON_DISCARD,e)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function cm.cfilter(c)
    return c:IsFacedown() or not c:IsType(TYPE_SPIRIT)
end
function cm.handcon(e)
    return not Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil,e)
end