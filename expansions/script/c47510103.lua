--黄金战骑 异化萨奇达利乌斯
local m=47510103
local cm=_G["c"..m]
function c47510103.initial_effect(c)
    c:SetSPSummonOnce(47510103)
    c:EnableCounterPermit(0x5d7)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(c47510103.sfilter),1,1)
    c:EnableReviveLimit()
    --Astro Horizon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510103,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47510103)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetCondition(c47510103.atkcon)
    e1:SetOperation(c47510103.atkop)
    c:RegisterEffect(e1)
    --Zodiac Symbol
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47510103,1))
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(c47510103.opd1)
    c:RegisterEffect(e2)
    --Jupiternal Eight
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47510103,2))
    e3:SetCategory(CATEGORY_DISABLE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,47510104)
    e3:SetCost(c47510103.cost1)
    e3:SetOperation(c47510103.disop)
    c:RegisterEffect(e3)
    --Mutable
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47510103,3))
    e4:SetCategory(CATEGORY_ATKCHANGE)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,47510104)
    e4:SetCost(c47510103.cost1)
    e4:SetOperation(c47510103.immop)
    c:RegisterEffect(e4)
    --Zodiac Dimension
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47510103,4))
    e5:SetCategory(CATEGORY_REMOVE)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,47510104)
    e5:SetCost(c47510103.cost2)
    e5:SetOperation(c47510103.rmop)
    c:RegisterEffect(e5) 
    --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_DESTROYED)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47510103.pencon)
    e8:SetTarget(c47510103.pentg)
    e8:SetOperation(c47510103.penop)
    c:RegisterEffect(e8)   
end
function c47510103.sfilter(c)
    return c:IsSetCard(0x5da) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c47510103.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function c47510103.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        local sc=g:GetFirst()
        while sc do
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
            e1:SetValue(c47510103.atkval)
            sc:RegisterEffect(e1)
            sc=g:GetNext()
        end
    end
end
function c47510103.atkval(e,c)
    return math.ceil(c:GetBaseAttack()/2)
end
function c47510103.opd1(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x5d7,2)
    end
end
function c47510103.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x5d7,1,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x5d7,1,REASON_COST)
    Duel.SetChainLimit(aux.FALSE)
end
function c47510103.disop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
    local c=e:GetHandler()
        if c:IsRelateToEffect(e) then
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e3:SetValue(1)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e3)
    end
end
function c47510103.immop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-1000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
    local c=e:GetHandler()
        if c:IsRelateToEffect(e) then
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_IMMUNE_EFFECT)
        e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e3:SetValue(c47510103.efilter)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e3)
    end
end
function c47510103.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c47510103.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x5d7,3,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x5d7,3,REASON_COST)
end
function c47510103.rmfilter(c)
    return c:IsFacedown() and c:IsAbleToRemove()
end
function c47510103.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil)
        and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
        and Duel.IsExistingMatchingCard(c47510103.rmfilter,tp,0,LOCATION_EXTRA,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_HAND)
end
function c47510103.remop(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
    local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
    local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
    if g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg1=g1:RandomSelect(tp,1)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg2=g2:Select(tp,1,1,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg3=g3:RandomSelect(tp,1)
        sg1:Merge(sg2)
        sg1:Merge(sg3)
        Duel.HintSelection(sg1)
        Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
    end
end
function c47510103.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47510103.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47510103.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end