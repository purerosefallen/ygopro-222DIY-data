--STST·伤口
function c107898151.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c107898151.condition)
	e1:SetOperation(c107898151.activate)
	c:RegisterEffect(e1)
end
function c107898151.cfilter(c)
	return c:IsFaceup() and c:IsCode(107898211)
end
function c107898151.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c107898151.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c107898151.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end