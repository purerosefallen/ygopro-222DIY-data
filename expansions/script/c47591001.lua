--一伐的祈愿
local m=47591001
local cm=_G["c"..m]
function c47591001.initial_effect(c)
    --damage conversion
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47591001,0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_BATTLE_PHASE+TIMING_STANDBY_PHASE,TIMING_BATTLE_PHASE)
    e1:SetCountLimit(1,47591001+EFFECT_COUNT_CODE_DUEL)
    e1:SetCondition(c47591001.con)
    e1:SetOperation(c47591001.activate)
    c:RegisterEffect(e1)
    --Activate2
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47591001,1))
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMING_END_PHASE)
    e2:SetCountLimit(1,47591011)
    e2:SetTarget(c47591001.target2)
    e2:SetOperation(c47591001.activate2)
    c:RegisterEffect(e2)
end
function c47591001.cfilter(c,tp)
    return c:IsCode(47591911) 
end
function c47591001.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47591001.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c47591001.activate(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_REVERSE_DAMAGE)
    e1:SetTargetRange(1,0)
    e1:SetValue(1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
        Duel.SetChainLimit(aux.FALSE)
    end
end
function c47591001.filter(c)
    return c:IsSetCard(0x5d1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c47591001.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47591001.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47591001.activate2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47591001.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
