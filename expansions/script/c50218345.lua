--季神-思普腾布儿
function c50218345.initial_effect(c)
    c:EnableReviveLimit()
    aux.EnablePendulumAttribute(c)
    --splimit
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e0:SetRange(LOCATION_PZONE)
    e0:SetTargetRange(1,0)
    e0:SetTarget(c50218345.splimit)
    c:RegisterEffect(e0)
    --rsum
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,50218345)
    e1:SetTarget(c50218345.rtg)
    e1:SetOperation(c50218345.rop)
    c:RegisterEffect(e1)
    --act limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,1)
    e2:SetCondition(c50218345.actcon)
    e2:SetValue(c50218345.actval)
    c:RegisterEffect(e2)
    --handes
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_HANDES)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1,50218346)
    e3:SetCondition(c50218345.hdcon)
    e3:SetTarget(c50218345.hdtg)
    e3:SetOperation(c50218345.hdop)
    c:RegisterEffect(e3)
    --draw
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
    e4:SetCode(EVENT_RELEASE)
    e4:SetCountLimit(1,50218346)
    e4:SetTarget(c50218345.drtg)
    e4:SetOperation(c50218345.drop)
    c:RegisterEffect(e4)
end
function c50218345.splimit(e,c,tp,sumtp,sumpos)
    return not c:IsSetCard(0xcb3)
end
function c50218345.spfilter(c,e,tp,mc)
    return c:IsSetCard(0xcb3) and bit.band(c:GetType(),0x81)==0x81 and (not c.mat_filter or c.mat_filter(mc))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
        and mc:IsCanBeRitualMaterial(c)
end
function c50218345.rfilter(c,mc)
    local mlv=mc:GetRitualLevel(c)
    if mlv==mc:GetLevel() then return false end
    local lv=c:GetLevel()
    return lv==bit.band(mlv,0xffff) or lv==bit.rshift(mlv,16)
end
function c50218345.filter(c,e,tp)
    local sg=Duel.GetMatchingGroup(c50218345.spfilter,tp,LOCATION_HAND,0,c,e,tp,c)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if c:IsLocation(LOCATION_MZONE) then ft=ft+1 end
    if Duel.IsPlayerAffectedByEffect(tp,50218345) then ft=1 end
    return sg:IsExists(c50218345.rfilter,1,nil,c) or sg:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,ft)
end
function c50218345.mfilter(c)
    return c:GetLevel()>0 and c:IsAbleToGrave()
end
function c50218345.mzfilter(c,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:GetSequence()<5
end
function c50218345.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        if ft<0 then return false end
        local mg=Duel.GetRitualMaterial(tp)
        if ft>0 then
            local mg2=Duel.GetMatchingGroup(c50218345.mfilter,tp,LOCATION_EXTRA,0,nil)
            mg:Merge(mg2)
        else
            mg=mg:Filter(c50218345.mzfilter,nil,tp)
        end
        return mg:IsExists(c50218345.filter,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c50218345.rop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<0 then return end
    local mg=Duel.GetRitualMaterial(tp)
    if ft>0 then
        local mg2=Duel.GetMatchingGroup(c50218345.mfilter,tp,LOCATION_EXTRA,0,nil)
        mg:Merge(mg2)
    else
        mg=mg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local mat=mg:FilterSelect(tp,c50218345.filter,1,1,nil,e,tp)
    local mc=mat:GetFirst()
    if not mc then return end
    local sg=Duel.GetMatchingGroup(c50218345.spfilter,tp,LOCATION_HAND,0,mc,e,tp,mc)
    if mc:IsLocation(LOCATION_MZONE) then ft=ft+1 end
    if Duel.IsPlayerAffectedByEffect(tp,50218345) then ft=1 end
    local b1=sg:IsExists(c50218345.rfilter,1,nil,mc)
    local b2=sg:CheckWithSumEqual(Card.GetLevel,mc:GetLevel(),1,ft)
    if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(50218345,0))) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:FilterSelect(tp,c50218345.rfilter,1,1,nil,mc)
        local tc=tg:GetFirst()
        tc:SetMaterial(mat)
        if not mc:IsLocation(LOCATION_EXTRA) then
            Duel.ReleaseRitualMaterial(mat)
        else
            Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
        end
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:SelectWithSumEqual(tp,Card.GetLevel,mc:GetLevel(),1,ft)
        local tc=tg:GetFirst()
        while tc do
            tc:SetMaterial(mat)
            tc=tg:GetNext()
        end
        if not mc:IsLocation(LOCATION_EXTRA) then
            Duel.ReleaseRitualMaterial(mat)
        else
            Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
        end
        Duel.BreakEffect()
        tc=tg:GetFirst()
        while tc do
            Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
            tc:CompleteProcedure()
            tc=tg:GetNext()
        end
        Duel.SpecialSummonComplete()
    end
    end
end
function c50218345.actcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c50218345.actval(e,re,rp)
    local rc=re:GetHandler()
    return rc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER)
        and rc:IsType(TYPE_FUSION) and not rc:IsImmuneToEffect(e)
end
function c50218345.hdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c50218345.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,2)
end
function c50218345.hdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,2)
    Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
end
function c50218345.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c50218345.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end