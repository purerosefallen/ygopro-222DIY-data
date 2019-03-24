--鸽子警告
function c81010022.initial_effect(c)
	c:SetUniqueOnField(1,0,81010022)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c81010022.condition)
	e2:SetTarget(c81010022.target)
	e2:SetOperation(c81010022.operation)
	c:RegisterEffect(e2)
end
function c81010022.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND+LOCATION_DECK)
end
function c81010022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c81010022.filter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c81010022.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if eg:IsExists(c81010022.filter,1,nil,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,1-tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(81010022,1)) then
		local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,1-tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
		end
	end
	if eg:IsExists(c81010022.filter,1,nil,1-tp) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(81010022,1)) then
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
		end
	end
end
