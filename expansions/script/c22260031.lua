--华欲倦夏 百合
function c22260031.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(22260031,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c22260031.spcon)
    e1:SetTarget(c22260031.sptg)
    e1:SetOperation(c22260031.spop)
    c:RegisterEffect(e1)
    --index
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(c22260031.ixcon)
    e2:SetTarget(c22260031.ixtg)
    e2:SetOperation(c22260031.ixop)
    c:RegisterEffect(e2)
end
--
c22260031.named_with_AzayakaSin=1
c22260031.Desc_Contain_AzayakaSin=1
function c22260031.IsAzayakaSin(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_AzayakaSin
end
--
function c22260031.spconfilter(c)
    return c:GetControler()~=c:GetOwner()
end
function c22260031.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
       and Duel.IsExistingMatchingCard(c22260031.spconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22260031.spfilter(c,e,tp)
    return c22260031.IsAzayakaSin(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(22260031)
end
function c22260031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c22260031.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c22260031.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c22260031.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    Duel.BreakEffect()
    Duel.Draw(1-tp,1,REASON_EFFECT)
    end
end
--
function c22260031.ixcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7f0)
        and re:GetHandler():IsAzayakaSin(c)
end
function c22260031.ixfilter(c)
    return c22260031.IsAzayakaSin(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c22260031.ixtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22260031.ixfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22260031.ixop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c22260031.ixfilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
    Duel.BreakEffect()
    Duel.Draw(1-tp,1,REASON_EFFECT)
end