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
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCost(c47510007.hncost)
    e2:SetTarget(c47510007.hntg)
    e2:SetOperation(c47510007.hnop)
    c:RegisterEffect(e2)
    --synchro limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetValue(c47510007.synlimit)
    c:RegisterEffect(e3)
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
function c47510007.cfilter(c)
    return (c:IsType(TYPE_FUSIO) and c:IsAttribute(ATTRIBUTE_FIRE)) or (c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_EARTH)) or (c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_WIND)) or (c:IsType(TYPE_LINK) and c:IsAttribute(ATTRIBUTE_WATER))
        and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
        and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
end
function c47510007.fcheck(c,sg,g,code,...)
    if not c:IsSetCard(code) then return false end
    if ... then
        g:AddCard(c)
        local res=sg:IsExists(c47510007.fcheck,1,g,sg,g,...)
        g:RemoveCard(c)
        return res
    else return true end
end
function c47510007.fselect(c,tp,mg,sg,mc,...)
    sg:AddCard(c)
    local res=false
    if sg:GetCount()<5 then
        res=mg:IsExists(c47510007.fselect,1,sg,tp,mg,sg,mc,...)
    elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
        local g=Group.FromCards(mc)
        res=sg:IsExists(c47510007.fcheck,1,g,sg,g,...)
    end
    sg:RemoveCard(c)
    return res
end
function c47510007.hnfilter(c,e,tp)
    return c:IsCode(47510084) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c47510007.hncost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local mg=Duel.GetMatchingGroup(c47510007.cfilter,tp,LOCATION_EXTRA+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
    local sg=Group.FromCards(c)
    if chk==0 then return c:IsAbleToRemoveAsCost()
        and mg:IsExists(c47510007.fselect,1,sg,tp,mg,sg,c) end
    while sg:GetCount()<5 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local g=mg:FilterSelect(tp,c47510007.fselect,1,1,sg,tp,mg,sg,c)
        sg:Merge(g)
    end
    Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c47510007.hntg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
        and Duel.IsExistingMatchingCard(c47510007.hnfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47510007.hnop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp)<=0 or not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47510007.hnfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
    end
end
function c47510007.synlimit(e,c)
    if not c then return false end
    return not c:IsRace(RACE_FAIRY) or c:IsRace(RACE_DRAGON) or c:IsRace(RACE_WYRM) or c:IsSetCard(0x5da) 
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