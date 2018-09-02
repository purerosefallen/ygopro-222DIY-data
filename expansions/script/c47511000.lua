--黄昏的尽头 黄龙
local m=47511000
local cm=_G["c"..m]
function c47511000.initial_effect(c)
    c:SetSPSummonOnce(47511000)
    --material
    c:EnableReviveLimit() 
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_LIGHT),1)
    aux.EnablePendulumAttribute(c,false)
    --double attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47511000)
    e1:SetCondition(c47511000.dacon)
    e1:SetCost(c47511000.dacost)
    e1:SetOperation(c47511000.daop)
    c:RegisterEffect(e1)
    --reset
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47511000,0))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER+CATEGORY_SEARCH)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,47511001)
    e2:SetCondition(c47511000.descon)
    e2:SetTarget(c47511000.destg)
    e2:SetOperation(c47511000.desop)
    c:RegisterEffect(e2) 
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47511000,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,47511001)
    e3:SetCost(c47511000.cost)
    e3:SetCondition(c47511000.descon)
    e3:SetTarget(c47511000.target)
    e3:SetOperation(c47511000.op)
    c:RegisterEffect(e3) 
    --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(47511000,2))
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_DESTROYED)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47511000.pencon)
    e8:SetTarget(c47511000.pentg)
    e8:SetOperation(c47511000.penop)
    c:RegisterEffect(e8)    
end
function c47511000.dacon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c47511000.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c47511000.daop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_EXTRA_ATTACK)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetValue(1)
    Duel.RegisterEffect(e1,tp)
end
function c47511000.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47511000.desfilter(c)
    return c:IsType(TYPE_SPELL)
end
function c47511000.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47511000.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(c47511000.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c47511000.ffilter(c)
    return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c47511000.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47511000.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT) then
       local fg=Duel.GetMatchingGroup(c47511000.ffilter,tp,LOCATION_DECK,0,nil)
       if fg:GetCount()>0 then
          Duel.BreakEffect()
          Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
          local sg=fg:Select(tp,1,1,nil)
          Duel.SendtoHand(sg,nil,REASON_EFFECT)
          Duel.ConfirmCards(1-tp,sg)
       end
    end
end
function c47511000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c47511000.filter(c)
    return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAttackBelow(3500) and c:IsDefenseAbove(2000) and c:IsAbleToHand()
end
function c47511000.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47511000.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47511000.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47511000.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47511000.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47511000.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47511000.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end