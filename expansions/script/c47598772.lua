--圣少女 贞德
local m=47598772
local cm=_G["c"..m]
function c47598772.initial_effect(c)
      --synchro summon
    aux.AddSynchroProcedure(c,c47598772.synfilter,aux.NonTuner(c47598772.synfilter),1)
    c:EnableReviveLimit()
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47598772,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c47598772.atkcon)
    e1:SetOperation(c47598772.atkop)
    c:RegisterEffect(e1)
    --antitrap
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetValue(c47598772.efilter)
    c:RegisterEffect(e3)
    --cannot be target
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetTarget(c47598772.tglimit)
    e4:SetValue(aux.tgoval)
    c:RegisterEffect(e4)
end
function c47598772.synfilter(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c47598772.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47598772.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(0)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end
function c47598772.efilter(e,te)
    return te:IsActiveType(TYPE_TRAP)
end
function c47598772.tglimit(e,c)
    return c:IsType(TYPE_MONSTER) and c~=e:GetHandler()
end