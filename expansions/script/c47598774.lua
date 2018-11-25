--觉醒的圣少女 贞德
function c47598774.initial_effect(c)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --synchro summon
    aux.AddSynchroMixProcedure(c,c47598774.matfilter1,nil,nil,c47598774.matfilter2,1,99)  
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47598774,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_SUMMON_NEGATED)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47598774)
    e1:SetCondition(c47598774.condition1)
    e1:SetTarget(c47598774.rmtg)
    e1:SetOperation(c47598774.rmop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_NEGATED)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_CUSTOM+47598774)
    c:RegisterEffect(e3)
    if not c47598774.global_check then
        c47598774.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_CHAIN_NEGATED)
        ge1:SetOperation(c47598774.checkop)
        Duel.RegisterEffect(ge1,0)
    end 
    --salvage
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47598774,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCondition(c47598774.sumcon)
    e4:SetTarget(c47598774.sumtg)
    e4:SetOperation(c47598774.sumop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47598774,2))
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    --immune
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EFFECT_IMMUNE_EFFECT)
    e6:SetCondition(c47598774.inmcon)
    e6:SetValue(c47598774.efilter)
    c:RegisterEffect(e6)
    --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(47598774,3))
    e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_DESTROYED)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47598774.pencon)
    e8:SetTarget(c47598774.pentg)
    e8:SetOperation(c47598774.penop)
    c:RegisterEffect(e8)
end
function c47598774.matfilter1(c)
    return c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO) or (c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_NORMAL))
end
function c47598774.matfilter2(c)
    return c:IsType(TYPE_NORMAL)
end
function c47598774.checkop(e,tp,eg,ep,ev,re,r,rp)
    local dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_PLAYER)
    Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+47598774,e,0,dp,0,0)
end
function c47598774.condition1(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp
end
function c47598774.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c47598774.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function c47598774.filter(c,e,sp)
    return c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_NORMAL) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c47598774.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47598774.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47598774.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c47598774.sumop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local tg=Duel.GetMatchingGroup(c47598774.filter,tp,LOCATION_DECK,0,nil,e,tp)
    if ft<=0 or tg:GetCount()==0 then return end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=tg:Select(tp,ft,ft,nil)
    local c=e:GetHandler()
    local tc=g:GetFirst()
    while tc do
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e3)
        tc=g:GetNext()
    end
    Duel.SpecialSummonComplete()
end
function c47598774.inmcon(e)
    return Duel.GetCurrentPhase()~=PHASE_MAIN2
end
function c47598774.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c47598774.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47598774.pspfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_PENDULUM)
end
function c47598774.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c47598774.pspfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c47598774.penop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetMZoneCount(tp)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local c=e:GetHandler()
    local g=Duel.SelectMatchingCard(tp,c47598774.pspfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
       Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
       Duel.BreakEffect()
       Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end