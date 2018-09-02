--六崩的领悟
local m=47591006
local cm=_G["c"..m]
function c47591006.initial_effect(c)
    --multi attack
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,47591006)
    e1:SetCost(c47591006.cost)
    e1:SetCondition(c47591006.mtcon)
    e1:SetTarget(c47591006.target)
    e1:SetOperation(c47591006.mtop)
    c:RegisterEffect(e1)
end
function c47591006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetDecktopGroup(tp,6)
    if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==6
        and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=6 end
    Duel.DisableShuffleCheck()
    Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c47591006.mtcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsAbleToEnterBP() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=6
end
function c47591006.filter(c)
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLocation(LOCATION_MZONE)
end
function c47591006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c47591006.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47591006.filter,tp,LOCATION_MZONE,0,1,nil) end
    local g=Duel.SelectTarget(tp,c47591006.filter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function c47591006.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.ConfirmDecktop(tp,6)
    local g=Duel.GetDecktopGroup(tp,6)
    local tc=Duel.GetFirstTarget()
    local ct=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)
    Duel.ShuffleDeck(tp)
    if ct>1 and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetValue(ct-1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end