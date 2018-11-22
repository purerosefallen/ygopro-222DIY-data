--调停者 佐伊
local m=47510237
local cm=_G["c"..m]
function c47510237.initial_effect(c)
    --material
    c:EnableReviveLimit() 
    c:EnableReviveLimit()
    aux.AddXyzProcedure(c,c47510237.mfilter,8,2) 
    aux.EnablePendulumAttribute(c,false)   
    --disable
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510237,3))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(c47510237.distg)
    c:RegisterEffect(e1)
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c47510237.atktg)
    e2:SetValue(c47510237.value)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)  
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(c47510237.atkval)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_EXTRA_ATTACK)
    e6:SetValue(c47510237.taval)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e7:SetCode(EVENT_BE_BATTLE_TARGET)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c47510237.fcon)
    e7:SetOperation(c47510237.fop1)
    c:RegisterEffect(e7)
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e9:SetCode(EVENT_BECOME_TARGET)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCondition(c47510237.fcon)
    e9:SetTarget(c47510237.ftg)
    e9:SetOperation(c47510237.fop2)
    c:RegisterEffect(e9)
    --damage
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47510237,1))
    e4:SetCategory(CATEGORY_DAMAGE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCost(c47510237.cost)
    e4:SetTarget(c47510237.target)
    e4:SetOperation(c47510237.operation)
    c:RegisterEffect(e4)
    --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_LEAVE_FIELD)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47510237.tpcon)
    e8:SetTarget(c47510237.tptg)
    e8:SetOperation(c47510237.tpop)
    c:RegisterEffect(e8)  
end
c47510237.pendulum_level=8
function c47510237.atkval(e,c)
    local g=Duel.GetMatchingGroup(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil,TYPE_MONSTER)
    return g:GetClassCount(Card.GetAttribute)*500
end
function c47510237.taval(e,c)
    local g=Duel.GetMatchingGroup(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil,TYPE_MONSTER)
    return g:GetClassCount(Card.GetAttribute)-1
end
function c47510237.distg(e,c)
    return c:IsType(TYPE_LINK)
end
function c47510237.mfilter(c)
    return c:IsLevel(8) and c:IsType(TYPE_PENDULUM)
end
function c47510237.atktg(e,c)
    return c:IsType(TYPE_MONSTER)
end
function c47510237.value(e,c)
    local tp=e:GetHandlerPlayer()
    local att=0
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        att=bit.bor(att,tc:GetAttribute())
        tc=g:GetNext()
    end
    local ct=0
    while att~=0 do
        if bit.band(att,0x1)~=0 then ct=ct+1 end
        att=bit.rshift(att,1)
    end
    return ct*500
end
function c47510237.tpcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47510237.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47510237.tpop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c47510237.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47510237.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c47510237.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Damage(p,d,REASON_EFFECT) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_CHAINING)
        e1:SetOperation(c47510237.chainop)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e3:SetCode(EVENT_CHAINING)
        e3:SetOperation(c47510237.chainop1)
        e3:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e3,1-tp)
    end
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c47510237.efftg)
    e2:SetValue(aux.tgoval)
    e2:SetReset(RESET_PHASE+PHASE_END)
    c:RegisterEffect(e2)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetValue(c47510237.atlimit)
    e4:SetReset(RESET_PHASE+PHASE_END)
    c:RegisterEffect(e4) 
end
function c47510237.atlimit(e,c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c~=e:GetHandler()
end
function c47510237.efftg(e,c)
    return c~=e:GetHandler()
end
function c47510237.chainop(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():IsType(TYPE_PENDULUM) and re:IsActiveType(TYPE_MONSTER) and ep==tp then
        Duel.SetChainLimit(c47510237.chainlm)
    end
end
function c47510237.chainlm(e,rp,tp)
    return tp==rp
end
function c47510237.chainop1(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp then
        Duel.SetChainLimit(c47510237.chainlm1)
    end
end
function c47510237.chainlm1(e,rp,tp)
    return tp~=rp
end
function c47510237.fcon(e)
    return e:GetHandler():GetFlagEffect(47510237)<2
end
function c47510237.fop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.NegateAttack() then
    c:RegisterFlagEffect(47510237,RESET_EVENT+RESETS_STANDARD,0,1)
    end
end
function c47510237.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c47510237.fop2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if Duel.NegateEffect(ev) then
    c:RegisterFlagEffect(47510237,RESET_EVENT+RESETS_STANDARD,0,1)
    end
end