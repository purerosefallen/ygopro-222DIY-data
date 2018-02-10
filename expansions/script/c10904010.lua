--灵刻使的强袭
local m=10904010
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
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
    local tp=e:GetHandler():GetControler()
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    local dm1=tc1:GetLeftScale()
    local dm2=tc2:GetRightScale()
    if dm1==0 and dm2==0    
    then e:SetLabel(1) 
    else e:SetLabel(0)  
    end 
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    if e:GetLabel()==1 then e:SetCategory(CATEGORY_REMOVE)
    else
        e:SetCategory(CATEGORY_DAMAGE)
        Duel.SetTargetPlayer(1-tp)
        Duel.SetTargetParam(dm1*300)
        Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dm1*300) end 
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT) end
    if e:GetLabel()==0 then
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
        Duel.Damage(p,d,REASON_EFFECT)
    else if e:GetLabel()==1 and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        local og=Duel.GetOperatedGroup()
        local rg=Group.CreateGroup()
        local rm=og:GetFirst()
        local sg=Duel.GetMatchingGroup(Card.IsCode,tc:GetControler(),0x53,0,nil,rm:GetCode())
              rg:Merge(sg)           
              rm=og:GetNext()       
        if rg:GetCount()>0 then
            Duel.BreakEffect()
            Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
        end
    end
    end
    end