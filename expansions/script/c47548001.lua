--屠龙骑士 齐格弗里德
local m=47548001
local cm=_G["c"..m]
function c47548001.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,c47548001.mfilter,8,2,c47548001.ovfilter,aux.Stringid(47548001,0),2,c47548001.xyzop)
    c:EnableReviveLimit()
    --material
    c:EnableReviveLimit() 
    aux.EnablePendulumAttribute(c,false)  
    --material
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47548001)
    e1:SetTarget(c47548001.psptg)
    e1:SetOperation(c47548001.pspop)
    c:RegisterEffect(e1)   
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetCondition(c47548001.indcon)
    e2:SetValue(1)
    c:RegisterEffect(e2)  
    local e3=e2:Clone()
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    c:RegisterEffect(e3)
    --material
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47548001,1))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCost(c47548001.dacost)
    e4:SetOperation(c47548001.daop)
    c:RegisterEffect(e4)
    --spsummon
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47548001,2))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCost(c47548001.spcost)
    e5:SetTarget(c47548001.sptg)
    e5:SetOperation(c47548001.spop)
    c:RegisterEffect(e5)
end
c47548001.pendulum_level=8
function c47548001.pspfilter(c,tp)
    return not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler()) and (c:IsRace(RACE_WYRM) or c:IsRace(RACE_DRAGON) or c:IsRace(RACE_DINOSAUR) or c:IsRace(RACE_SEASERPENT))
end
function c47548001.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():GetOriginalType(TYPE_XYZ)
        and Duel.IsExistingTarget(c47548001.pspfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c47548001.pspfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47548001.pspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
    local og=tc:GetOverlayGroup()
        if og:GetCount()>0 then
            Duel.SendtoGrave(og,REASON_RULE)
        end
        Duel.Overlay(c,Group.FromCards(tc))
    end
end
function c47548001.mfilter(c)
    return c:IsType(TYPE_MONSTER)
end
function c47548001.ovfilter(c)
    return c:IsFaceup() and c:IsCode(47500503)
end
function c47548001.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,47548001)==0 end
    Duel.RegisterFlagEffect(tp,47548001,RESET_PHASE+PHASE_END,0,1)
end
function c47548001.indcon(e)
    return e:GetHandler():GetOverlayCount()>0
end
function c47548001.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47548001.daop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetValue(c47548001.efilter)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_EXTRA_ATTACK)
        e2:SetValue(1)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e2)
    end     
end
function c47548001.efilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c47548001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST) end
    c:RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c47548001.filter(c,e,tp)
    return c:IsRank(9) and (c:IsRace(RACE_WYRM) or c:IsRace(RACE_DRAGON)) and e:GetHandler():IsCanBeXyzMaterial(c)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c47548001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
        and aux.MustMaterialCheck(e:GetHandler(),tp,EFFECT_MUST_BE_XMATERIAL)
        and Duel.IsExistingMatchingCard(c47548001.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler():GetRank()+1) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47548001.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCountFromEx(tp,tp,c)<=0 or not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
    if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47548001.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c:GetRank()+1)
    local sc=g:GetFirst()
    if sc then
        local mg=c:GetOverlayGroup()
        if mg:GetCount()~=0 then
            Duel.Overlay(sc,mg)
        end
        sc:SetMaterial(Group.FromCards(c))
        Duel.Overlay(sc,Group.FromCards(c))
        Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
        sc:CompleteProcedure()
    end
end