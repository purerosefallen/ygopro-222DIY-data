--ReLiveStage-Operantom
local m=20100112
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveStage(c) 
    --Activate1
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m-4,1))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.target)
    e1:SetCondition(Cirn9.nanacon1)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)    
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_HAND)
    e2:SetHintTiming(TIMING_DAMAGE_STEP)
    e2:SetCondition(cm.atkcon)
    e2:SetCost(cm.atkcost1)
    e2:SetTarget(cm.atktg)
    e2:SetOperation(cm.atkop1)
    c:RegisterEffect(e2)
    --finish act
    local e3=Cirn9.FinishAct(c)
    --e3:SetCategory(CATEGORY_ATKCHANGE)
    --e3:SetTarget(cm.fatg)
    e3:SetOperation(cm.faop)
    c:RegisterEffect(e3)
    --to deck
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,2))
    e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCondition(cm.retcon)
    e4:SetTarget(cm.rettg)
    e4:SetOperation(cm.retop)
    c:RegisterEffect(e4)
    cm.FinishAct=e3
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLP(tp)>=1500 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp,chk)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local lp0=Duel.GetLP(tp)
    if lp0>=1500 then
        Duel.SetLP(tp,lp0-1500)
    else
        Duel.SetLP(tp,0)
    end
    Cirn9.RevueBgm(tp)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function cm.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.atkfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc99)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.atkfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,cm.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.atkop1(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end

function cm.desfilter(c,tp)
    return c:IsReason(REASON_DESTROY) and c:GetReasonPlayer()==1-tp and c:GetPreviousControler()==tp and c:IsSetCard(0xc99)
        and c:IsType(TYPE_MONSTER)
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.desfilter,1,nil,tp)
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Damage(1-tp,1000,REASON_EFFECT)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
    if #g>0 then
        Duel.HintSelection(g)
        Duel.Destroy(g,REASON_EFFECT)
    end
end
function cm.fafilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc99)
end
function cm.faop(e,tp,eg,ep,ev,re,r,rp,chk)
    if not Duel.IsExistingMatchingCard(cm.fafilter,tp,LOCATION_MZONE,0,2,nil) then return end
    local sg=Duel.SelectMatchingCard(tp,cm.fafilter,tp,LOCATION_MZONE,0,2,2,nil)
    Duel.HintSelection(sg)
    Duel.BreakEffect()
    local c=e:GetHandler()
    local fc=sg:GetFirst()
    while fc do
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e3:SetRange(LOCATION_MZONE)
        e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e3:SetValue(1)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        fc:RegisterEffect(e3)
        local e4=e3:Clone()
        e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        fc:RegisterEffect(e4)
        local e5=Effect.CreateEffect(c)
        e5:SetType(EFFECT_TYPE_SINGLE)
        e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e5:SetRange(LOCATION_MZONE)
        e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
        e5:SetValue(aux.tgoval)
        e5:SetReset(RESET_EVENT+RESETS_STANDARD)
        fc:RegisterEffect(e5)
        fc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
        fc=sg:GetNext()
    end
end