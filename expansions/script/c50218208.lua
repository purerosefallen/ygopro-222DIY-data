--T·F Grindor
function c50218208.initial_effect(c)
    --pos
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c50218208.poscon)
    e1:SetOperation(c50218208.posop)
    c:RegisterEffect(e1)
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,50218208)
    e2:SetCondition(c50218208.cona)
    e2:SetCost(c50218208.cost)
    e2:SetTarget(c50218208.target)
    e2:SetOperation(c50218208.operation)
    c:RegisterEffect(e2)
    --handes
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_HANDES)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,502182080)
    e3:SetCondition(c50218208.cond)
    e3:SetCost(c50218208.cost)
    e3:SetTarget(c50218208.hdtg)
    e3:SetOperation(c50218208.hdop)
    c:RegisterEffect(e3)
end
function c50218208.poscon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsAttackPos()
end
function c50218208.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsAttackPos() then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    end
end
function c50218208.cona(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsDisabled() and e:GetHandler():IsAttackPos()
end
function c50218208.cond(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsDisabled() and e:GetHandler():IsDefensePos()
end
function c50218208.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,500) end
    Duel.PayLPCost(tp,500)
end
function c50218208.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c50218208.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function c50218208.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c50218208.hdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
    if g:GetCount()==0 then return end
    local sg=g:RandomSelect(1-tp,1)
    Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end