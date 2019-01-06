--吃西瓜
function c81008038.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c81008038.disop)
	c:RegisterEffect(e2)
end
function c81008038.disop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(ATTRIBUTE_EARTH) then
		Duel.NegateActivation(ev)
	end
end
