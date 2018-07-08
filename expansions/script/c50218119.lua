--暗之数码兽LV3 小狗兽
function c50218119.initial_effect(c)
    --extra summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetOperation(c50218119.sumop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50218119,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e3:SetCondition(c50218119.spcon)
    e3:SetCost(c50218119.spcost)
    e3:SetTarget(c50218119.sptg)
    e3:SetOperation(c50218119.spop)
    c:RegisterEffect(e3)
end
c50218119.lvupcount=1
c50218119.lvup={50218120}
function c50218119.sumop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(tp,50218119)~=0 then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
    e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcb1))
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    Duel.RegisterFlagEffect(tp,50218119,RESET_PHASE+PHASE_END,0,1)
end
function c50218119.spcon(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c50218119.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c50218119.spfilter(c,e,tp)
    return c:IsCode(50218120) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c50218119.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c50218119.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c50218119.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c50218119.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end