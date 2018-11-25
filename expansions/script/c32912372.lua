--Spiral Drill - Burning Fighter
function c32912372.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(32912372,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetChainLimit(1,32912372)
    e1:SetCondition(c32912372.spcon)
    e1:SetTarget(c32912372.sptg)
    e1:SetOperation(c32912372.spop)
    c:RegisterEffect(e1)
    --destroys
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(32912372,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1)
    e2:SetHintTiming(0,0x1e0)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c32912372.descost)
    e2:SetTarget(c32912372.destg)
    e2:SetOperation(c32912372.desop)
    c:RegisterEffect(e2)
end
function c32912372.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x205) and not c:IsCode(32912372)
end
function c32912372.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c32912372.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c32912372.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c32912372.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetValue(LOCATION_DECKSHF)
        e1:SetReset(RESET_EVENT+0x47e0000)
        c:RegisterEffect(e1,true)
    end
end
function c32912372.rfilter(c)
    return c:IsSetCard(0x205)
end
function c32912372.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c32912372.rfilter,1,e:GetHandler()) end
    local g=Duel.SelectReleaseGroup(tp,c32912372.rfilter,1,1,e:GetHandler())
    Duel.Release(g,REASON_COST)
end
function c32912372.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c32912372.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end