--学园祭 奇犽
local m=50000051
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --sp
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(cm.spcost)
    e1:SetTarget(cm.sptg)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)
    --neg
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_NEGATE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_HAND)
    e2:SetCost(cm.negcost)
    e2:SetCondition(cm.negcon)
    e2:SetTarget(cm.negtg)
    e2:SetOperation(cm.negop)
    c:RegisterEffect(e2)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.mfilterf(c,tp,mg,rc)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
    else return false end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        local ft=Duel.GetMZoneCount(tp)
        local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsReleasable,c)
        if c.mat_filter then
            mg=mg:Filter(c.mat_filter,nil)
        end
        if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) then return end
        if ft>0 then
            return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),0,99,c)
        else
            return mg:IsExists(cm.mfilterf,1,nil,tp,mg,c)
        end
    end 
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetMZoneCount(tp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local c=e:GetHandler()
    local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsReleasable,c)
    if c.mat_filter then
        mg=mg1:Filter(c.mat_filter,nil)
    end
    local mg=mg1:Filter(Card.IsCanBeRitualMaterial,c,c)
    if mg:GetCount()==0 then return end
    local mat=nil
    if ft>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,c:GetLevel(),0,99,c)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        mat=mg:FilterSelect(tp,cm.mfilterf,1,1,nil,tp,mg,c)
        Duel.SetSelectedCard(mat)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,c:GetLevel(),0,99,c)
        mat:Merge(mat2)
    end
    c:SetMaterial(mat)
    if mat:GetCount()==0 then return end
    Duel.ReleaseRitualMaterial(mat)
    Duel.BreakEffect()
    if Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
        local tdg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.tdfilter),tp,LOCATION_GRAVE,0,nil)
        if tdg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
            local stdg=tdg:Select(tp,1,1,nil)
            Duel.HintSelection(stdg)
            Duel.SendtoDeck(stdg,nil,2,REASON_EFFECT)
        end
    end
    c:CompleteProcedure()
end
function cm.tdfilter(c)
    return c:IsSetCard(0x50c) and c:IsAbleToHand()
end
---neg
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
    Duel.SendtoDeck(e:GetHandler(),tp,2,REASON_COST)
end
function cm.tfilter(c,tp)
    return c:IsSetCard(0x50c) and 
    (
        (c:IsFaceup() and  c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)) 
        or 
        (c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE))
    )
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(cm.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
    end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
    end
end