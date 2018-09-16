--冰狱大帝 异化科库托斯
local m=47510119
local cm=_G["c"..m]
function c47510119.initial_effect(c)
    c:SetSPSummonOnce(47510119)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedure(c,c47510119.mfilter,8,2)   
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510119,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47510119+EFFECT_COUNT_CODE_DUEL)
    e1:SetCondition(c47510119.descon)
    e1:SetTarget(c47510119.destg)
    e1:SetOperation(c47510119.desop)
    c:RegisterEffect(e1)
    local e11=e1:Clone()
    e11:SetCondition(c47510119.descon2)
    c:RegisterEffect(e11)
    --RACE_DRAGON
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_ADD_RACE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(RACE_DRAGON)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetRange(LOCATION_EXTRA)
    c:RegisterEffect(e3)
    local e4=e2:Clone()
    e4:SetRange(LOCATION_GRAVE)
    c:RegisterEffect(e4)
    --Judecca
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47510119,0))
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetCondition(c47510119.lpcon)
    e5:SetOperation(c47510119.lpop)
    c:RegisterEffect(e5)
    --Antenora
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(47510119,1))
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCountLimit(1)
    e8:SetCondition(c47510119.bacon)
    e8:SetCost(c47510119.cost)
    e8:SetOperation(c47510119.op)
    c:RegisterEffect(e8)
    --pendulum
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e10:SetCode(EVENT_DESTROYED)
    e10:SetProperty(EFFECT_FLAG_DELAY)
    e10:SetCondition(c47510119.pencon)
    e10:SetTarget(c47510119.pentg)
    e10:SetOperation(c47510119.penop)
    c:RegisterEffect(e10)  
end
function c47510119.bacon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c47510119.mfilter(c,xyzc)
    return c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_WATER)
end
function c47510119.cfilter(c,tp)
    return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and (c:IsReason(REASON_DESTROY) and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp or c:IsReason(REASON_BATTLE) and Duel.GetTurnPlayer()==1-tp) and c:IsType(TYPE_MONSTER)
end
function c47510119.descon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47510119.cfilter,1,nil,tp) and Duel.GetLP(tp)<=4000
end
function c47510119.descon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil and Duel.GetLP(tp)<=4000
end
function c47510119.filter(c)
    return c:IsAbleToRemove()
end
function c47510119.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510119.filter,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(c47510119.filter,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c47510119.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47510119.filter,tp,0,LOCATION_ONFIELD,nil)
    if g:GetCount()>0 then
        Duel.Remove(g,REASON_EFFECT,POS_FACEDOWN)
    end
end
function c47510119.lpcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c47510119.lpop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetLP(tp,4000)
end
function c47510119.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47510119.filter2(c)
    return c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or c:IsType(TYPE_EFFECT)) and not c:IsDisabled()
end
function c47510119.filter3(c)
    return c:IsType(TYPE_MONSTER) and c:IsCanChangePosition()
end
function c47510119.op(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.TossDice(tp,1)
    if d==1 or d==2 then 
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,1)
    e1:SetCondition(c47510119.accon)
    e1:SetValue(1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    elseif d==3 then
    local c=e:GetHandler()
        if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetValue(2)
        c:RegisterEffect(e1) 
        end
    elseif d==4 or d==5 then
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c47510119.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
    local tc=g:GetFirst()
    while tc do 
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
    elseif d==6 then 
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c47510119.filter3,tp,0,LOCATION_MZONE,nil)
    Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_PIERCE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetValue(1)
    Duel.RegisterEffect(e1,tp)
    end
end
function c47510119.accon(e)
    local ph=Duel.GetCurrentPhase()
    return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c47510119.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47510119.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47510119.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end