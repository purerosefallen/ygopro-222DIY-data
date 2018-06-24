--紫罗兰之道
local m=22261503
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c22261503.rectg)
    e1:SetOperation(c22261503.recop)
    c:RegisterEffect(e1)
    --Destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCondition(c22261503.desrepcon)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(22261503,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c22261503.spcon)
    e3:SetTarget(c22261503.sptg)
    e3:SetOperation(c22261503.spop)
    c:RegisterEffect(e3)
    --Negate
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(22261503,2))
    e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCondition(c22261503.discon)
    e4:SetCost(c22261503.discost)
    e4:SetTarget(c22261503.distg)
    e4:SetOperation(c22261503.disop)
    c:RegisterEffect(e4)
end
--
function c22261503.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c22261503.recop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end
--
function c22261503.filter1(c)
    return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:IsType(TYPE_TOKEN)
end
function c22261503.desrepcon(e)
    return Duel.IsExistingMatchingCard(c22261503.filter1,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
--
function c22261503.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c22261503.filter1,tp,LOCATION_MZONE,0,2,nil)
end
function c22261503.filter3(c,e,tp)
    return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22261503.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_HAND) and chkc:IsControler(tp) and c22261503.filter3(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c22261503.filter3,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c22261503.filter3,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22261503.spop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(c22261503.filter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,nil) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
    end
end
--
function c22261503.discon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
        and Duel.IsExistingMatchingCard(c22261503.filter1,e:GetHandler():GetControler(),LOCATION_MZONE,0,3,nil)
end
function c22261503.filter2(c)
    return c:GetBaseAttack()==0
end
function c22261503.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22261503.filter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c22261503.filter2,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c22261503.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c22261503.disop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(c22261503.filter1,tp,LOCATION_MZONE,0,3,nil) then return end
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end