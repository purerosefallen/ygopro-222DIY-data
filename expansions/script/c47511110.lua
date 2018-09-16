--黑炎之子 原初巴哈姆特
local m=47511110
local cm=_G["c"..m]
function c47511110.initial_effect(c)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c)    
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47511110.psplimit)
    c:RegisterEffect(e1) 
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47511110,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47511110)
    e2:SetCost(c47511110.thcost)
    e2:SetTarget(c47511110.thtg)
    e2:SetOperation(c47511110.thop)
    c:RegisterEffect(e2)
    --remove
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1,47511117)
    e3:SetCondition(c47511110.rmcon)
    e3:SetOperation(c47511110.rmop)
    c:RegisterEffect(e3)
    --attack
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_ATTACK_ALL)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_IMMUNE_EFFECT)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(c47511110.efilter)
    c:RegisterEffect(e6)
end
function c47511110.pefilter(c)
    return c:IsType(TYPE_PENDULUM)
end
function c47511110.psplimit(e,c,tp,sumtp,sumpos)
    return not c47511110.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_SPECIAL
end
function c47511110.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c47511110.filter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_RITUAL) and c:IsRace(RACE_DRAGON) and c:IsLevelAbove(9) and c:IsAbleToHand()
end
function c47511110.filter1(c)
    return c:IsCode(47511114)
end
function c47511110.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47511110.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c47511110.filter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c47511110.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47511110.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT) then
        Duel.ConfirmCards(1-tp,g)
        local g1=Duel.SelectMatchingCard(tp,c47511110.filter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil) 
        if g1:GetCount()>0 then
        Duel.SendtoHand(g1,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g1)
        end
    end
end
function c47511110.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c47511110.rmop(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    while tc do
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_UPDATE_ATTACK)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e3:SetValue(-1500)
        tc:RegisterEffect(e3)
        local e4=e3:Clone()
        e4:SetCode(EFFECT_UPDATE_DEFENSE)
        tc:RegisterEffect(e4)
       tc=g:GetNext()
    end
end
function c47511110.efilter(e,te)
    local c=e:GetHandler()
    local ec=te:GetHandler()
    if ec:IsHasCardTarget(c) or (te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)) then return false
    end
    return true
end