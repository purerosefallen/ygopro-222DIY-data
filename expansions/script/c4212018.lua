--元素塔罗使-月咏留奈
function c4212018.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(4212018,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(c4212018.cost)
    e1:SetTarget(c4212018.target)
    e1:SetOperation(c4212018.operation)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(4212018,2))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,4212018)
    e2:SetCost(c4212018.cost)
    e2:SetTarget(c4212018.thtg)
    e2:SetOperation(c4212018.thop)
    c:RegisterEffect(e2)
end
function c4212018.filtergrave(c)
    return c:IsSetCard(0x2aa) and c:IsType(TYPE_MONSTER)
end
function c4212018.thfilter(c)
    return c:IsSetCard(0x2aa) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c4212018.costfilter(c,tp)
    return c:IsSetCard(0x2aa) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c4212018.spfilter(c,e,tp)
    return c:IsSetCard(0x2aa) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4212018.spcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsReason(REASON_DRAW)
end
function c4212018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local loc=LOCATION_HAND
    if chk==0 then return Duel.IsExistingMatchingCard(c4212018.costfilter,tp,loc,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tc=Duel.SelectMatchingCard(tp,c4212018.costfilter,tp,loc,0,1,1,nil,tp):GetFirst()
    Duel.SendtoGrave(tc,REASON_COST)
end
function c4212018.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c4212018.spfilter(chkc) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c4212018.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c4212018.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,0,0,0)
end
function c4212018.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then        
        if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) ~=0
            and Duel.GetMatchingGroupCount(c4212018.filtergrave,tp,LOCATION_GRAVE,0,nil)>=3            
            and Duel.SelectYesNo(tp,aux.Stringid(4212018,1)) then
            local g = Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
            Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        end
    end
end
function c4212018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c4212018.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c4212018.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c4212018.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end