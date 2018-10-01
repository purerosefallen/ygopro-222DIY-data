--地之天司 乌列尔
local m=47590005
local cm=_G["c"..m]
function c47590005.initial_effect(c)
    aux.EnablePendulumAttribute(c,false)
    --xyz summon-
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),7,2)
    c:EnableReviveLimit()
    --spssummon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c47590005.condition)
    e1:SetCost(c47590005.cost)
    e1:SetTarget(c47590005.target)
    e1:SetOperation(c47590005.operation)
    c:RegisterEffect(e1)
    --defense
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FAIRY))
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c47590005.indcon)
    e3:SetValue(1)
    c:RegisterEffect(e3)
        --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_DESTROYED)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47590005.pencon)
    e8:SetTarget(c47590005.pentg)
    e8:SetOperation(c47590005.penop)
    c:RegisterEffect(e8)
    --spsummon bgm
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(47590005,0))
    e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e9:SetCode(EVENT_SPSUMMON_SUCCESS)
    e9:SetOperation(c47590005.spsuc)
    c:RegisterEffect(e9)
end
c47590005.pendulum_level=7
function c47590005.indcon(e)
    return e:GetHandler():GetOverlayCount()>0
end
function c47590005.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47590005.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c47590005.spsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SOUND,0,aux.Stringid(47590005,1))
end
function c47590005.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsAbleToEnterBP()
end
function c47590005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47590005.filter(c)
    return c:IsFaceup() and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c47590005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c50449881.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50449881.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c50449881.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c47590005.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e1:SetValue(1)
        tc:RegisterEffect(e1)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
        e3:SetRange(LOCATION_MZONE)
        e3:SetCode(EFFECT_IMMUNE_EFFECT)
        e3:SetValue(c47590005.efilter)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
    end
end 
function c47590005.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c47590005.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47590005.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47590005.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end