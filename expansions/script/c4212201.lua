--魔法师打捞
function c4212201.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c4212201.target)
    e1:SetOperation(c4212201.activate)
    c:RegisterEffect(e1)
end
function c4212201.filter(c)
    return c:GetLevel()==3 and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_TUNER) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c4212201.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local g = Duel.GetMatchingGroup(c4212201.filter,tp,LOCATION_GRAVE,0,nil) 
    if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and chkc:GetClassCount(Card.GetCode)>=2 and chkc:FilterCount(c4212201.filter)>=2 end
    if chk==0 then return Duel.IsExistingTarget(c4212201.filter,tp,LOCATION_GRAVE,0,2,nil) and g:GetClassCount(Card.GetCode)>=2 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g1=g:Select(tp,1,1,nil)
    g:Remove(Card.IsAttribute,nil,g1:GetFirst():GetAttribute())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=g:Select(tp,1,1,nil)
    g1:Merge(g2)
    Duel.SetTargetCard(g1)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c4212201.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    if sg:GetCount()>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
    end
end