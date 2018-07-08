--超古代战士 假面骑士Kuuga
function c22260029.initial_effect(c)
    c:EnableReviveLimit()
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(c22260029.val)
    c:RegisterEffect(e1)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(22260029,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c22260029.spcon2)
    e3:SetTarget(c22260029.sptg2)
    e3:SetOperation(c22260029.spop2)
    c:RegisterEffect(e3)
end
c22260029.named_with_Kuuga=1
function c22260029.IsKuuga(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_Kuuga
end
c22260029.named_with_KamenRider=1
function c22260029.IsKamenRider(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_KamenRider
end
--
function c22260029.val(e,c)
    local tp=c:GetControler()
    return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)*500
end
--
function c22260029.spcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c22260029.spfilter2(c,e,tp)
    return c:IsType(TYPE_XYZ) and c:IsCode(22260120) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22260029.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
        and Duel.IsExistingMatchingCard(c22260029.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22260029.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c22260029.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        local c=e:GetHandler()
        if c:IsRelateToEffect(e) then
            Duel.Overlay(tc,Group.FromCards(c))
        end
    end
end