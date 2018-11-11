--机炎复苏
function c47500031.initial_effect(c)
    --act in hand
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e0:SetCondition(c47500031.handcon)
    c:RegisterEffect(e0)    
    --pendulum effect
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47500031,0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,47500031)
    e1:SetCost(c47500031.cost)
    e1:SetOperation(c47500031.activate)
    c:RegisterEffect(e1)
    c47500031.act_effect=e1
    --reborn
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1,47500031)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c47500031.sptg)
    e2:SetOperation(c47500031.spop)
    c:RegisterEffect(e2) 
end
c47500031.card_code_list={47500000}
function c47500031.handcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c47500031.costfilter(c)
    return c:IsSetCard(0x5d0) and c:IsAbleToExtraAsCost()
end
function c47500031.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47500031.costfilter,tp,LOCATION_HAND,0,1,nil) end
    local g=Duel.SelectMatchingCard(tp,c47500031.costfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.SendtoExtraP(g,nil,0,REASON_COST)
end
function c47500031.filter(c)
    return c:IsType(TYPE_PENDULUM) and aux.IsCodeListed(c,47500000) and not c:IsForbidden() and c:IsSummonableCard()
end
function c47500031.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c47500031.filter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil)
    local ct=0
    if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct=ct+1 end
    if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
    if ct>0 and g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local sg=g:Select(tp,1,ct,nil)
        local sc=sg:GetFirst()
        while sc do
            Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
            sc=sg:GetNext()
        end
    end
end
function c47500031.spfilter(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsSummonableCard() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47500031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47500031.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c47500031.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47500031.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end