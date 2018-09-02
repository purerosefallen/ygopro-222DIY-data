--黄天裁考 异化沃夫玛纳夫
local m=47510107
local cm=_G["c"..m]
function c47510107.initial_effect(c)
    c:SetSPSummonOnce(47510107)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedure(c,c47510107.mfilter,8,2)
    --Divine Immortality
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetDescription(aux.Stringid(47510107,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47510107+EFFECT_COUNT_CODE_DUEL)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetCondition(c47510107.rvcon)
    e1:SetOperation(c47510107.rvop)
    c:RegisterEffect(e1)
    --summon success
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(c47510107.sumcon)
    e2:SetOperation(c47510107.sumsuc)
    c:RegisterEffect(e2)
    --Avest
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47510107,1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,47510108)
    e3:SetCost(c47510107.cost)
    e3:SetOperation(c47510107.op1)
    c:RegisterEffect(e3)
    --Navjote
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47510107,2))
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,47510108)
    e4:SetCost(c47510107.cost)
    e4:SetOperation(c47510107.op2)
    c:RegisterEffect(e4)
    --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(47510107,3))
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_DESTROYED)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47510107.pencon)
    e8:SetTarget(c47510107.pentg)
    e8:SetOperation(c47510107.penop)
    c:RegisterEffect(e8)   
end
c47510107.pendulum_level=8
function c47510107.mfilter(c,xyzc)
    return c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_EARTH)
end
function c47510107.rvcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLP(tp)<=1000
end
function c47510107.rvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
    Duel.SetLP(tp,6000)
    end
end
function c47510107.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c47510107.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
        local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_IMMUNE_EFFECT)
        e4:SetValue(c47510107.efilter)
        e4:SetOwnerPlayer(tp)
        e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e4)
end
function c47510107.efilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c47510107.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47510107.op1(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetTargetRange(0,LOCATION_ONFIELD)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetValue(c47510107.efilter1)
    Duel.RegisterEffect(e1,tp)
end
function c47510107.efilter1(e,te)
    return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end 
function c47510107.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c47510107.immtg)
    e1:SetValue(c47510107.efilter2)
    c:RegisterEffect(e1)
    end
end
function c47510107.immtg(e,c)
    return c~=e:GetHandler()
end
function c47510107.efilter2(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c47510107.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47510107.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47510107.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end