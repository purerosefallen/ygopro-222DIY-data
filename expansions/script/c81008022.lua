--新·炸·鸡
function c81008022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCountLimit(1,81008022+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c81008022.condition)
	e1:SetOperation(c81008022.activate)
	c:RegisterEffect(e1)
end
function c81008022.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>=4000
end
function c81008022.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,4000)
end