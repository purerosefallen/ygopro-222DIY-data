--圣日耳曼
function c5012630.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --destroy and set
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c5012630.target)
    e1:SetOperation(c5012630.operation)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(5012630,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(c5012630.sptg)
    e2:SetOperation(c5012630.spop)
    c:RegisterEffect(e2)
    --to hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(5012630,1))
    e3:SetCategory(CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCountLimit(1,5012630)
    e3:SetCondition(c5012630.regcon)
    e3:SetTarget(c5012630.regtg)
    e3:SetOperation(c5012630.regop)
    c:RegisterEffect(e3)

    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e6:SetCode(EFFECT_ADD_SETCODE)
    e6:SetValue(0x250)
end
function c5012630.desfilter(c,tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    if ft==0 and c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5 then
        return Duel.IsExistingMatchingCard(c5012630.filter,tp,LOCATION_DECK,0,1,nil,true)
    else
        return Duel.IsExistingMatchingCard(c5012630.filter,tp,LOCATION_DECK,0,1,nil,false)
    end
end
function c5012630.filter(c,ignore)
    return c:IsSetCard(0x250) and c:IsType(TYPE_SPELL) and c:IsSSetable(ignore)
end
function c5012630.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c5012630.desfilter(chkc,tp) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(c5012630.desfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c5012630.desfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c5012630.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
        local g=Duel.SelectMatchingCard(tp,c5012630.filter,tp,LOCATION_DECK,0,1,1,nil,false)
        if g:GetCount()>0 then
            Duel.SSet(tp,g:GetFirst())
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
function c5012630.sfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c5012630.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c5012630.sfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c5012630.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c5012630.sfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2,true)
        Duel.SpecialSummonComplete()
    end
end
function c5012630.regcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c5012630.thfilter(c)
    return c:IsSetCard(0x250) and (c:IsCode(5012630) or c:IsType(TYPE_NORMAL))
end
function c5012630.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c5012630.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c5012630.regop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetCondition(c5012630.thcon)
    e1:SetOperation(c5012630.thop)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c5012630.thfilter2(c)
    return c5012630.thfilter(c) and c:IsAbleToHand()
end
function c5012630.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c5012630.thfilter2,tp,LOCATION_DECK,0,1,nil)
end
function c5012630.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,5012630)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c5012630.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
