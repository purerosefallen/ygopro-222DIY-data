--夏游的调停者 佐伊
local m=47510235
local cm=_G["c"..m]
function c47510235.initial_effect(c)
    --material
    c:EnableReviveLimit() 
    aux.AddXyzProcedureLevelFree(c,c47510235.mfilter,c47510235.xyzcheck,2,2)
    aux.EnablePendulumAttribute(c,false)   
    --disable
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(c47510235.distg)
    c:RegisterEffect(e1)
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c47510235.atktg)
    e2:SetValue(c47510235.value)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
    --damage
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47510235,0))
    e4:SetCategory(CATEGORY_DAMAGE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCost(c47510235.cost)
    e4:SetTarget(c47510235.target)
    e4:SetOperation(c47510235.operation)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47510235,1))
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCountLimit(1,47510235+EFFECT_COUNT_CODE_DUEL)
    e5:SetCost(c47510235.lpcost)
    e5:SetOperation(c47510235.hsop)
    c:RegisterEffect(e5)
    --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_LEAVE_FIELD)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47510235.tpcon)
    e8:SetTarget(c47510235.tptg)
    e8:SetOperation(c47510235.tpop)
    c:RegisterEffect(e8)  
end
c47510235.pendulum_level=8
function c47510235.distg(e,c)
    return c:IsType(TYPE_LINK)
end
function c47510235.mfilter(c)
    return c:IsLevel(8)
end
function c47510235.xyzcheck(g)
    return g:GetClassCount(Card.GetAttribute)==g:GetCount()
end
function c47510235.tpcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47510235.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47510235.tpop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c47510235.atktg(e,c)
    return c:IsType(TYPE_MONSTER)
end
function c47510235.value(e,c)
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
function c47510235.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47510235.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(700)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,700)
end
function c47510235.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Damage(p,d,REASON_EFFECT) then
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(c47510235.val)
        e1:SetReset(RESET_PHASE+PHASE_END,2)
        c:RegisterEffect(e1)
    end
end
function c47510235.val(e,c)
    return math.abs(Duel.GetLP(0)-Duel.GetLP(1))
end
function c47510235.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetLP(tp,1)
end
function c47510235.hsop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetValue(0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetReset(RESET_PHASE+PHASE_END)
    e3:SetValue(1)
    Duel.RegisterEffect(e3,tp)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    Duel.RegisterEffect(e4,tp)
    local e5=e3:Clone()
    e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    Duel.RegisterEffect(e5,tp)    
end