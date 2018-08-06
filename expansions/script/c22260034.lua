--华欲璀璨 宝石姬
function c22260034.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c22260034.spcon)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(22260034,1))
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c22260034.ixcost)
    e2:SetTarget(c22260034.ixtg)
    e2:SetOperation(c22260034.ixop)
    c:RegisterEffect(e2)
end
--
c22260034.named_with_AzayakaSin=1
c22260034.Desc_Contain_AzayakaSin=1
function c22260034.IsAzayakaSin(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_AzayakaSin
end
--
function c22260034.spfilter(c)
    return c:GetControler()==c:GetOwner()
end
function c22260034.spcon(e,c)
    if c==nil then return true end
    local tp=e:GetHandler():GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetMatchingGroupCount(c22260034.spfilter,tp,LOCATION_MZONE,0,nil)==0
end
--
function c22260034.ixfilter(c)
    return c:IsFaceup() and c22260034.IsAzayakaSin(c)
end
function c22260034.ixcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c22260034.ixfilter,1,nil,tp) end
    local g=Duel.SelectReleaseGroup(tp,c22260034.ixfilter,1,1,nil,tp)
    Duel.Release(g,REASON_COST)
end
function c22260034.ixfilter(c)
    return c22260034.IsAzayakaSin(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c22260034.ixtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22260034.ixfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22260034.ixop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c22260034.ixfilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
    Duel.BreakEffect()
    Duel.Draw(1-tp,1,REASON_EFFECT)
end