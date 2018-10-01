local m=47590006
local cm=_G["c"..m]
function c47590006.initial_effect(c)
    aux.EnablePendulumAttribute(c,false)
    --xyz summon-
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),8,2)
    c:EnableReviveLimit()
    --splimit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e3:SetTargetRange(1,0)
    e3:SetTarget(c47590006.psplimit)
    c:RegisterEffect(e3) 
    --indes
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetRange(LOCATION_PZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(c47590006.indtg)
    e4:SetValue(c47590006.indval)
    c:RegisterEffect(e4)
    --immune (FAQ in Card Target)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetCondition(c47590006.indcon)
    e1:SetTarget(c47590006.target)
    e1:SetValue(c47590006.efilter)
    c:RegisterEffect(e1)
    --immune
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47590006,0))
    e2:SetCategory(CATEGORY_NEGATE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetCountLimit(1)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c47590006.discon)
    e2:SetCost(c47590006.discost)
    e2:SetTarget(c47590006.distg)
    e2:SetOperation(c47590006.disop)
    c:RegisterEffect(e2)
        --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_DESTROYED)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47590006.pencon)
    e8:SetTarget(c47590006.pentg)
    e8:SetOperation(c47590006.penop)
    c:RegisterEffect(e8)
    --spsummon bgm
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(47590006,0))
    e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e9:SetCode(EVENT_SPSUMMON_SUCCESS)
    e9:SetOperation(c47590006.spsuc)
    c:RegisterEffect(e9)
end
c47590006.pendulum_level=8
function c47590006.indcon(e)
    return e:GetHandler():GetOverlayCount()>0
end
function c47590006.target(e,c)
    local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
    return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end
function c47590006.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c47590006.psplimit(e,c,tp,sumtp,sumpos)
    return not c:IsRace(RACE_FAIRY) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47590006.indtg(e,c)
    return c:IsType(TYPE_MONSTER)
end
function c47590006.indval(e,re,r,rp)
    return rp==1-e:GetHandlerPlayer()
end
function c47590006.mfilter(c)
    return c:IsRace(RACE_FAIRY)
end 
function c47590006.spsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SOUND,0,aux.Stringid(47590006,1))
end 
function c47590006.discon(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c47590006.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c47590006.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47590006.indfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c47590006.disop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
        e1:SetTargetRange(LOCATION_MZONE,0)
        e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FAIRY))
        e1:SetValue(aux.tgoval)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end
function c47590006.indfilter(c)
    return c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FAIRY)
end
function c47590006.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47590006.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47590006.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end