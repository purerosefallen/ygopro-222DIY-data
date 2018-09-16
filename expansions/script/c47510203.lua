--阿卡鲁姆的转世 太阳
local m=47510203
local cm=_G["c"..m]
function c47510203.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --pendulum effect
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510203,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47510203)
    e1:SetCost(c47510203.mcost)
    e1:SetTarget(c47510203.mtg)
    e1:SetOperation(c47510203.mop)
    c:RegisterEffect(e1)
    --splimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c47510203.splimit)
    c:RegisterEffect(e2)  
    --Summon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SUMMON)
    e3:SetDescription(aux.Stringid(47510203,1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,47510200)
    e3:SetCost(c47510203.scost)
    e3:SetTarget(c47510203.stg)
    e3:SetOperation(c47510203.sop)
    c:RegisterEffect(e3)  
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47510203,1))
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetOperation(c47510203.sumop)
    c:RegisterEffect(e4)
    --indes
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetRange(LOCATION_EXTRA)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE))
    e5:SetValue(500)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e6)
end
function c47510203.splimit(e,c)
    return not c:IsAttribute(ATTRIBUTE_FIRE)
end
function c47510203.mcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler() end
    Duel.SendtoExtraP(e:GetHandler(),nil,0,REASON_COST)
end
function c47510203.mtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c47510203.mfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c47510203.mop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47510203.mfilter,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    while tc do
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_EXTRA_ATTACK)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e3:SetValue(1)
        tc:RegisterEffect(e3)
       tc=g:GetNext()
    end
end
function c47510203.scost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,nil,ATTRIBUTE_FIRE) end
    local g=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,nil,ATTRIBUTE_FIRE)
    Duel.Release(g,REASON_COST)
end
function c47510203.ttcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c47510203.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
        e1:SetCondition(c47510203.ttcon)
        c:RegisterEffect(e1)
        local res=c:IsSummonable(true,nil) or c:IsAbleToGrave()
        e1:Reset()
        return res
    end
end
function c47510203.sop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c47510203.ttcon)
    c:RegisterEffect(e1)
    if c:IsSummonable(true,nil) then
    Duel.Summon(tp,c,true,nil)
    end
end
function c47510203.sumop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE))
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetValue(c47510203.indval)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetValue(1)
    Duel.RegisterEffect(e2,tp)
end
function c47510203.atktg(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c47510203.indval(e,c)
    return not c:IsAttribute(ATTRIBUTE_FIRE)
end