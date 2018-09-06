--真炎明王 异化伊芙利特
local m=47510101
local cm=_G["c"..m]
function c47510101.initial_effect(c)
    c:SetSPSummonOnce(47510101)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcMix(c,false,true,c47510101.fusfilter1,c47510101.fusfilter2)
    aux.EnablePendulumAttribute(c,false)
    --destroy replace
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DESTROY_REPLACE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTarget(c47510101.reptg)
    e1:SetValue(c47510101.repval)
    e1:SetOperation(c47510101.repop)
    c:RegisterEffect(e1) 
    --summon success
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(c47510101.sumsuc)
    c:RegisterEffect(e2)
    --furea
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,LOCATION_ONFIELD)
    e3:SetCountLimit(1,47510101)
    e3:SetCost(c47510101.cost)
    e3:SetTarget(c47510101.tg)
    e3:SetOperation(c47510101.op)
    c:RegisterEffect(e3)
    --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(47510101,3))
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_DESTROYED)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47510101.pencon)
    e8:SetTarget(c47510101.pentg)
    e8:SetOperation(c47510101.penop)
    c:RegisterEffect(e8)   
end
function c47510101.fusfilter1(c)
    return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER)
end
function c47510101.fusfilter2(c)
    return c:IsSetCard(0x5da) and c:IsType(TYPE_MONSTER)
end
function c47510101.repfilter(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)) and not c:IsReason(REASON_REPLACE)
end
function c47510101.desfilter(c,e,tp)
    return c:IsFaceup() and c:IsControler(1-tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c47510101.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c47510101.repfilter,1,nil,tp)
        and Duel.IsExistingMatchingCard(c47510101.desfilter,tp,0,LOCATION_ONFIELD,1,nil,e,tp) end
    if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
        local g=Duel.SelectMatchingCard(tp,c47510101.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil,e,tp)
        e:SetLabelObject(g:GetFirst())
        g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
        return true
    end
    return false
end
function c47510101.repval(e,c)
    return c47510101.repfilter(c,e:GetHandlerPlayer())
end
function c47510101.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,1-tp,47510101)
    local tc=e:GetLabelObject()
    tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
    Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c47510101.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c47510101.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetValue(c47510101.actlimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e4=Effect.CreateEffect(e:GetHandler())
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_MSET)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(0,1)
    e4:SetTarget(aux.TRUE)
    e4:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e4,tp)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_SSET)
    Duel.RegisterEffect(e5,tp)
    local e6=e4:Clone()
    e6:SetCode(EFFECT_CANNOT_TURN_SET)
    Duel.RegisterEffect(e6,tp)
    local e7=e4:Clone()
    e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e7:SetTarget(c47510101.sumlimit)
    Duel.RegisterEffect(e7,tp)
end
function c47510101.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return bit.band(sumpos,POS_FACEDOWN)>0
end
function c47510101.actlimit(e,te,tp)
    return te:GetHandler():IsFacedown()
end
function c47510101.desfilter2(c,rtype)
    return c:IsType(rtype)
end
function c47510101.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
    e:SetLabel(g:GetFirst():GetType())
    Duel.SendtoGrave(g,REASON_COST)
end
function c47510101.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g1=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
    Duel.ConfirmCards(tp,g1)
    local g=Duel.GetMatchingGroup(c47510101.desfilter2,tp,0,LOCATION_ONFIELD,nil,e:GetLabel())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c47510101.op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47510101.desfilter2,tp,0,LOCATION_ONFIELD,nil,e:GetLabel())
    Duel.Destroy(g,REASON_EFFECT)
end
function c47510101.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47510101.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47510101.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end