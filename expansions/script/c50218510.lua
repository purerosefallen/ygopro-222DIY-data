--炎伏龙-炽龙
function c50218510.initial_effect(c)
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetHintTiming(TIMING_DAMAGE_STEP)
    e1:SetCountLimit(1,50218510)
    e1:SetCost(c50218510.cost)
    e1:SetCondition(c50218510.condition)
    e1:SetTarget(c50218510.target)
    e1:SetOperation(c50218510.operation)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1,50218511)
    e2:SetCondition(c50218510.spcon)
    e2:SetTarget(c50218510.sptg)
    e2:SetOperation(c50218510.spop)
    c:RegisterEffect(e2)
    --get effect
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_XMATERIAL)
    e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetValue(c50218510.valcon)
    c:RegisterEffect(e3)
end
function c50218510.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c50218510.filter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb5)
end
function c50218510.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c50218510.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c50218510.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50218510.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c50218510.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c50218510.operation(e,tp,eg,ep,ev,re,r,rp)
    local val=Duel.GetMatchingGroupCount(c50218510.filter,tp,LOCATION_ONFIELD,0,nil)*500
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(val)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
function c50218510.efilter(e,re)
    return e:GetHandler()~=re:GetOwner()
end
function c50218510.spcon(e,tp,eg,ep,ev,re,r,rp)
    local loc=e:GetHandler():GetPreviousLocation()
    return loc==LOCATION_HAND
end
function c50218510.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c50218510.spop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(),1,tp,tp,false,false,POS_FACEUP)
    end
end
function c50218510.valcon(e,re,r,rp)
    return bit.band(r,REASON_EFFECT)~=0
end