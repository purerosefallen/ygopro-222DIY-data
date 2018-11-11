--RUM-伏龙之渊
function c50218575.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,50218575+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c50218575.target)
    e1:SetOperation(c50218575.activate)
    c:RegisterEffect(e1)
    --material
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(aux.exccon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c50218575.mattg)
    e2:SetOperation(c50218575.matop)
    c:RegisterEffect(e2)
end
function c50218575.filter1(c,e,tp)
    local rk=c:GetRank()
    return c:IsFaceup() and c:IsType(TYPE_XYZ)
        and Duel.IsExistingMatchingCard(c50218575.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1)
        and Duel.GetLocationCountFromEx(tp,tp,c)>0
        and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c50218575.filter2(c,e,tp,mc,rk)
    return c:IsRank(rk) and c:IsSetCard(0xcb5) and mc:IsCanBeXyzMaterial(c)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c50218575.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c50218575.filter1(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingTarget(c50218575.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c50218575.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c50218575.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
    if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c50218575.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
    local sc=g:GetFirst()
    if sc then
        local mg=tc:GetOverlayGroup()
        if mg:GetCount()~=0 then
            Duel.Overlay(sc,mg)
        end
        sc:SetMaterial(Group.FromCards(tc))
        Duel.Overlay(sc,Group.FromCards(tc))
        Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
        sc:CompleteProcedure()
    end
end
function c50218575.xyzfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb5) and c:IsType(TYPE_XYZ)
end
function c50218575.matfilter(c)
    return c:IsSetCard(0xcb5) and c:IsType(TYPE_MONSTER)
end
function c50218575.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c50218575.xyzfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50218575.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(c50218575.matfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c50218575.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c50218575.matop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        local g=Duel.SelectMatchingCard(tp,c50218575.matfilter,tp,LOCATION_GRAVE,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.Overlay(tc,g)
        end
    end
end