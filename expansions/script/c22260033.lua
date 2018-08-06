--华欲贪食 甜猎
function c22260033.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(22260033,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c22260033.spcon)
    e1:SetTarget(c22260033.sptg)
    e1:SetOperation(c22260033.spop)
    c:RegisterEffect(e1)
    --give control
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(22260033,0))
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(c22260033.ctcon)
    e2:SetTarget(c22260033.cttg)
    e2:SetOperation(c22260033.ctop)
    c:RegisterEffect(e2)
end
--
c22260033.named_with_AzayakaSin=1
c22260033.Desc_Contain_AzayakaSin=1
function c22260033.IsAzayakaSin(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_AzayakaSin
end
--
function c22260033.spconfilter(c)
    return c:GetControler()~=c:GetOwner()
end
function c22260033.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
        and Duel.IsExistingMatchingCard(c22260033.spconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22260033.spfilter(c,e,tp)
    return c22260033.IsAzayakaSin(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22260033.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22260033.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c22260033.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c22260033.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22260033.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    Duel.BreakEffect()
    Duel.Draw(1-tp,1,REASON_EFFECT)
    end
end
--
function c22260033.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7f0)
        and re:GetHandler():IsAzayakaSin(c)
end
function c22260033.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c22260033.ctop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.GetControl(tc,tp,PHASE_END,1)
    Duel.BreakEffect()
    Duel.Draw(1-tp,1,REASON_EFFECT)
    end
end