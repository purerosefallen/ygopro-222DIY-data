--Sunny Side
function c81008040.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81008040+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81008040.condition)
	e1:SetTarget(c81008040.target)
	e1:SetOperation(c81008040.operation)
	c:RegisterEffect(e1)
end
function c81008040.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(1-tp)<1001
end
function c81008040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,3000)
end
function c81008040.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,3000,REASON_EFFECT)
	Duel.Recover(1-tp,3000,REASON_EFFECT)
end
