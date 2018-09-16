--即为伟大的破局
local m=47511114
local cm=_G["c"..m]
function c47511114.initial_effect(c)
    --ritual
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47511114,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c47511114.target)
    e1:SetOperation(c47511114.operation)
    c:RegisterEffect(e1)   
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47511114,2))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCondition(c47511114.descon)
    e3:SetCost(aux.bfgcost)
    e3:SetTarget(c47511114.destg)
    e3:SetOperation(c47511114.desop)
    c:RegisterEffect(e3)
end
function c47511114.exfilter0(c)
    return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
end
function c47511114.filter(c,e,tp,m,ft)
    if not (c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_RITUAL)) or bit.band(c:GetType(),0x81)~=0x81
        or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
    if c.mat_filter then
        mg=mg:Filter(c.mat_filter,nil)
    end
    if ft>0 then
        return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
    else
        return mg:IsExists(c47511114.mfilterf,1,nil,tp,mg,c)
    end
end
function c47511114.mfilterf(c,tp,mg,rc)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
    else return false end
end
function c47511114.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_PENDULUM)
        local sg=Duel.GetMatchingGroup(c47511114.exfilter0,tp,LOCATION_REMOVED,0,nil)
        mg:Merge(sg)
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        return ft>-1 and Duel.IsExistingMatchingCard(c47511114.filter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,mg,ft)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c47511114.operation(e,tp,eg,ep,ev,re,r,rp)
    local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_PENDULUM)
    local sg=Duel.GetMatchingGroup(c47511114.exfilter0,tp,LOCATION_REMOVED,0,nil)
    mg:Merge(sg)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47511114.filter),tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,mg,ft)
    local tc=tg:GetFirst()
    if tc then
        mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        if tc.mat_filter then
            mg=mg:Filter(tc.mat_filter,nil)
        end
        local mat=nil
        if ft>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
        else
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            mat=mg:FilterSelect(tp,c47511114.mfilterf,1,1,nil,tp,mg,tc)
            Duel.SetSelectedCard(mat)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
            mat:Merge(mat2)
        end
        tc:SetMaterial(mat)
        local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
        mat:Sub(mat2)
        Duel.ReleaseRitualMaterial(mat)
        Duel.SendtoDeck(mat2,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
function c47511114.desfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsLevelAbove(9)
end
function c47511114.descon(e,tp,eg,ep,ev,re,r,rp)
    return aux.exccon(e) and Duel.IsExistingMatchingCard(c47511114.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c47511114.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c47511114.desop(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end