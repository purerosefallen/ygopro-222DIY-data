--超古代的传承 空我仪
function c22261301.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c22261301.target)
    e1:SetOperation(c22261301.activate)
    c:RegisterEffect(e1)
end
c22260029.named_with_Kuuga=1
c22260029.Desc_Contain_Kuuga=1
function c22260029.IsKuuga(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_Kuuga
end
--
function c22261301.ritual_filter(c)
    return c:IsCode(22260029)
end
function c22261301.filter(c,e,tp,m,ft)
    if not c22261301.ritual_filter(c) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
    if ft>0 then
        return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
    else
        return mg:IsExists(c22261301.mfilterf,1,nil,tp,mg,c)
    end
end
function c22261301.mfilterf(c,tp,mg,rc)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
    else return false end
end
function c22261301.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetRitualMaterial(tp)
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        return ft>-1 and Duel.IsExistingMatchingCard(c22261301.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg,ft)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c22261301.activate(e,tp,eg,ep,ev,re,r,rp)
    local mg=Duel.GetRitualMaterial(tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,c22261301.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg,ft)
    local tc=tg:GetFirst()
    if tc then
        mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
            local mat=nil
            if ft>0 then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
            else
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                mat=mg:FilterSelect(tp,c22261301.mfilterf,1,1,nil,tp,mg,tc)
                Duel.SetSelectedCard(mat)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
                mat:Merge(mat2)
            end
            tc:SetMaterial(mat)
            Duel.ReleaseRitualMaterial(mat)
        end
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
end