--迎击的灵刻使
local m=10904022
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetOperation(cm.activate)
    c:RegisterEffect(e0)    
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(45118716,0))
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCondition(cm.condition)
    e1:SetCost(aux.bfgcost)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_DISEFFECT)
        e1:SetValue(cm.effectfilter)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
        Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
    end
function cm.effectfilter(e,ct)
    local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
    local tc=te:GetHandler()
    return tc:IsSetCard(0x237)
end
function cm.cfilter2(c)
    return c:IsFaceup() and c:IsCode(10904015)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return ep==1-tp and Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
    Duel.SetTargetPlayer(1-tp)
    local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_REMOVED,LOCATION_REMOVED)*200
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_REMOVED,LOCATION_REMOVED)*200
    Duel.Damage(p,dam,REASON_EFFECT)
end
