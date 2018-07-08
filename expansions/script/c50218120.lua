--暗之数码兽LV5 迪路兽
function c50218120.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50218120,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCountLimit(1,50218120)
    e1:SetTarget(c50218120.target)
    e1:SetOperation(c50218120.operation)
    c:RegisterEffect(e1)
    local e11=e1:Clone()
    e11:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e11)
    --battle destroy
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetOperation(c50218120.bdop)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50218120,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetCondition(c50218120.spcon)
    e3:SetCost(c50218120.spcost)
    e3:SetTarget(c50218120.sptg)
    e3:SetOperation(c50218120.spop)
    c:RegisterEffect(e3)
end
c50218120.lvupcount=1
c50218120.lvup={50218121}
c50218120.lvdncount=1
c50218120.lvdn={50218119}
function c50218120.bdop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(50218120,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c50218120.cfilter(c,tp)
    local atk=c:GetAttack()
    if atk<0 then atk=0 end
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
        and Duel.IsExistingTarget(c50218120.dfilter,tp,0,LOCATION_MZONE,1,nil,atk)
end
function c50218120.dfilter(c,atk)
    return c:IsFaceup() and c:GetAttack()<=atk
end
function c50218120.filter(c,e,tp)
    return c:IsSetCard(0xcb1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()<=6 
end
function c50218120.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_HAND) and chkc:IsControler(tp) and c50218120.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c50218120.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c50218120.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c50218120.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c50218120.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(50218120)>0
end
function c50218120.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c50218120.spfilter(c,e,tp)
    return c:IsCode(50218121) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c50218120.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c50218120.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c50218120.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c50218120.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end