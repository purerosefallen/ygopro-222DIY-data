--无色辉火
local m=75646501
local cm=_G["c"..m]
function cm.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
    --Destroy
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(cm.destg)
    e1:SetOperation(cm.desop)
    c:RegisterEffect(e1)
    --damage after destruction
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCondition(cm.damcon)
    e2:SetTarget(cm.damtg)
    e2:SetOperation(cm.damop)
    c:RegisterEffect(e2)
end
function cm.filter(c)
    return c:IsLinkState()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)
    if chk==0 then return g:GetCount()>0 end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
        and c:IsPreviousPosition(POS_FACEUP)
end
function cm.filter1(c)
    return c:IsType(TYPE_MONSTER)
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
    Duel.SetChainLimit(aux.FALSE)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        local dg=Duel.GetOperatedGroup()
        local tc=dg:GetFirst()
        local atk=0
        while tc do
            local tatk=tc:GetTextAttack()
            if tatk>0 then atk=atk+tatk end
            tc=dg:GetNext()
        end
        Duel.Damage(1-tp,atk,REASON_EFFECT)
    end
end