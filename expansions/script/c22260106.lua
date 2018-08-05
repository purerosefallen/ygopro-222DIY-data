--相互依存的噩梦
function c22260106.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcCode2(c,22260007,22260006,true,true)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DIRECT_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c22260106.dirtg)
    c:RegisterEffect(e1)
    --spsummmon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c22260106.spcon)
    e2:SetTarget(c22260106.sptg)
    e2:SetOperation(c22260106.spop)
    c:RegisterEffect(e2)
    --atkdown
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(22260106,1))
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_DAMAGE_STEP_END)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c22260106.atkcon)
    e3:SetTarget(c22260106.atktg)
    e3:SetOperation(c22260106.atkop)
    c:RegisterEffect(e3)
end
--
c22260106.named_with_NanayaShiki=1
function c22260106.IsNanayaShiki(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_NanayaShiki
end
--
function c22260106.dirtg(e,c)
    return c22260106.IsNanayaShiki(c)
end
--
function c22260106.spcfilter(c,tp)
    return c22260106.IsNanayaShiki(c)
        and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
        and c:IsPreviousLocation(LOCATION_MZONE)
end
function c22260106.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c22260106.spcfilter,1,nil,tp)
end
function c22260106.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(22260007)
end
function c22260106.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c22260106.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c22260106.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c22260106.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22260106.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end