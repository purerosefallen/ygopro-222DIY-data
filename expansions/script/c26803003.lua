--安洁莉娅的苹果
function c26803003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26803003+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c26803003.condition)
	e1:SetOperation(c26803003.activate)
	c:RegisterEffect(e1)
end
function c26803003.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(1-tp)<=1000
end
function c26803003.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,4000)
end
