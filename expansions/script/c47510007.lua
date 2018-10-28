--苍之少女 露莉雅
local m=47510007
local cm=_G["c"..m]
function c47510007.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510007.psplimit)
    c:RegisterEffect(e1) 
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47511007+EFFECT_COUNT_CODE_DUEL)
    e2:SetTarget(c47510007.dftg)
    e2:SetOperation(c47510007.dfop)
    c:RegisterEffect(e2)
    --serch
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,47510007)
    e4:SetTarget(c47510007.sptg)
    e4:SetOperation(c47510007.spop)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e5)
    --immue
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e6:SetRange(LOCATION_EXTRA)
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e6:SetCountLimit(1,47510008)
    e6:SetCost(c47510007.cost)
    e6:SetTarget(c47510007.target)
    e6:SetOperation(c47510007.chop)
    c:RegisterEffect(e6)
end
c47510007.pendulum_level=8
function c47510007.pefilter(c)
    return c:IsRace(RACE_DRAGON) or c:IsRace(RACE_WYRM) or c:IsSetCard(0x5de) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c47510007.psplimit(e,c,tp,sumtp,sumpos)
    return not c47510007.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47510007.spfilter(c,e,tp)
    return (c:IsSetCard(0x5da) or c:IsSetCard(0x5de)) and not c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c47510007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
        and Duel.IsExistingMatchingCard(c47510007.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47510007.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCountFromEx(tp)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c47510007.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
        local tc=g:GetFirst()
        if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e2)
            local fid=c:GetFieldID()
            tc:RegisterFlagEffect(47510007,RESET_EVENT+RESETS_STANDARD,0,1,fid)
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
            e3:SetCode(EVENT_PHASE+PHASE_END)
            e3:SetCountLimit(1)
            e3:SetLabel(fid)
            e3:SetLabelObject(tc)
            e3:SetCondition(c47510007.tdcon)
            e3:SetOperation(c47510007.tdop)
            Duel.RegisterEffect(e3,tp)
            Duel.SpecialSummonComplete()
        end
    end
end
function c47510007.tdcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:GetFlagEffectLabel(47510007)==e:GetLabel() then
        return true
    else
        e:Reset()
        return false
    end
end
function c47510007.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function c47510007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47510007.chfilter(c,e)
    return bit.band(c:GetSummonLocation(),LOCATION_EXTRA)~=0 and c:IsSetCard(0x5de) or c:IsSetCard(0x5da)
end
function c47510007.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=eg:Filter(c47510007.chfilter,nil)
    local ct=g:GetCount()
    if chk==0 then return ct>0 end
    Duel.SetTargetCard(eg)
end
function c47510007.chop(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(cm.chfilter,nil,e)
        for rc in aux.Next(g) do
        rc:IsRelateToEffect(e)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetValue(c47510007.efilter)
        rc:RegisterEffect(e1)
    end
end
function c47510007.efilter(e,te)
    if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true end
end
function c47510007.filter0(c)
    return c:IsOnField() and c:IsAbleToRemove()
end
function c47510007.filter1(c,e)
    return c:IsOnField() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c47510007.filter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsRace(RACE_DRAGON) and (not f or f(c)) and c:IsType(TYPE_PENDULUM) and c:IsLevelAbove(10)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c47510007.filter3(c)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and c:IsFaceup()
end
function c47510007.dftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp):Filter(c47510007.filter0,nil)
        local mg2=Duel.GetMatchingGroup(c47510007.filter3,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
        mg1:Merge(mg2)
        local res=Duel.IsExistingMatchingCard(c47510007.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg3=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c47510007.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA+ LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c47510007.dfop(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg1=Duel.GetFusionMaterial(tp):Filter(c47510007.filter1,nil,e)
    local mg2=Duel.GetMatchingGroup(c47510007.filter3,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
    mg1:Merge(mg2)
    local sg1=Duel.GetMatchingGroup(c47510007.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    local mg3=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg3=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(c47510007.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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