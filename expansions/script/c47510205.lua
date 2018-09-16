--阿卡鲁姆的转世 正义
local m=47510205
local cm=_G["c"..m]
function c47510205.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --pendulum effect
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510205,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47510205)
    e1:SetCost(c47510205.mcost)
    e1:SetOperation(c47510205.mop)
    c:RegisterEffect(e1)
    --splimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c47510205.splimit)
    c:RegisterEffect(e2)  
    --Summon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SUMMON)
    e3:SetDescription(aux.Stringid(47510205,1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,47510200)
    e3:SetCost(c47510205.scost)
    e3:SetTarget(c47510205.stg)
    e3:SetOperation(c47510205.sop)
    c:RegisterEffect(e3)  
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47510205,1))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetOperation(c47510205.inmop)
    c:RegisterEffect(e4)
    --indes
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e5:SetRange(LOCATION_EXTRA)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c47510205.indtg)
    e5:SetValue(c47510205.indct)
    c:RegisterEffect(e5)
end    
function c47510205.splimit(e,c)
    return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c47510205.mcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler() end
    Duel.SendtoExtraP(e:GetHandler(),nil,0,REASON_COST)
end
function c47510205.mop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    local g2=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local atk=g:GetSum(Card.GetAttack)
    local fatk=atk/g2
    while tc do
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_SET_ATTACK_FINAL)
        e3:SetValue(fatk)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e3)
        tc=g:GetNext()
    end
end
function c47510205.scost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,nil,ATTRIBUTE_WATER) end
    local g=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,nil,ATTRIBUTE_WATER)
    Duel.Release(g,REASON_COST)
end
function c47510205.ttcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c47510205.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
        e1:SetCondition(c47510205.ttcon)
        c:RegisterEffect(e1)
        local res=c:IsSummonable(true,nil) or c:IsAbleToGrave()
        e1:Reset()
        return res
    end
end
function c47510205.sop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c47510205.ttcon)
    c:RegisterEffect(e1)
    if c:IsSummonable(true,nil) then
    Duel.Summon(tp,c,true,nil)
    end
end
function c47510205.inmop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
    e1:SetValue(c47510205.efilter)
    e1:SetOwnerPlayer(tp)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47510205.efilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c47510205.indtg(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c47510205.indct(e,re,r,rp)
    if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
        return 1
    else return 0 end
end