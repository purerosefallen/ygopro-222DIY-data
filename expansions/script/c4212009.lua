--元素塔罗使-隐者之森
function c4212009.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(4212009,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c4212009.sptg)
    e1:SetOperation(c4212009.spop)
    c:RegisterEffect(e1)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(4212009,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,4212009)
    e2:SetCost(c4212009.thcost)
    e2:SetTarget(c4212009.thtg)
    e2:SetOperation(c4212009.thop)
    c:RegisterEffect(e2)
end
function c4212009.spfilter(c,e,tp)
    return c:IsSetCard(0xa2a) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4212009.filtergrave(c)
    return c:IsSetCard(0xa2a) and c:IsType(TYPE_MONSTER)
end
function c4212009.posfilter(c)
    return c:IsFaceup() and c:IsCanTurnSet()
end
function c4212009.thcfilter(c)
    return c:IsSetCard(0xa2a) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c4212009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c4212009.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c4212009.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c4212009.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 
            and Duel.IsExistingMatchingCard(c4212009.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
            and Duel.GetMatchingGroupCount(c4212009.filtergrave,tp,LOCATION_GRAVE,0,nil)>=3 then
            if Duel.SelectYesNo(tp,aux.Stringid(4212009,0)) then
                local tc = Duel.SelectMatchingCard(tp,c4212009.posfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
                Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
            end
        end
    end
end
function c4212009.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c4212009.thcfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c4212009.thcfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c4212009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c4212009.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end