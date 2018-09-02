--T·F Ratchet
function c50218201.initial_effect(c)
    --pos
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c50218201.poscon)
    e1:SetOperation(c50218201.posop)
    c:RegisterEffect(e1)
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,50218201)
    e2:SetCondition(c50218201.cona)
    e2:SetTarget(c50218201.dtarget)
    e2:SetOperation(c50218201.dactivate)
    c:RegisterEffect(e2)
    --recover
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_RECOVER)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,502182010)
    e3:SetCondition(c50218201.cond)
    e3:SetTarget(c50218201.rtarget)
    e3:SetOperation(c50218201.ractivate)
    c:RegisterEffect(e3)
end
function c50218201.poscon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsAttackPos()
end
function c50218201.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsAttackPos() then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    end
end
function c50218201.cona(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsDisabled() and e:GetHandler():IsAttackPos()
end
function c50218201.cond(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsDisabled() and e:GetHandler():IsDefensePos()
end
function c50218201.dtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    Duel.SetTargetPlayer(1-tp)
    local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)*500
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c50218201.dactivate(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)*500
    Duel.Damage(p,dam,REASON_EFFECT)
end
function c50218201.rtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 end
    local rec=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)*500
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(rec)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c50218201.ractivate(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local rec=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)*500
    Duel.Recover(p,rec,REASON_EFFECT)
end