--元素塔罗使-星河圣罗
function c4212017.initial_effect(c)
    --Destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(4212017,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(c4212017.cost)
    e1:SetTarget(c4212017.target)
    e1:SetOperation(c4212017.operation)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(4212017,2))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_HAND)
    e2:SetCountLimit(1,4212017)
    e2:SetCondition(c4212017.spcon)
    e2:SetCost(c4212017.cost2)
    e2:SetTarget(c4212017.sptg)
    e2:SetOperation(c4212017.spop)
    c:RegisterEffect(e2)
end
function c4212017.filtergrave(c)
    return c:IsSetCard(0xa2a) and c:IsType(TYPE_MONSTER)
end
function c4212017.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c4212017.costfilter(c,tp)
    return c:IsSetCard(0xa2a) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c4212017.costfilter2(c,tp)
    return  c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c4212017.spcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsReason(REASON_DRAW)
end
function c4212017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local loc=LOCATION_HAND
    if chk==0 then return Duel.IsExistingMatchingCard(c4212017.costfilter,tp,loc,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tc=Duel.SelectMatchingCard(tp,c4212017.costfilter,tp,loc,0,1,1,nil,tp):GetFirst()
    Duel.SendtoGrave(tc,REASON_COST)
end
function c4212017.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsOnField() and c4212017.filter(chkc) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(c4212017.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c4212017.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c4212017.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
        if dg:GetCount()>0 and Duel.GetMatchingGroupCount(c4212017.filtergrave,tp,LOCATION_GRAVE,0,nil)>=3 
            and Duel.SelectYesNo(tp,aux.Stringid(4212017,1)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local sg=dg:Select(tp,1,1,nil)
            Duel.HintSelection(sg)
            Duel.Destroy(sg,REASON_EFFECT)
        end
    end
end
function c4212017.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c4212017.costfilter2,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c4212017.costfilter2,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c4212017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    if Duel.GetMatchingGroupCount(c4212017.filtergrave,tp,LOCATION_GRAVE,0,nil)>=3 then
        e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
    end
end
function c4212017.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0         
        and Duel.GetMatchingGroupCount(c4212017.filtergrave,tp,LOCATION_GRAVE,0,nil)>=3
        and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(4212017,0)) then
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end