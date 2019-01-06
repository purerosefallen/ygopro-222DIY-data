--灵子殖装的重构
function c21520048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520048,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21520048+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c21520048.target)
	e1:SetOperation(c21520048.activate)
	c:RegisterEffect(e1)
end
function c21520048.filter(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x494)
end
function c21520048.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x494)
end
function c21520048.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520048.filter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c21520048.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21520048.filter,tp,LOCATION_GRAVE,0,nil)
--	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local thg=Duel.SelectMatchingCard(tp,c21520048.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(thg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,thg)
end
