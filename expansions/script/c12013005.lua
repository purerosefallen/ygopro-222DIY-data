--召喚魔術
function c12013005.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(12013005,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c12013005.sptg)
    e1:SetOperation(c12013005.spop)
    c:RegisterEffect(e1)
    --draw
    local e2=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(12013005,1))  
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_CHAIN_NEGATED)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetTarget(c12013005.tg)
    e2:SetOperation(c12013005.op)
    c:RegisterEffect(e2)
end
function c12013005.mfilter0(c)
    return c:IsOnField() and c:IsAbleToGrave()
end
function c12013005.mfilter1(c,e)
    return c:IsLocation(LOCATION_HAND) and not c:IsImmuneToEffect(e)
end
function c12013005.mfilter2(c,e)
    return c:IsOnField() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c12013005.mfilter3(c)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and c:IsFaceup()
end
function c12013005.spfilter1(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c12013005.spfilter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsSetCard(0xfb6) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c12013005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg=Duel.GetFusionMaterial(tp)
        local mg1=mg:Filter(Card.IsLocation,nil,LOCATION_HAND)
        local res=Duel.IsExistingMatchingCard(c12013005.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        if res then return true end
        local mg2=mg:Filter(c12013005.mfilter0,nil)
        local mg3=Duel.GetMatchingGroup(c12013005.mfilter3,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
        mg2:Merge(mg1)
        mg2:Merge(mg3)
        res=Duel.IsExistingMatchingCard(c12013005.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg4=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c12013005.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg4,mf,chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_MZONE+LOCATION_REMOVED)
end
function c12013005.spop(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg=Duel.GetFusionMaterial(tp)
    local mg1=mg:Filter(c12013005.mfilter1,nil,e)
    local sg1=Duel.GetMatchingGroup(c12013005.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    local mg2=mg:Filter(c12013005.mfilter2,nil,e)
    local mg3=Duel.GetMatchingGroup(c12013005.mfilter3,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
    mg2:Merge(mg1)
    mg2:Merge(mg3)
    local sg2=Duel.GetMatchingGroup(c12013005.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,nil,chkf)
    sg1:Merge(sg2)
    local mg4=nil
    local sg3=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg4=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg3=Duel.GetMatchingGroup(c12013005.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg4,mf,chkf)
    end
    if sg1:GetCount()>0 or (sg3~=nil and sg3:GetCount()>0) then
        local sg=sg1:Clone()
        if sg3 then sg:Merge(sg3) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:Select(tp,1,1,nil)
        local tc=tg:GetFirst()
        if sg1:IsContains(tc) and (sg3==nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
            if tc:IsSetCard(0xfb6) then
                local mat1=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
                tc:SetMaterial(mat1)
                local mat2=mat1:Filter(Card.IsLocation,nil,LOCATION_ONFIELD+LOCATION_REMOVED)
                mat1:Sub(mat2)
                Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
                Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            else
                local mat2=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
                tc:SetMaterial(mat2)
                Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            end
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
        else
            local mat=Duel.SelectFusionMaterial(tp,tc,mg4,nil,chkf)
            local fop=ce:GetOperation()
            fop(ce,e,tp,tc,mat)
        end
        tc:CompleteProcedure()
    end
end
function c12013005.filter1(c,e)
    return c:IsAbleToDeck() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xfb6)
end
function c12013005.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c12013005.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
        Duel.ShuffleDeck(tp)
        Duel.BreakEffect()
        if not Duel.IsExistingMatchingCard(c12013005.filter1,tp,LOCATION_GRAVE,0,2,nil) then return end
        if Duel.SelectYesNo(tp,aux.Stringid(12013005,2)) then
        local tg=Duel.SelectMatchingCard(tp,c12013005.filter1,tp,LOCATION_GRAVE,0,2,99,nil)
        Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
        Duel.Draw(tp,1,REASON_EFFECT)
        end
    end
end
