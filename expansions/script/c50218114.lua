--地之数码兽LV5 仙人掌兽
function c50218114.initial_effect(c)
    --control
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50218114,0))
    e1:SetCategory(CATEGORY_CONTROL)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c50218114.target)
    e1:SetOperation(c50218114.operation)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --battle destroy
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetOperation(c50218114.bdop)
    c:RegisterEffect(e3)
    --special summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(50218114,0))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetCondition(c50218114.spcon)
    e4:SetCost(c50218114.spcost)
    e4:SetTarget(c50218114.sptg)
    e4:SetOperation(c50218114.spop)
    c:RegisterEffect(e4)
end
c50218114.lvupcount=1
c50218114.lvup={50218115}
c50218114.lvdncount=1
c50218114.lvdn={50218113}
function c50218114.bdop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(50218114,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c50218114.cfilter(c,tp)
    local atk=c:GetAttack()
    if atk<0 then atk=0 end
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
        and Duel.IsExistingTarget(c50218114.dfilter,tp,0,LOCATION_MZONE,1,nil,atk)
end
function c50218114.dfilter(c,atk)
    return c:IsFaceup() and c:GetAttack()<=atk
end
function c50218114.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(50218114)>0
end
function c50218114.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c50218114.spfilter(c,e,tp)
    return c:IsCode(50218115) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c50218114.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c50218114.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c50218114.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c50218114.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
function c50218114.filter(c)
    return c:IsControlerCanBeChanged()
end
function c50218114.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c50218114.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50218114.filter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,c50218114.filter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c50218114.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.GetControl(tc,tp,PHASE_END,1)
    end
end

