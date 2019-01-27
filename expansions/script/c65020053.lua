--暮色居城的起章
function c65020053.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65020053+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65020053.cost)
	e1:SetTarget(c65020053.target)
	e1:SetOperation(c65020053.activate)
	c:RegisterEffect(e1)
end
function c65020053.fil(c)
	return c:IsSetCard(0x5da1) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) 
end
function c65020053.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c65020053.fil,tp,LOCATION_HAND+LOCATION_MZONE,0,e:GetHandler())==0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.ConfirmCards(1-tp,g)
end
function c65020053.filter(c)
	return c:IsSetCard(0x5da1) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c65020053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020053.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65020053.refil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65020053.refil(c)
	return c:IsAbleToRemove() and not c:IsType(TYPE_TOKEN)
end
function c65020053.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65020053.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			local g2=Duel.SelectMatchingCard(tp,c65020053.refil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if g2:GetCount()>0 then
				Duel.HintSelection(g2)
				Duel.Remove(g2,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	end
end
