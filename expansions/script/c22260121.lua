--深丛的华欲 黑百合
function c22260121.initial_effect(c)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedureLevelFree(c,c22260121.mfilter,c22260121.xyzcheck,2,2)
    --control
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_CONTROL)
    e1:SetDescription(aux.Stringid(22260121,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,222601210)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c22260121.ctcost)
    e1:SetTarget(c22260121.cttg)
    e1:SetOperation(c22260121.ctop)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetDescription(aux.Stringid(22260121,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1,222601211)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c22260121.spcon)
    e2:SetCost(c22260121.spcost)
    e2:SetTarget(c22260121.sptg)
    e2:SetOperation(c22260121.spop)
    c:RegisterEffect(e2)
end
--
c22260121.named_with_AzayakaSin=1
c22260121.Desc_Contain_AzayakaSin=1
function c22260121.IsAzayakaSin(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_AzayakaSin
end
--
function c22260121.mfilter(c)
    return c:GetOriginalLevel()>0
end
function c22260121.xyzcheck(g)
    return g:GetClassCount(Card.GetLevel)==g:GetCount()
end
--
function c22260121.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22260121.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c22260121.ctop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.GetControl(tc,tp,PHASE_END,1)
    Duel.BreakEffect()
    Duel.Draw(1-tp,1,REASON_EFFECT)
    end
end
--
function c22260121.spconfilter(c)
    return c:GetControler()~=c:GetOwner()
end
function c22260121.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
       and Duel.IsExistingMatchingCard(c22260121.spconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22260121.spcostfilter(c)
    return c22260121.IsAzayakaSin(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsPublic()
end
function c22260121.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22260121.spcostfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,c22260121.spcostfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
end
function c22260121.spfilter(c,e,tp)
    return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22260121.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c22260121.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c22260121.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c22260121.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    Duel.BreakEffect()
    Duel.Draw(1-tp,1,REASON_EFFECT)
    end
end