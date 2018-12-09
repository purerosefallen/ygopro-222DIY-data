--武士 姬塔
function c47500005.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --Double Attack
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47500005,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCondition(c47500005.dacon)
    e1:SetTarget(c47500005.datg)
    e1:SetOperation(c47500005.daop)
    c:RegisterEffect(e1) 
    --summon with 1 tribute
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47500005,2))
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_SUMMON_PROC)
    e3:SetCondition(c47500005.otcon)
    e3:SetOperation(c47500005.otop)
    e3:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e3)
    local e2=e3:Clone()
    e2:SetCode(EFFECT_SET_PROC)
    c:RegisterEffect(e2)  
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47500005,1))
    e4:SetCategory(CATEGORY_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
    e4:SetCountLimit(1,47500005)
    e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e4:SetCost(c47500005.sumcost)
    e4:SetTarget(c47500005.sumtg)
    e4:SetOperation(c47500005.sumop)
    c:RegisterEffect(e4) 
    --code
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetCode(EFFECT_CHANGE_CODE)
    e5:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA)
    e5:SetValue(47500000)
    c:RegisterEffect(e5)
    --Special Summon
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47500005,3))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e6:SetCode(EVENT_DESTROYED)
    e6:SetCondition(c47500005.spcon)
    e6:SetTarget(c47500005.sptg)
    e6:SetOperation(c47500005.spop)
    c:RegisterEffect(e6)
end
c47500005.card_code_list={47500000}
function c47500005.cfilter(c)
    return (aux.IsCodeListed(c,47500000) or c:IsCode(47500000)) and c:IsAbleToGraveAsCost()
end
function c47500005.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47500005.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47500005.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c47500005.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function c47500005.sumop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local pos=0
    if c:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
    if c:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
    if pos==0 then return end
    if Duel.SelectPosition(tp,c,pos)==POS_FACEUP_ATTACK then
        Duel.Summon(tp,c,true,nil,1)
    else
        Duel.MSet(tp,c,true,nil,1)
    end
end
function c47500005.otfilter(c)
    return c:IsType(TYPE_PENDULUM)
end
function c47500005.otcon(e,c)
    local tp=e:GetHandler():GetControler()
    return Duel.IsExistingMatchingCard(c47500005.otfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c47500005.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectMatchingCard(tp,c47500005.otfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_COST)
end
function c47500005.dacon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsAbleToEnterBP()
end
function c47500005.dbfilter(c)
    return c:IsFaceup() and (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)) and c:GetFlagEffect(47500005)==0
end
function c47500005.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c47500005.dbfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47500005.dbfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c47500005.dbfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c47500005.daop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
        tc:RegisterFlagEffect(47500005,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        Duel.BreakEffect()
        Duel.Destroy(c,REASON_EFFECT)
    end
end
function c47500005.spcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c47500005.spfilter(c,e,tp)
    return c:IsCode(47500000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47500005.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c47500005.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c47500005.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c47500005.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c47500005.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end