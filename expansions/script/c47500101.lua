--拳皇 姬塔
function c47500101.initial_effect(c)
    --synchro summon
    aux.AddSynchroMixProcedure(c,aux.Tuner(nil),aux.Tuner(nil),nil,aux.FilterBoolFunction(Card.IsCode,47500000),1,1)
    c:EnableReviveLimit() 
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)  
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47500101.psplimit)
    c:RegisterEffect(e1)   
    --double battle phase
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47500101)
    e2:SetOperation(c47500101.bpop)
    c:RegisterEffect(e2) 
    --act limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(c47500101.negcon)
    e3:SetOperation(c47500101.negop)
    c:RegisterEffect(e3)
    --battle soul
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_BATTLE_DAMAGE)
    e4:SetCondition(c47500101.cacon)
    e4:SetOperation(c47500101.caop)
    c:RegisterEffect(e4) 
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_DAMAGE)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e7:SetCode(EVENT_BE_BATTLE_TARGET)
    e7:SetRange(LOCATION_MZONE)
    e7:SetOperation(c47500101.fop1)
    c:RegisterEffect(e7)
    local e8=Effect.CreateEffect(c)
    e8:SetCategory(CATEGORY_DAMAGE)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e8:SetCode(EVENT_BECOME_TARGET)
    e8:SetRange(LOCATION_MZONE)
    e8:SetTarget(c47500101.ftg)
    e8:SetOperation(c47500101.fop2)
    c:RegisterEffect(e8)
end
c47500101.card_code_list={47500000}
function c47500101.pefilter(c)
    return c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER) and c:IsLevel(8)
end
function c47500101.psplimit(e,c,tp,sumtp,sumpos)
    return not c47500101.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47500101.bpop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_BP_TWICE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47500101.negcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47500101.filter(c)
    return c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or c:IsType(TYPE_EFFECT)) and not c:IsDisabled()
end
function c47500101.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c47500101.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetValue(c47500101.aclimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47500101.aclimit(e,re,tp)
    return re:GetHandler():IsOnField() and not re:GetHandler():IsImmuneToEffect(e)
end
function c47500101.cacon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c47500101.caop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChainAttack()
end
function c47500101.fop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local atk=c:GetAttack()
    if Duel.NegateAttack() then
        Duel.Damage(1-tp,atk/2,REASON_EFFECT)
    end
end
function c47500101.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c47500101.fop2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local atk=c:GetAttack()
    if rp==1-tp then    
        Duel.NegateEffect(ev)
        Duel.Damage(1-tp,atk/2,REASON_EFFECT)
    end
end