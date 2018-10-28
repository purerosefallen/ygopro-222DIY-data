--修瓦利耶·马格纳
local m=47570500
local cm=_G["c"..m]
function c47570500.initial_effect(c)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --synchro summon
    aux.AddSynchroMixProcedure(c,c47570500.matfilter1,nil,nil,aux.NonTuner(c47570500.matfilter2),1,99)  
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e0:SetCode(EVENT_ADJUST)
    e0:SetRange(LOCATION_MZONE)
    e0:SetOperation(c47570500.efop)
    c:RegisterEffect(e0)
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCondition(c47570500.indcon)
    e1:SetOperation(c47570500.indop)
    c:RegisterEffect(e1)  
    local e2=e1:Clone()
    e2:SetCode(EVENT_BE_BATTLE_TARGET)
    e2:SetCondition(c47570500.indcon2)
    c:RegisterEffect(e2)
    --salvage
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(80896940,3))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCondition(c47570500.tfcon)
    e3:SetTarget(c47570500.tftg)
    e3:SetOperation(c47570500.tfop)
    c:RegisterEffect(e3)
    --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_LEAVE_FIELD)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47570500.tpcon)
    e8:SetTarget(c47570500.tptg)
    e8:SetOperation(c47570500.tpop)
    c:RegisterEffect(e8)
end
function c47570500.matfilter1(c)
    return c:IsType(TYPE_TUNER) or c:IsType(TYPE_PENDULUM)
end
function c47570500.matfilter2(c)
    return c:IsType(TYPE_PENDULUM) and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_FUSION)) 
end
function c47570500.indcon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    return a:IsType(TYPE_PENDULUM) and a:IsControler(tp)
end
function c47570500.indcon2(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttackTarget()
    return a:IsType(TYPE_PENDULUM) and a:IsControler(tp)
end
function c47570500.indop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetValue(c47570500.efilter)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DISABLE)
    e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
    tc:RegisterEffect(e2)
end
function c47570500.efilter(e,re)
    return re:GetOwner()~=e:GetOwner()
end
function c47570500.tfcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47570500.ppfilter(c)
    return c:IsType(TYPE_PENDULUM)
end
function c47570500.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c47570500.ppfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
    Duel.SetChainLimit(aux.FALSE)
end
function c47570500.tfop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    if Duel.Remove(g,POS_FACEUP,REASON_EFFECT) then
        local g1=Duel.GetMatchingGroup(c47570500.ppfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
        if g1:GetCount()>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local sg=g1:Select(tp,1,2,nil)
            for tc in aux.Next(sg) do
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
            end
        end
    end
end
function c47570500.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c47570500.tpcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47570500.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47570500.tpop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c47570500.rtgfilter(c)
    return c:GetFlagEffect(47570500)~=0 and c:GetOriginalType(TYPE_MONSTER) and c:GetOriginalType(TYPE_PENDULUM)
end
function c47570500.efop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()  
    local eq=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    local wg=eq:Filter(c47570500.rtgfilter,nil,tp)
    local wbc=wg:GetFirst()
    while wbc do
        local code=wbc:GetOriginalCode()
        if c:IsFaceup() and c:GetFlagEffect(code)==0 then
        c:CopyEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING, 1)
        c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)  
        end 
        wbc=wg:GetNext()
    end  
end