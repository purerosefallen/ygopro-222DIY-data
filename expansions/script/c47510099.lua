--小马星晶兽 奥尼姬斯
local m=47510099
local cm=_G["c"..m]
function c47510099.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,47510095)
    e1:SetCost(c47510099.cost)
    e1:SetOperation(c47510099.activate)
    c:RegisterEffect(e1)  
    --act in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e2:SetCondition(c47510099.handcon)
    c:RegisterEffect(e2)
end
function c47510099.handcon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.GetFieldCard(tp,LOCATION_PZONE,0) and not Duel.GetFieldCard(tp,LOCATION_PZONE,1)
end
function c47510099.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c47510099.filter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x5da) and not c:IsForbidden()
end
function c47510099.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c47510099.filter,tp,LOCATION_DECK,0,nil)
    local ct=0
    if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct=ct+1 end
    if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
    if ct>0 and g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local sg=g:Select(tp,1,ct,nil)
        local sc=sg:GetFirst()
        while sc do
            Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
            sc=sg:GetNext()
        end
    end
end