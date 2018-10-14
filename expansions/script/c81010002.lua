--渋谷凛
function c81010002.initial_effect(c)
    c:EnableReviveLimit()
    --code
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_CHANGE_CODE)
    e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
    e1:SetValue(81010019)
    c:RegisterEffect(e1)
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetCondition(c81010002.indcon)
    e2:SetTarget(c81010002.indtg)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --chain attack
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(81010002,0))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetCountLimit(1,81010002)
    e3:SetCondition(c81010002.atcon)
    e3:SetOperation(c81010002.atop)
    c:RegisterEffect(e3)
end
function c81010002.indcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c81010002.indtg(e,c)
    return c:IsType(TYPE_RITUAL)
end
function c81010002.mfilter(c)
    return not c:IsType(TYPE_RITUAL)
end
function c81010002.atcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER) and c:IsChainAttackable() and c:IsStatus(STATUS_OPPO_BATTLE)
end
function c81010002.atop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChainAttack()
end

