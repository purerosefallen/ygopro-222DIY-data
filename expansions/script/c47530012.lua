--盖马克
local m=47530012
local cm=_G["c"..m]
function c47530012.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),3,5)
    c:EnableReviveLimit() 
    --todeck
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47530012,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1)
    e1:SetCost(c47530012.cost)
    e1:SetTarget(c47530012.tktg)
    e1:SetOperation(c47530012.tkop)
    c:RegisterEffect(e1)   
    --full fire
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c47530012.destg)
    e2:SetOperation(c47530012.desop)
    c:RegisterEffect(e2)
end
function c47530012.cfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost() and c:IsRace(RACE_MACHINE)
end
function c47530012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47530012.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c47530012.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    if g:GetFirst():IsLocation(LOCATION_REMOVED) and g:GetFirst():IsFacedown() then
        Duel.ConfirmCards(1-tp,g)
    end
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c47530012.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,47531012,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c47530012.tkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,47531012,0,0x4011,2000,2000,1,RACE_MACHINE,ATTRIBUTE_LIGHT) then
        local token=Duel.CreateToken(tp,47531012)
        Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_ATTACK_ALL)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        token:RegisterEffect(e1,true)
        if Duel.SpecialSummonComplete() then
        local cg=token:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
            if cg:GetCount()>0 then
            Duel.HintSelection(cg)
            Duel.SendtoGrave(cg,REASON_RULE) 
            end
        end
    end
end
function c47530012.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,4,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,4,4,c)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,4,0,0)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,4,0,0)
end
function c47530012.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
end