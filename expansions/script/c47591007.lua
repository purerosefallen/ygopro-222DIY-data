--七星的辉煌
local m=47591007
local cm=_G["c"..m]
function c47591007.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_DAMAGE_STEP)
    e1:SetCondition(c47591007.condition)
    e1:SetCost(c47591007.cost)
    e1:SetTarget(c47591007.target)
    e1:SetOperation(c47591007.activate)
    c:RegisterEffect(e1)
end 
function c47591007.condition(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetCurrentPhase()==PHASE_DAMAGE and Duel.IsDamageCalculated() then return false end
    return true
end  
function c47591007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x5d6,5,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x5d6,5,REASON_COST)
end
function c47591007.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function c47591007.atkfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c47591007.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47522007.atkfilter,tp,LOCATION_MZONE,0,nil)
    local atk=g:GetSum(Card.GetAttack)
    if g:GetCount()>0 then
        local sc=g:GetFirst()
        while sc do
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
            e1:SetValue(atk)
            sc:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_UPDATE_DEFENSE)
            sc:RegisterEffect(e2)
            sc=g:GetNext()
        end
    end
end