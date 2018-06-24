--白玉 斯斯理麻糬
local m=14801215
local cm=_G["c"..m]
function cm.initial_effect(c)
    --atkdef 0
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(cm.condition)
    e1:SetCost(cm.cost)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    if not d then return false end
    if a:IsControler(1-tp) then a,d=d,a end
    return a:IsSetCard(0x4812) and a:IsRelateToBattle() and (d:GetAttack()>0 or d:GetDefense()>0)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    if a:IsControler(1-tp) then d=a end
    if not d:IsRelateToBattle() or d:IsFacedown() then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e1:SetValue(0)
    d:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
    d:RegisterEffect(e2)
end
