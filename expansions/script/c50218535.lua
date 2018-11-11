--伏龙王-凛冽
function c50218535.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,5,2)
    c:EnableReviveLimit()
    --remove
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50218535,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(c50218535.rmcost)
    e1:SetTarget(c50218535.rmtg)
    e1:SetOperation(c50218535.rmop)
    c:RegisterEffect(e1)
    --get effect
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50218535,1))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c50218535.rmcost)
    e2:SetTarget(c50218535.rmtg)
    e2:SetOperation(c50218535.rmop)
    c:RegisterEffect(e2)
end
function c50218535.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c50218535.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c50218535.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
        tc:RegisterFlagEffect(50218535,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,0,1)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
        e1:SetLabelObject(tc)
        e1:SetCountLimit(1)
        e1:SetCondition(c50218535.retcon)
        e1:SetOperation(c50218535.retop)
        e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN)
        Duel.RegisterEffect(e1,tp)
    end
end
function c50218535.retcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp and e:GetLabelObject():GetFlagEffect(50218535)~=0
end
function c50218535.retop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ReturnToField(e:GetLabelObject())
end