--天星神-梦幻织女
function c50218655.initial_effect(c)
    aux.EnablePendulumAttribute(c,false) 
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcb6),aux.NonTuner(Card.IsSetCard,0xcb6),2)
    c:EnableReviveLimit()
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c50218655.splimit)
    c:RegisterEffect(e1)
    --disable
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCondition(c50218655.negcon)
    e2:SetOperation(c50218655.negop)
    c:RegisterEffect(e2)
    --remove drawn
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_HAND)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,50218655)
    e3:SetCondition(c50218655.rdcon)
    e3:SetTarget(c50218655.rdtg)
    e3:SetOperation(c50218655.rdop)
    c:RegisterEffect(e3)
    --pendulum
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCondition(c50218655.pencon)
    e4:SetTarget(c50218655.pentg)
    e4:SetOperation(c50218655.penop)
    c:RegisterEffect(e4)
end
function c50218655.splimit(e,c)
    return not c:IsSetCard(0xcb6)
end
function c50218655.tfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0xcb6) and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function c50218655.negcon(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)    
    return e:GetHandler():GetFlagEffect(50218655)==0 and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) 
        and g and g:IsExists(c50218655.tfilter,1,e:GetHandler(),tp) and Duel.IsChainDisablable(ev)
end
function c50218655.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
        e:GetHandler():RegisterFlagEffect(50218655,RESET_EVENT+RESETS_STANDARD,0,1)
        if Duel.NegateEffect(ev) then
            Duel.BreakEffect()
            Duel.Destroy(e:GetHandler(),REASON_EFFECT)
        end
    end
end
function c50218655.rdcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c50218655.rdfilter(c,tp)
    return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c50218655.rdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=eg:Filter(c50218655.rdfilter,nil,tp)
    if chk==0 then return g:GetCount()>0 end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c50218655.rdop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=eg:Filter(c50218655.rdfilter,nil,tp)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end
function c50218655.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
        and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c50218655.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c50218655.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end