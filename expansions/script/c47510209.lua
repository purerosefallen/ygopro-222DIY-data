--阿卡鲁姆的转世 星
local m=47510209
local cm=_G["c"..m]
function cm.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --pendulum effect
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510209,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47510209)
    e1:SetCost(c47510209.mcost)
    e1:SetOperation(c47510209.mop)
    c:RegisterEffect(e1)
    --splimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c47510209.splimit)
    c:RegisterEffect(e2)  
    --Summon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SUMMON)
    e3:SetDescription(aux.Stringid(47510209,1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,47510200)
    e3:SetCost(c47510209.scost)
    e3:SetTarget(c47510209.stg)
    e3:SetOperation(c47510209.sop)
    c:RegisterEffect(e3)  
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47510209,1))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetOperation(c47510209.sumop)
    c:RegisterEffect(e4)  
    --indes
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetRange(LOCATION_EXTRA)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT))
    e5:SetValue(300)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e6)
    local e7=e5:Clone()
    e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e7:SetValue(c47510209.efilter1)
    c:RegisterEffect(e7)
end
function c47510209.splimit(e,c)
    return not (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK))
end
function c47510209.mcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler() end
    Duel.SendtoExtraP(e:GetHandler(),nil,0,REASON_COST)
end
function c47510209.mfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c47510209.mop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47510209.mfilter,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    while tc do
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_EXTRA_ATTACK)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e3:SetValue(2)
        tc:RegisterEffect(e3)
       tc=g:GetNext()
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e1:SetCondition(c47510209.rdcon1)
    e1:SetOperation(c47510209.rdop1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e2:SetCondition(c47510209.rdcon2)
    e2:SetOperation(c47510209.rdop2)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e2,1-tp)
end
function c47510209.rdcon1(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp
end
function c47510209.rdop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(tp,ev*2)
end
function c47510209.rdcon2(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp
end
function c47510209.rdop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(tp,ev/2)
end
function c47510209.scost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) end
    local g=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,nil,ATTRIBUTE_LIGHT)
    Duel.Release(g,REASON_COST)
end
function c47510209.ttcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c47510209.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
        e1:SetCondition(c47510209.ttcon)
        c:RegisterEffect(e1)
        local res=c:IsSummonable(true,nil) or c:IsAbleToGrave()
        e1:Reset()
        return res
    end
end
function c47510209.sop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c47510209.ttcon)
    c:RegisterEffect(e1)
    if c:IsSummonable(true,nil) then
    Duel.Summon(tp,c,true,nil)
    end
end
function c47510209.thfilter(c)
    return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c47510209.sumop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
    local g=Duel.SelectMatchingCard(tp,c47510209.thfilter,tp,0,LOCATION_MZONE,1,1,nil)
        Duel.SendtoHand(g,nil,1,REASON_EFFECT)
end
function c47510209.efilter1(e,re,rp)
    return re:IsActiveType(TYPE_EFFECT)
end