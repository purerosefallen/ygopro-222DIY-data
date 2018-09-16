--Laura the Aeonbreaker's Bow
function c32904921.initial_effect(c)
    --negate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(32904921,0))
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetCondition(c32904921.condition)
    e1:SetCost(c32904921.cost)
    e1:SetTarget(c32904921.target)
    e1:SetOperation(c32904921.operation)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(32904921,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCountLimit(1,32904921)
    e2:SetCondition(c32904921.spcon)
    e2:SetTarget(c32904921.sptg)
    e2:SetOperation(c32904921.spop)
    c:RegisterEffect(e2)
    --tohand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(32904921,2))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,33904921)
    e3:SetCondition(aux.exccon)
    e3:SetCost(aux.bfgcost)
    e3:SetTarget(c32904921.thtg)
    e3:SetOperation(c32904921.thop)
    c:RegisterEffect(e3)
end
function c32904921.tfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0xaa12) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c32904921.condition(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(c32904921.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c32904921.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c32904921.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c32904921.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function c32904921.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEUP) and not c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c32904921.spfilter(c,e,tp)
    return c:IsSetCard(0xaa12) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingMatchingCard(c32904921.thfilter,tp,LOCATION_DECK,0,1,c)
end
function c32904921.thfilter(c)
    return c:IsSetCard(0xaa12) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c32904921.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c32904921.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c32904921.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectMatchingCard(tp,c32904921.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g1:GetCount()>0 and Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)~=0 then
        Duel.ConfirmCards(1-tp,g1)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g2=Duel.SelectMatchingCard(tp,c32904921.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g2:GetCount()>0 then
            Duel.SendtoHand(g2,tp,REASON_EFFECT)
        end
    end
end
function c32904921.thfilter1(c)
    return c:IsSetCard(0xaa12) and c:IsType(TYPE_MONSTER) and not c:IsCode(32904921) and c:IsAbleToHand()
end
function c32904921.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32904921.thfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c32904921.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c32904921.thfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end