--响色的扭结崩断
function c65020134.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,65020134)
	e1:SetCondition(c65020134.condition)
	e1:SetTarget(c65020134.target)
	e1:SetOperation(c65020134.activate)
	c:RegisterEffect(e1)
end
function c65020134.cfilter(c)
	return c:IsSetCard(0xcda4) and c:IsType(TYPE_MONSTER) and ((c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove()) or (c:IsLocation(LOCATION_REMOVED) and c:IsAbleToDeck()) and ((c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_MZONE)) and c:IsAbleToGrave()))
end
function c65020134.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65020134.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and ep~=tp
end
function c65020134.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c65020134.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		local g=Duel.SelectMatchingCard(tp,c65020134.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		local tc=g:GetFirst()
		local sg=Group.FromCards(ec,tc)
		if tc:IsLocation(LOCATION_HAND+LOCATION_MZONE) then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		elseif tc:IsLocation(LOCATION_GRAVE) then
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		elseif tc:IsLocation(LOCATION_REMOVED) then
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end
