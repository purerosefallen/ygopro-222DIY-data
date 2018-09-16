--Aeonbreaker Fusion
function c32904931.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(32904931,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c32904931.sptg)
    e1:SetOperation(c32904931.spop)
    c:RegisterEffect(e1)
    --to deck
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(32904931,1))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,32904931)
    e2:SetTarget(c32904931.tdtg)
    e2:SetOperation(c32904931.tdop)
    c:RegisterEffect(e2)
end
function c32904931.mfilter0(c)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c32904931.mfilter1(c,e)
    return not c:IsImmuneToEffect(e)
end
function c32904931.mfilter2(c,e)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c32904931.spfilter1(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsRace(RACE_PSYCHO) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c32904931.spfilter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsRace(RACE_PSYCHO) and c:IsSetCard(0xaa12) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c32904931.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp)
        local res=Duel.IsExistingMatchingCard(c32904931.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        if res then return true end
        local mg2=Duel.GetMatchingGroup(c32904931.mfilter0,tp,LOCATION_GRAVE,0,nil)
        mg2:Merge(mg1)
        res=Duel.IsExistingMatchingCard(c32904931.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg3=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c32904931.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c32904931.spop(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg1=Duel.GetFusionMaterial(tp):Filter(c32904931.mfilter1,nil,e)
    local sg1=Duel.GetMatchingGroup(c32904931.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    local mg2=Duel.GetMatchingGroup(c32904931.mfilter2,tp,LOCATION_GRAVE,0,nil,e)
    mg2:Merge(mg1)
    local sg2=Duel.GetMatchingGroup(c32904931.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,nil,chkf)
    sg1:Merge(sg2)
    local mg3=nil
    local sg3=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg3=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg3=Duel.GetMatchingGroup(c32904931.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
    end
    if sg1:GetCount()>0 or (sg3~=nil and sg3:GetCount()>0) then
        local sg=sg1:Clone()
        if sg3 then sg:Merge(sg3) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:Select(tp,1,1,nil)
        local tc=tg:GetFirst()
        if sg1:IsContains(tc) and (sg3==nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
            if tc:IsSetCard(0xaa12) then
                local mat1=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
                tc:SetMaterial(mat1)
                local mat2=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
                mat1:Sub(mat2)
                Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
                Duel.Remove(mat2,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            else
                local mat2=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
                tc:SetMaterial(mat2)
                Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            end
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
        else
            local mat=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
            local fop=ce:GetOperation()
            fop(ce,e,tp,tc,mat)
        end
        tc:CompleteProcedure()
    end
end
function c32904931.thfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and c:IsAbleToHand()
end
function c32904931.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c32904931.thfilter(chkc) end
    if chk==0 then return e:GetHandler():IsAbleToDeck()
        and Duel.IsExistingTarget(c32904931.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c32904931.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c32904931.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end