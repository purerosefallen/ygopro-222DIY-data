--灵摆回旋
function c12009011.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12009011)
	e1:SetCost(c12009011.cost)
	e1:SetOperation(c12009011.operation)
	c:RegisterEffect(e1)
end
function c12009011.costfilter(c,ft,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c12009011.tgfilter,tp,LOCATION_DECK,0,1,c,c:GetLeftScale())
end
function c12009011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12009011.cosfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c12009011.cosfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c12009011.tgfilter(c,sc)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
		and c:GetLeftScale()==sc
end
function c12009011.operation(e,tp,gs,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c12009011.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(12009011,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c12009011.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
end
end