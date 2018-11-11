--世界乌冬面锦标赛
function c81009057.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81009057+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81009057.condition)
	e1:SetOperation(c81009057.activate)
	c:RegisterEffect(e1)
end
function c81009057.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(1-tp)<1001
end
function c81009057.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,5000)
end
