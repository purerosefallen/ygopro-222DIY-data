--穿刺极乐
function c65071072.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,65071072+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c65071072.target)
	e2:SetOperation(c65071072.operation)
	c:RegisterEffect(e2)
end
function c65071072.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function c65071072.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(c65071072.actcon)
	Duel.RegisterEffect(e1,tp)
end
function c65071072.actcon(e)
	return Duel.GetCurrentChain()<=0 
end