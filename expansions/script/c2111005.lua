--只为杀戮的纯粹弹幕
local m=2111005
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c2111005.condition)
    e1:SetTarget(c2111005.target)
    e1:SetOperation(c2111005.activate)
    c:RegisterEffect(e1)
end
c2111005.card_code_list={2111001}
function c2111005.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x218)
end
function c2111005.condition(e,tp,eg,ep,ev,re,r,rp)
    local LP=Duel.GetLP(tp)
    return Duel.IsExistingMatchingCard(c2111005.cfilter,tp,LOCATION_MZONE,0,1,nil) and not LP>4000
end
function c2111005.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c2111005.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end