--空域炮 
function c47500033.initial_effect(c)
    --act in hand
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e0:SetCondition(c47500033.handcon)
    c:RegisterEffect(e0)  
    --Fuck Conter
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetCondition(c47500033.chcon)
    e1:SetTarget(c47500033.negtg)
    e1:SetOperation(c47500033.negop)
    c:RegisterEffect(e1)   
    c47500033.act_effect=e1
end
c47500033.card_code_list={47500000}
function c47500033.handcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c47500033.chcon(e,tp,eg,ep,ev,re,r,rp)
    local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    return ep~=tp and (re:IsActiveType(TYPE_COUNTER) and loc==LOCATION_HAND) and re:GetActivityCount()==re:
end
function c47500033.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return re:GetHandler():IsAbleToRemove() end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
    end
    if Duel.GetTurnPlayer()==tp then
        Duel.SetChainLimit(aux.TRUE)
    end
end
function c47500033.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
        e1:SetTarget(c47500033.distg)
        e1:SetLabel(re:GetHandler():GetOriginalCode())
        e1:SetReset(RESET_PHASE+PHASE_END,2)
        Duel.RegisterEffect(e1,tp)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_CHAIN_SOLVING)
        e2:SetCondition(c47500033.discon)
        e2:SetOperation(c47500033.disop)
        e2:SetLabel(re:GetHandler():GetOriginalCode())
        e2:SetReset(RESET_PHASE+PHASE_END,2)
        Duel.RegisterEffect(e2,tp)
    end
end
function c47500033.distg(e,c)
    local code=e:GetLabel()
    local code1,code2=c:GetOriginalCodeRule()
    return code1==code or code2==code
end
function c47500033.discon(e,tp,eg,ep,ev,re,r,rp)
    local code=e:GetLabel()
    local code1,code2=re:GetHandler():GetOriginalCodeRule()
    return re:IsActiveType(TYPE_MONSTER) and (code1==code or code2==code)
end
function c47500033.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end