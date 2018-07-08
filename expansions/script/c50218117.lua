--风之数码兽LV5 比多兽
function c50218117.initial_effect(c)
    --handes
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50218117,0))
    e1:SetCategory(CATEGORY_HANDES)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BATTLE_DAMAGE)
    e1:SetCountLimit(1,50218117)
    e1:SetCondition(c50218117.condition)
    e1:SetTarget(c50218117.target)
    e1:SetOperation(c50218117.operation)
    c:RegisterEffect(e1)
    --battle destroy
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetOperation(c50218117.bdop)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50218117,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetCondition(c50218117.spcon)
    e3:SetCost(c50218117.spcost)
    e3:SetTarget(c50218117.sptg)
    e3:SetOperation(c50218117.spop)
    c:RegisterEffect(e3)
end
c50218117.lvupcount=1
c50218117.lvup={50218118}
c50218117.lvdncount=1
c50218117.lvdn={50218116}
function c50218117.bdop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(50218117,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c50218117.cfilter(c,tp)
    local atk=c:GetAttack()
    if atk<0 then atk=0 end
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
        and Duel.IsExistingTarget(c50218117.dfilter,tp,0,LOCATION_MZONE,1,nil,atk)
end
function c50218117.dfilter(c,atk)
    return c:IsFaceup() and c:GetAttack()<=atk
end
function c50218117.condition(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function c50218117.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c50218117.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(ep,LOCATION_HAND,0)
    if g:GetCount()==0 then return end
    local sg=g:RandomSelect(ep,1)
    Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
function c50218117.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(50218117)>0
end
function c50218117.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c50218117.spfilter(c,e,tp)
    return c:IsCode(50218118) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c50218117.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c50218117.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c50218117.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c50218117.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end