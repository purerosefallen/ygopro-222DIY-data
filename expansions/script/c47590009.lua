--神击之龙 巴哈姆特
local m=47590009
local cm=_G["c"..m]
function c47590009.initial_effect(c)
    --revive limit
    aux.EnableReviveLimitPendulumSummonable(c,LOCATION_EXTRA)
    --xyz summon
    aux.AddXyzProcedureLevelFree(c,c47590009.mfilter,c47590009.xyzcheck,4,4)  
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.xyzlimit)
    c:RegisterEffect(e1)
    --fusummon success
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetOperation(c47590009.sumsuc)
    c:RegisterEffect(e3)
    --actlimit
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetCode(EFFECT_CANNOT_ACTIVATE)
    e5:SetTargetRange(0,1)
    e5:SetRange(LOCATION_PZONE)
    e5:SetValue(c47590009.actlimit)
    c:RegisterEffect(e5)
    --mudeki
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_IMMUNE_EFFECT)
    e6:SetRange(LOCATION_PZONE)
    e6:SetTargetRange(LOCATION_PZONE,0)
    e6:SetValue(c47590009.efilter)
    c:RegisterEffect(e6)
    --remove
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(47590009,0))
    e7:SetCategory(CATEGORY_ATKCHANGE)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCost(c47590009.rmcost)
    e7:SetOperation(c47590009.rmop)
    c:RegisterEffect(e7)
     --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(47590009,1))
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_LEAVE_FIELD)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47590009.pencon)
    e8:SetTarget(c47590009.pentg)
    e8:SetOperation(c47590009.penop)
    c:RegisterEffect(e8)
end
function c47590009.efilter(e,re)
    return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c47590009.mfilter(c,xyzc)
    return c:IsRace(RACE_DRAGON)
end
function c47590009.xyzcheck(g)
    return g:GetClassCount(Card.GetSummonType)==g:GetCount()
end
function c47590009.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local dg=Group.CreateGroup()
    local c=e:GetHandler()
    local tc=g:GetFirst()
    while tc do
        local preatk=tc:GetAttack()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-2000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
        tc=g:GetNext()
    end
    Duel.Remove(dg,POS_FACEUP,REASON_RULE)
end

function c47590009.actlimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c47590009.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,4,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,4,4,REASON_COST)
    local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.Hint(HINT_CARD,0,m)
        Duel.HintSelection(g)
        local og=tc:GetOverlayGroup()
        if og:GetCount()>0 then
            Duel.SendtoGrave(og,REASON_COST)
        end
        Duel.Overlay(e:GetHandler(),Group.FromCards(tc))
    end
end
function c47590009.rmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
        e1:SetValue(8000)
        c:RegisterEffect(e1)
    end
end
function c47590009.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47590009.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47590009.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end