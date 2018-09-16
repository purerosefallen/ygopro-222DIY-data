--煌火阳后 异化科罗
local m=47510115
local cm=_G["c"..m]
function c47510115.initial_effect(c)
    c:SetSPSummonOnce(47510115)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --synchro summon
    aux.AddSynchroMixProcedure(c,nil,aux.NonTuner(c47510115.sfilter),1,1)
    c:EnableReviveLimit() 
    --Fraunhofer
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_REVERSE_RECOVER)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(1,0)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_REFLECT_DAMAGE)
    e2:SetRange(LOCATION_PZONE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetValue(c47510115.refcon)
    c:RegisterEffect(e2)
    --Attribute Dark
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_ADD_ATTRIBUTE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(ATTRIBUTE_FIRE)
    c:RegisterEffect(e3)
    --Fraunhofer
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetCode(EFFECT_REVERSE_RECOVER)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(1,0)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_REFLECT_DAMAGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetTargetRange(1,0)
    e5:SetValue(c47510115.refcon)
    c:RegisterEffect(e5)
    --Sol Shot
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetCode(EFFECT_DESTROY_REPLACE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTarget(c47510115.reptg)
    c:RegisterEffect(e6)
    --pendulum
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e10:SetCode(EVENT_DESTROYED)
    e10:SetProperty(EFFECT_FLAG_DELAY)
    e10:SetCondition(c47510115.pencon)
    e10:SetTarget(c47510115.pentg)
    e10:SetOperation(c47510115.penop)
    c:RegisterEffect(e10)  
end
function c47510115.sfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c47510115.refcon(e,re,val,r,rp,rc)
    return bit.band(r,REASON_EFFECT)~=0 and rp==e:GetHandler():GetControler()
end
function c47510115.f(c,e)
    return c:IsAbleToGraveAsCost() and not c:IsImmuneToEffect(e)
end
function c47510115.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(c47510115.f,tp,0,LOCATION_ONFIELD,1,nil,e) end
    if Duel.SelectYesNo(tp,aux.Stringid(47510115,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,c47510115.f,tp,0,LOCATION_ONFIELD,1,1,nil,e)
        Duel.SendtoGrave(g,REASON_EFFECT)
        return true
    else return false end
end
function c47510115.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47510115.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47510115.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end