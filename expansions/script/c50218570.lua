--伏龙之怨
function c50218570.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetCountLimit(1,50218570+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c50218570.target)
    e1:SetOperation(c50218570.activate)
    c:RegisterEffect(e1)
    --remove overlay replace
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50218570,0))
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(c50218570.rcon)
    e2:SetOperation(c50218570.rop)
    c:RegisterEffect(e2)
end
function c50218570.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
end
function c50218570.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false and chkc:IsLocation(LOCATION_MZONE) and c50218570.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50218570.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c50218570.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c50218570.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    local mg=tc:GetOverlayGroup()
    Duel.SendtoHand(mg,nil,2,REASON_EFFECT)
end
function c50218570.rcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0)
        and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0xcb5)
        and e:GetHandler():IsAbleToRemoveAsCost()
        and ep==e:GetOwnerPlayer() and ev==1
end
function c50218570.rop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end