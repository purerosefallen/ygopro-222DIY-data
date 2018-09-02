--紫电的黎明 麒麟
local m=47511003
local cm=_G["c"..m]
function c47511003.initial_effect(c)
    c:SetSPSummonOnce(47511003)
    --material
    c:EnableReviveLimit() 
    aux.AddXyzProcedureLevelFree(c,c47511003.mfilter,c47511003.xyzcheck,2,99)
    aux.EnablePendulumAttribute(c,false)  
    --double attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47511003)
    e1:SetCondition(c47511003.dacon)
    e1:SetCost(c47511003.dacost)
    e1:SetOperation(c47511003.daop)
    c:RegisterEffect(e1) 
    --effect
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47511003,0))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c47511003.cost)
    e2:SetTarget(c47511003.target)
    e2:SetOperation(c47511003.operation)
    c:RegisterEffect(e2) 
    --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(47511003,1))
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_DESTROYED)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47511003.pencon)
    e8:SetTarget(c47511003.pentg)
    e8:SetOperation(c47511003.penop)
    c:RegisterEffect(e8)  
end
function c47511003.mfilter(c)
    return c:IsLevel(8)
end
function c47511003.xyzcheck(g)
    return g:GetClassCount(Card.GetAttribute)==g:GetCount()
end
function c47511003.dacon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c47511003.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c47511003.daop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_EXTRA_ATTACK)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetValue(1)
    Duel.RegisterEffect(e1,tp)
end
function c47511003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47511003.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c47511003.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47511003.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
    local g=Duel.GetMatchingGroup(c47511003.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
end
function c47511003.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c47511003.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local sg=g:Select(tp,1,1,nil)
        Duel.HintSelection(sg)
        if sg and c:IsRelateToEffect(e) and c:IsFaceup() and sg:IsFaceup() and sg:IsRelateToEffect(e) then
        local code=sg:GetOriginalCode()
        c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
        end
    end
end
function c47511003.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47511003.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47511003.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end