--盛装的决斗者 特蕾兹
function c47551111.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)  
    aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND+LOCATION_EXTRA)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47551111,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47551111)
    e1:SetCondition(c47551111.hspcon)
    e1:SetOperation(c47551111.hspop)
    e1:SetValue(SUMMON_TYPE_RITUAL)
    c:RegisterEffect(e1) 
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c47551111.inmcon)
    e2:SetValue(c47551111.efilter)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BATTLE_DAMAGE)
    e3:SetOperation(c47551111.damop)
    c:RegisterEffect(e3)  
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EXTRA_ATTACK)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
end
function c47551111.hspcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    return ft>-1 and Duel.IsExistingMatchingCard(c47551111.tefilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,nil)
end
function c47551111.tefilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsLevelAbove(5) and c:IsFaceup()
end
function c47551111.hspop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47551111,0))
    local g=Duel.SelectMatchingCard(tp,c47551111.tefilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,2,nil)
    local tc=g:GetFirst()
    while tc do
        Duel.SendtoDeck(tc,nil,2,REASON_COST)
        tc=g:GetNext()
    end
end
function c47551111.damop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local atk=c:GetAttack()
    Duel.Damage(1-tp,atk,REASON_BATTLE)
end
function c47551111.inmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c47551111.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end