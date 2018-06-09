--音乐晨曦—拂晓的再会
function c22600033.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,22600033)
    e1:SetCost(c22600033.cost)
    e1:SetTarget(c22600033.target)
    e1:SetOperation(c22600033.activate)
    c:RegisterEffect(e1)
    --summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,22600034)
    e2:SetCost(aux.bfgcost)
    e2:SetCondition(aux.exccon)
    e2:SetTarget(c22600033.stg)
    e2:SetOperation(c22600033.sop)
    c:RegisterEffect(e2)
end
function c22600033.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(100)
    return true
end
function c22600033.cfilter(c)
    return (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
end
function c22600033.spfilter(c,e,tp)
    return c:IsSetCard(0x260) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c22600033.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsSetCard(0x260) end
    local c=e:GetHandler()
    if chk==0 then
        if e:GetLabel()~=100 then return false end
        local cg=Duel.GetMatchingGroup(c22600033.cfilter,1-tp,LOCATION_REMOVED,0,nil)
        return cg:GetCount()>0 and Duel.GetMatchingGroupCount(c22600033.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local cg=Duel.SelectMatchingCard(tp,c22600033.cfilter,tp,0,LOCATION_REMOVED,1,7,nil)
    Duel.SendtoDeck(cg,1-tp,2,REASON_COST)
    e:SetLabel(cg:GetCount())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c22600033.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22600033.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local c=e:GetHandler()
    if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(e:GetLabel())
        tc:RegisterEffect(e1)
    end
end
function c22600033.filter(c)
    return c:IsSetCard(0x260) and c:IsSummonable(true,nil)
end
function c22600033.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c22600033.filter,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c22600033.sop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,c22600033.filter,tp,LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.Summon(tp,tc,true,nil)
    end
end
