--光之数码兽LV5 天使兽
function c50218123.initial_effect(c)
    --remove
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50218123,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,50218123)
    e1:SetTarget(c50218123.rmtg)
    e1:SetOperation(c50218123.rmop)
    c:RegisterEffect(e1)
    local e11=e1:Clone()
    e11:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e11)
    --battle destroy
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetOperation(c50218123.bdop)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50218123,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetCondition(c50218123.spcon)
    e3:SetCost(c50218123.spcost)
    e3:SetTarget(c50218123.sptg)
    e3:SetOperation(c50218123.spop)
    c:RegisterEffect(e3)
end
c50218123.lvupcount=1
c50218123.lvup={50218124}
c50218123.lvdncount=1
c50218123.lvdn={50218122}
function c50218123.bdop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(50218123,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c50218123.cfilter(c,tp)
    local atk=c:GetAttack()
    if atk<0 then atk=0 end
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
        and Duel.IsExistingTarget(c50218123.dfilter,tp,0,LOCATION_MZONE,1,nil,atk)
end
function c50218123.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c50218123.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
        tc:RegisterFlagEffect(50218123,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetLabelObject(tc)
        e1:SetCountLimit(1)
        e1:SetCondition(c50218123.retcon)
        e1:SetOperation(c50218123.retop)
        Duel.RegisterEffect(e1,tp)
    end
end
function c50218123.retcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():GetFlagEffect(50218123)~=0
end
function c50218123.retop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ReturnToField(e:GetLabelObject())
end
function c50218123.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(50218123)>0
end
function c50218123.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c50218123.spfilter(c,e,tp)
    return c:IsCode(50218124) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c50218123.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c50218123.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c50218123.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c50218123.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end