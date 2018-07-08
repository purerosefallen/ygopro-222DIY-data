--向巧克力献上花与红伞
function c22261300.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c22261300.target)
    e1:SetOperation(c22261300.activate)
    c:RegisterEffect(e1)
end
function c22261300.IsMayuAzaka(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_MayuAzaka
end
function c22261300.dfilter(c)
    return c:GetBaseAttack()==0 and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c22261300.filter(c,e,tp,m,ft)
    if not c22261300.IsMayuAzaka(c) or bit.band(c:GetType(),0x81)~=0x81
        or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
    if c.mat_filter then
        mg=mg:Filter(c.mat_filter,nil)
    end
    local dg=Duel.GetMatchingGroup(c22261300.dfilter,tp,LOCATION_DECK,0,nil)
    if ft>0 then
        return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
            or dg:IsExists(c22261300.dlvfilter,1,nil,tp,mg,c,c:GetLevel())
    else
        return ft>-1 and mg:IsExists(c22261300.mfilterf,1,nil,tp,mg,dg,c)
    end
end
function c22261300.mfilterf(c,tp,mg,dg,rc)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
            or dg:IsExists(c22261300.dlvfilter,1,nil,tp,mg,rc,rc:GetLevel()-c:GetRitualLevel(rc))
    else return false end
end
function c22261300.dlvfilter(c,tp,mg,rc,lv)
    local lv2=lv-c:GetRitualLevel(rc)
    return mg:CheckWithSumEqual(Card.GetRitualLevel,lv2,0,99,rc)
end
function c22261300.selcheck(c,mg1,dg,mat1,rc)
    local mat=mat1:Clone()
    local mg=mg1:Clone()
    mat:AddCard(c)
    if c:IsLocation(LOCATION_DECK) then
        mg:Sub(dg)
    else
        mg:RemoveCard(c)
    end
    local sum=mat:GetSum(Card.GetRitualLevel,rc)
    local lv=rc:GetLevel()-sum
    return rc:IsLevelAbove(sum) and mg:CheckWithSumEqual(Card.GetRitualLevel,lv,0,99,rc)
end
function c22261300.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetRitualMaterial(tp)
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        return Duel.IsExistingMatchingCard(c22261300.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg,ft)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c22261300.activate(e,tp,eg,ep,ev,re,r,rp)
    local mg=Duel.GetRitualMaterial(tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22261300.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg,ft)
    local tc=tg:GetFirst()
    if tc then
        local dg=Duel.GetMatchingGroup(c22261300.dfilter,tp,LOCATION_DECK,0,nil)
        mg:Merge(dg)
        mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        if tc.mat_filter then
            mg=mg:Filter(tc.mat_filter,nil)
        end
        local mat=Group.CreateGroup()
        local lv=tc:GetLevel()
        if ft<=0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            local mat2=mg:FilterSelect(tp,c22261300.mfilterf,1,1,nil,tp,mg,dg,tc):GetFirst()
            lv=lv-mat2:GetRitualLevel(tc)
            mat:AddCard(mat2)
            mg:RemoveCard(mat2)
        end
        while lv~=0 do
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            local tg=mg:FilterSelect(tp,c22261300.selcheck,1,1,nil,mg,dg,mat,tc):GetFirst()
            mat:AddCard(tg)
            if tg:IsLocation(LOCATION_DECK) then
                mg:Sub(dg)
            else
                mg:RemoveCard(tg)
            end
            lv=lv-tg:GetRitualLevel(tc)
        end
        tc:SetMaterial(mat)
        local mat3=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
        if mat3 then
            mat:Sub(mat3)
            Duel.SendtoGrave(mat3,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
        end
        Duel.ReleaseRitualMaterial(mat)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end