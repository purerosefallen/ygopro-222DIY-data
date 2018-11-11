--Dragonlord's Eternium
--Delivery
local card = c88800005
local id=88800005
function card.initial_effect(c)
        --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_ATTACK+TIMING_END_PHASE)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(88800005,0))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_SZONE)
    e2:SetHintTiming(0,TIMING_END_PHASE)
    e2:SetCountLimit(1)
    e2:SetTarget(card.drtg)
    e2:SetOperation(card.drop)
    c:RegisterEffect(e2)
    --discard & salvage
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(88800005,1))
    e3:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,TIMING_END_PHASE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1,id)
    e3:SetCost(card.thcost)
    e3:SetTarget(card.thtg)
    e3:SetOperation(card.thop)
    c:RegisterEffect(e3)
end
function card.tdfilter(c)
    return c:IsSetCard(0x721) and c:IsAbleToDeck()
end
function card.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and card.tdfilter(chkc) end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.IsExistingTarget(card.tdfilter,tp,LOCATION_GRAVE,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,card.tdfilter,tp,LOCATION_GRAVE,0,2,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function card.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if tg:GetCount()<=0 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    Duel.ShuffleDeck(tp)
    Duel.BreakEffect()
    Duel.Draw(tp,1,REASON_EFFECT)
end

function card.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function card.thfilter(c)
    return c:IsSetCard(0x721) and c:IsAbleToHand()
end
function card.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    local ct=hg:GetCount()
    if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(card.thfilter,tp,LOCATION_GRAVE,0,ct,nil) end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,hg,ct,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_GRAVE)
end
function card.thop(e,tp,eg,ep,ev,re,r,rp)
    local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    local ct=Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DISCARD)
    if ct<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(card.thfilter),tp,LOCATION_GRAVE,0,ct,ct,nil)
    if g:GetCount()>0 then
        Duel.BreakEffect()
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end
