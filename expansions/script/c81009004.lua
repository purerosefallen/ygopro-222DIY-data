--后台的准备
function c81009004.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --adjust
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_ADJUST)
    e2:SetRange(LOCATION_FZONE)
    e2:SetOperation(c81009004.adjustop)
    c:RegisterEffect(e2)
    --cannot activate
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(1,1)
    e3:SetLabel(0)
    e3:SetValue(c81009004.actlimit)
    c:RegisterEffect(e3)
    e2:SetLabelObject(e3)
    --remove
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(81009004,1))
    e4:SetCategory(CATEGORY_REMOVE)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetRange(LOCATION_SZONE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,81009004)
    e4:SetCondition(c81009004.rmcon)
    e4:SetTarget(c81009004.rmtg)
    e4:SetOperation(c81009004.rmop)
    c:RegisterEffect(e4)
end
function c81009004.actlimit(e,te,tp)
    if not te:IsHasType(EFFECT_TYPE_ACTIVATE) or not te:IsActiveType(TYPE_TRAP) then return false end
    if tp==e:GetHandlerPlayer() then return e:GetLabel()==1
    else return e:GetLabel()==2 end
end
function c81009004.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function c81009004.adjustop(e,tp,eg,ep,ev,re,r,rp)
    local b1=Duel.IsExistingMatchingCard(c81009004.filter,tp,LOCATION_MZONE,0,1,nil)
    local b2=Duel.IsExistingMatchingCard(c81009004.filter,tp,0,LOCATION_MZONE,1,nil)
    local te=e:GetLabelObject()
    if not b1 then te:SetLabel(1)
    elseif b1 and not b2 then te:SetLabel(2)
    else te:SetLabel(0) end
end
function c81009004.cfilter(c,tp)
    return c:IsCode(81010019) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c81009004.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c81009004.cfilter,1,nil,tp)
end
function c81009004.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c81009004.rmop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
    end
end
