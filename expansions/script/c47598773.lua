--堕落的圣少女 贞德
local m=47598773
local cm=_G["c"..m]
function c47598773.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,8,2,c47598773.ovfilter,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),2,c47598773.xyzop)
    c:EnableReviveLimit()
    --maintain
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(c47598773.mtcon)
    e5:SetOperation(c47598773.mtop)
    c:RegisterEffect(e5)
    --disable
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47598773,0))
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,47598773)
    e1:SetCondition(c47598773.con)
    e1:SetOperation(c47598773.op)
    c:RegisterEffect(e1)
     --update atk,def
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c47598773.boval)
    c:RegisterEffect(e2)
    --to defense
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c47598773.poscon)
    e4:SetOperation(c47598773.posop)
    c:RegisterEffect(e4)
    --indes
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c47598773.indcon)
    e6:SetValue(1)
    c:RegisterEffect(e6)
end
function c47598773.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5d3) and c:IsType(TYPE_SYNCHRO)
end
function c47598773.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,47598773)==0 end
    Duel.RegisterFlagEffect(tp,47598773,RESET_PHASE+PHASE_END,0,1)
end
function c47598773.indcon(e)
    return e:GetHandler():GetOverlayCount()>0
end
function c47598773.mtcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c47598773.mtop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) then
        e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
    else
        Duel.Destroy(e:GetHandler(),REASON_COST)
    end
end
function c47598773.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c47598773.filter(c)
    return c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or c:IsType(TYPE_EFFECT)) and not c:IsDisabled()
end
function c47598773.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c47598773.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
end
function c47598773.boval(e,c)
    local cont=c:GetControler()
    if Duel.GetLP(cont)<Duel.GetLP(1-cont) then 
    return Duel.GetLP(1-cont)-Duel.GetLP(cont)
    end
end
function c47598773.poscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetAttackedCount()>0
end
function c47598773.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsAttackPos() then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    end
end