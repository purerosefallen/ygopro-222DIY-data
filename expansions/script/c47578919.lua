--路西法的遗产 梅塔特隆
local m=47578919
local cm=_G["c"..m]
function c47578919.initial_effect(c)
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
    c:EnableReviveLimit()
        --avoid damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CHANGE_DAMAGE)
    e2:SetRange(LOCATION_PZONE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetValue(c47578919.damval)
    c:RegisterEffect(e2)
    --lvchange
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47578919,0))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,47578920)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e3:SetCondition(c47578919.con)
    e3:SetTarget(c47578919.lvtg)
    e3:SetOperation(c47578919.lvop)
    c:RegisterEffect(e3)
    --synchro effect
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47578919,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c47578919.con)
    e4:SetTarget(c47578919.sctarg)
    e4:SetOperation(c47578919.scop)
    c:RegisterEffect(e4)
    --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_DESTROYED)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47578919.pencon)
    e8:SetTarget(c47578919.pentg)
    e8:SetOperation(c47578919.penop)
    c:RegisterEffect(e8) 
end
function c47578919.con(e,tp,eg,ep,ev,re,r,rp)
    return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c47578919.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(47578919)==0
        and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,c) end
    c:RegisterFlagEffect(47578919,RESET_CHAIN,0,1)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47578919.scop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,1,nil)
        Duel.SynchroSummon(tp,sg:GetFirst(),c)
    end
end
function c47578919.damval(e,re,val,r,rp,rc)
    local atk=e:GetHandler():GetAttack()
    if val<=1000 then return 0 else return val end
end
function c47578919.filter2(c)
    return c:IsRace(RACE_FAIRY) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO) and not c:IsCode(47578919)
end
function c47578919.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47578919.filter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c47578919.lvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c47578919.filter2,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetValue(2)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end
function c47578919.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47578919.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47578919.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end