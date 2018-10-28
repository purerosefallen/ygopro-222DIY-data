--魔法师打捞
function c4212206.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c4212206.cost)
    e1:SetTarget(c4212206.target)
    e1:SetOperation(c4212206.activate)
    c:RegisterEffect(e1)
end
function c4212206.filter(c)
    return c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c4212206.cfilter(c)
    return c:IsType(TYPE_TUNER) and c:IsRace(RACE_SPELLCASTER) and c:GetLevel()==3 and c:IsDiscardable()
end
function c4212206.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c4212206.cfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,c4212206.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c4212206.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and chkc:FilterCount(c4212206.filter)>=2 end
    if chk==0 then return Duel.IsExistingTarget(c4212206.filter,tp,LOCATION_GRAVE,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.GetMatchingGroup(c4212206.filter,tp,LOCATION_GRAVE,0,nil):Select(tp,2,2,nil)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c4212206.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    if sg:GetCount()>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
    end
end