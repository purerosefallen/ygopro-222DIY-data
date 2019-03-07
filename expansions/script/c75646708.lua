--构造之灵
function c75646708.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75646708+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c75646708.target)
	e1:SetOperation(c75646708.activate)
	c:RegisterEffect(e1)
	--change name
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetValue(75646700)
	c:RegisterEffect(e2)
end
c75646708.card_code_list={75646700}
function c75646708.filter(c)
	return aux.IsCodeListed(c,75646700) and c:IsAbleToHand()
end
function c75646708.efilter(c)
	return c:IsCode(75646700) and c:IsAbleToHand()
end
function c75646708.filter1(c)
	return c:IsCode(75646701,75646707) and c:IsFaceup()
end
function c75646708.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646708.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75646708.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75646708.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	end
	if Duel.IsExistingMatchingCard(c75646708.filter1,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c75646708.efilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75646707,1)) then
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75646708.efilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		end
	end
end
