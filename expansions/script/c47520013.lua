 --代理巫女 佐伊
local m=47520013
local cm=_G["c"..m]
function c47520013.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --act limit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_PZONE)
    e1:SetOperation(c47520013.chainop)
    c:RegisterEffect(e1)    
    --spsum
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,47520013)
    e2:SetCondition(c47520013.spcon)
    e2:SetTarget(c47520013.sptg)
    e2:SetOperation(c47520013.spop)
    c:RegisterEffect(e2)
    --fusion
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c47520013.ftg)
    e3:SetOperation(c47520013.fop)
    c:RegisterEffect(e3)
    --awake
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,47520013)
    e4:SetCost(c47520013.awcost)
    e4:SetTarget(c47520013.awtg)
    e4:SetOperation(c47520013.awop)
    c:RegisterEffect(e4)
end
function c47520013.chainop(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():IsRace(RACE_BEASTWARRIOR) and re:IsActiveType(TYPE_MONSTER) and ep==tp then
        Duel.SetChainLimit(c47520013.chainlm)
    end
end
function c47520013.chainlm(e,rp,tp)
    return tp==rp
end
function c47520013.cfilter(c,tp)
    return bit.band(c:GetSummonLocation(),LOCATION_EXTRA)~=0 and c:IsRace(RACE_BEASTWARRIOR)
end
function c47520013.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47520013.cfilter,1,nil,tp)
end
function c47520013.ffilter2(c,e,tp,dam)
    return c:IsRace(RACE_BEASTWARRIOR) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c47520013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47520013.ffilter2,tp,LOCATION_DECK,0,1,nil,e,tp,ev) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47520013.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47520013.ffilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,ev)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c47520013.filter0(c)
    return c:IsOnField() and c:IsAbleToRemove()
end
function c47520013.filter1(c,e)
    return c:IsOnField() and not c:IsImmuneToEffect(e) and c:IsAbleToRemove()
end
function c47520013.filter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsRace(RACE_BEASTWARRIOR) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c47520013.filter3(c)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c47520013.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp):Filter(c47520013.filter0,nil)
        local mg2=Duel.GetMatchingGroup(c47520013.filter3,tp,LOCATION_GRAVE,0,nil)
        mg1:Merge(mg2)
        local res=Duel.IsExistingMatchingCard(c47520013.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg3=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c47520013.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47520013.fop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local chkf=tp
    local mg1=Duel.GetFusionMaterial(tp):Filter(c47520013.filter1,nil,e)
    local mg2=Duel.GetMatchingGroup(c47520013.filter3,tp,LOCATION_GRAVE,0,nil)
    mg1:Merge(mg2)
    local sg1=Duel.GetMatchingGroup(c47520013.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    local mg3=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg3=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(c47520013.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
    end
    if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
        local sg=sg1:Clone()
        if sg2 then sg:Merge(sg2) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:Select(tp,1,1,nil)
        local tc=tg:GetFirst()
        if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
            local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
            tc:SetMaterial(mat1)
            Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
        else
            local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
            local fop=ce:GetOperation()
            fop(ce,e,tp,tc,mat2)
        end
        tc:CompleteProcedure()
    end
end
function c47520013.awfilter(c,tp)
    return c:IsSetCard(0x5dd) and (c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))
end
function c47520013.awcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.CheckReleaseGroup(tp,c47520013.awfilter,1,nil,tp) end
    Duel.SendtoDeck(e:GetHandler(),REASON_COST)
    local g=Duel.SelectReleaseGroup(tp,c47520013.awfilter,1,1,nil,tp)
    Duel.Release(g,REASON_COST)
end
function c47520013.filter(c,e,tp)
    return c:IsCode(47520015) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c47520013.awtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
        and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
        and Duel.IsExistingMatchingCard(c47520013.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47520013.awop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp)<=0 or not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47520013.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
        tc:CompleteProcedure()
    end
end