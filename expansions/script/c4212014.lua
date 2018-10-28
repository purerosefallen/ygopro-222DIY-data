--元素塔罗使-白金银火
function c4212014.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(4212014,1))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(c4212014.cost)
    e1:SetTarget(c4212014.target)
    e1:SetOperation(c4212014.operation)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(4212014,2))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_DECK)
    e2:SetCondition(c4212014.spcon)
    e2:SetTarget(c4212014.sptg)
    e2:SetOperation(c4212014.spop)
    c:RegisterEffect(e2)
end
function c4212014.filtergrave(c)
    return c:IsSetCard(0xa2a) and c:IsType(TYPE_MONSTER)
end
function c4212014.filterdeck(c)
    return c:IsSetCard(0xa2a) and c:IsAbleToHand()
end
function c4212014.costfilter(c,tp)
    return c:IsSetCard(0xa2a) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c4212014.spfilter(c,e,tp)
    return c:IsSetCard(0xa2a) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4212014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local loc=LOCATION_HAND
    if chk==0 then return Duel.IsExistingMatchingCard(c4212014.costfilter,tp,loc,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tc=Duel.SelectMatchingCard(tp,c4212014.costfilter,tp,loc,0,1,1,nil,tp):GetFirst()
    Duel.SendtoGrave(tc,REASON_COST)
end
function c4212014.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c4212014.filterdeck,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    if Duel.GetMatchingGroupCount(c4212014.filtergrave,tp,LOCATION_GRAVE,0,nil)>=3 then
        e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
    end
end
function c4212014.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c4212014.filterdeck,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
            Duel.ConfirmCards(1-tp,g)
            if Duel.IsPlayerCanDraw(tp,1)
                and Duel.GetMatchingGroupCount(c4212014.filtergrave,tp,LOCATION_GRAVE,0,nil)>=3
                and Duel.SelectYesNo(tp,aux.Stringid(4212014,0)) then
                Duel.BreakEffect()
                Duel.ShuffleDeck(tp)
                Duel.Draw(tp,1,REASON_EFFECT)
            end
        end
    end
end
function c4212014.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousPosition(POS_FACEUP)
        and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c4212014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c4212014.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c4212014.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end