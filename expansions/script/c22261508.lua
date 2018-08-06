--华欲之庭 乐园
function c22261508.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(22261508,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c22261508.spcost)
    e2:SetTarget(c22261508.sptg)
    e2:SetOperation(c22261508.spop)
    c:RegisterEffect(e2)
    --to hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(22261508,1))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCondition(c22261508.tgcon)
    e3:SetTarget(c22261508.tgtg)
    e3:SetOperation(c22261508.tgop)
    c:RegisterEffect(e3)
end
--
c22261508.named_with_AzayakaSin=1
c22261508.Desc_Contain_AzayakaSin=1
function c22261508.IsAzayakaSin(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_AzayakaSin
end
--
function c22261508.spcfilter(c)
    return c:IsFaceup() and c22261508.IsAzayakaSin(c)
end
function c22261508.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c22261508.spcfilter,1,nil,tp) end
    local g=Duel.SelectReleaseGroup(tp,c22261508.spcfilter,1,1,nil,tp)
    Duel.Release(g,REASON_COST)
end
function c22261508.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22261508.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c22261508.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c22261508.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c22261508.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22261508.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
--
function c22261508.tgconfilter(c)
    return c:GetControler()~=c:GetOwner()
end
function c22261508.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
        and Duel.IsExistingMatchingCard(c22261508.tgconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22261508.tgfilter(c)
    return c22261508.IsAzayakaSin(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c22261508.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22261508.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22261508.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c22261508.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
end