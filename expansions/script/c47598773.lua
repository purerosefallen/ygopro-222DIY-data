--堕落的圣少女 贞德
function c47598773.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    c:EnableReviveLimit()
    aux.AddXyzProcedure(c,c47598773.mfilter,8,2)  
    --material
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47598773,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c47598773.mttg)
    e1:SetOperation(c47598773.mtop)
    c:RegisterEffect(e1)
    --immune
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47598773,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c47598773.cost)
    e2:SetOperation(c47598773.operation)
    c:RegisterEffect(e2) 
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47598773,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c47598773.spcon)
    e3:SetTarget(c47598773.sptg)
    e3:SetOperation(c47598773.spop)
    c:RegisterEffect(e3)
    --to defense
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c47598773.poscon)
    e4:SetOperation(c47598773.posop)
    c:RegisterEffect(e4)
    --pendulum
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCondition(c47598773.pencon)
    e5:SetTarget(c47598773.pentg)
    e5:SetOperation(c47598773.penop)
    c:RegisterEffect(e5)
end
c47598773.pendulum_level=8
function c47598773.mfilter(c,xyzc)
    return c:IsType(TYPE_PENDULUM)
end
function c47598773.poscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetAttackedCount()>0
end
function c47598773.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsAttackPos() then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    end
end
function c47598773.mtfilter(c,e)
    return c:IsLocation(LOCATION_EXTRA)
end
function c47598773.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
        and Duel.IsExistingMatchingCard(c47598773.mtfilter,tp,0,LOCATION_EXTRA,1,nil,e) end
end
function c47598773.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,c47598773.mtfilter,tp,0,LOCATION_EXTRA,1,1,nil,e)
    if g:GetCount()>0 then
        Duel.Overlay(c,g)
    end
end
function c47598773.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47598773.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0 end
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c47598773.penop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
        Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c47598773.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47598773.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetValue(c47598773.efilter)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        c:RegisterEffect(e1)
    end
end
function c47598773.efilter(e,re)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c47598773.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x5d0)
end
function c47598773.spfilter(c,e,tp)
    return c:IsSetCard(0x5d0) and c:IsType(TYPE_XYZ) and not c:IsCode(47598773)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47598773.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
        and Duel.IsExistingMatchingCard(c47598773.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47598773.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCountFromEx(tp)<1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47598773.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end