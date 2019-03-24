--恶噬吞影
function c65020098.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,65020098+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65020098.con)
	e1:SetTarget(c65020098.tg)
	e1:SetOperation(c65020098.op)
	c:RegisterEffect(e1)
end
function c65020098.confil(c,tp,re)
	return c:GetPreviousControler()==1-tp and c:IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0xada3)
end
function c65020098.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65020098.confil,1,nil,tp,re)
end
function c65020098.thfil(c)
	return c:IsSetCard(0xada3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65020098.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020098.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,5,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,5,0,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65020098.op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,5,nil) then return end
	local gn=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,5,5,nil)
	if Duel.SendtoDeck(gn,nil,2,REASON_COST)==5 then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c65020098.thfil,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end