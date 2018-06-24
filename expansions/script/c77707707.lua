--Vessel of Sin »Æ½ðÔ¿³×
function c77707707.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77707707+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(c77707707.cost)
	e1:SetTarget(c77707707.target)
	e1:SetOperation(c77707707.operation)
	c:RegisterEffect(e1)
end
function c77707707.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c77707707.filter(c)
	return c:IsSetCard(0xa9c0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function c77707707.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77707707.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77707707.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77707707.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end