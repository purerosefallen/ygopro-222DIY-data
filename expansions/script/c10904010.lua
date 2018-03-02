--灵刻使的强袭
local m=10904010
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(cm.scon)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)      
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
    local tp=e:GetHandler():GetControler()
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if not tc1 or not tc2 then return false end
    return tc1:GetLeftScale()==tc2:GetRightScale()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
        Duel.SetTargetPlayer(1-tp)
        Duel.SetTargetParam(700)
        Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,700) 
end 
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tp=e:GetHandler():GetControler()
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) and  tc1:GetLeftScale()==tc2:GetRightScale() and tc1:GetLeftScale()<2 then
        Duel.BreakEffect()
        c:CancelToGrave()
        Duel.ChangePosition(c,POS_FACEDOWN)
        Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
    else if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
        Duel.Damage(p,d,REASON_EFFECT) 
    if c:IsRelateToEffect(e) and c:IsCanTurnSet() and tc1:GetLeftScale()==tc2:GetRightScale() and tc1:GetLeftScale()<2 then
        Duel.BreakEffect()
        c:CancelToGrave()
        Duel.ChangePosition(c,POS_FACEDOWN)
        Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
        e1:SetTarget(cm.distg)
        e1:SetLabel(tc:GetOriginalCode())
        e1:SetReset(RESET_PHASE+PHASE_END,2)
        Duel.RegisterEffect(e1,tp)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_CHAIN_SOLVING)
        e2:SetCondition(cm.discon)
        e2:SetOperation(cm.disop)
        e2:SetLabel(tc:GetOriginalCode())
        e2:SetReset(RESET_PHASE+PHASE_END,2)
        Duel.RegisterEffect(e2,tp)
    end
end
end
end
function cm.distg(e,c)
    local code=e:GetLabel()
    local code1,code2=c:GetOriginalCodeRule()
    return code1==code or code2==code
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    local code=e:GetLabel()
    local code1,code2=re:GetHandler():GetOriginalCodeRule()
    return (code1==code or code2==code)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end