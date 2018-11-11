--伏龙之怨
function c50218595.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetCountLimit(1,50218595+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c50218595.target)
    e1:SetOperation(c50218595.activate)
    c:RegisterEffect(e1)
end
function c50218595.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
end
function c50218595.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false and chkc:IsLocation(LOCATION_MZONE) and c50218595.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50218595.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c50218595.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c50218595.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    local mg=tc:GetOverlayGroup()
    Duel.SendtoHand(mg,nil,2,REASON_EFFECT)
end