--唐突请客
function c81010048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81010048+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81010048.target)
	e1:SetOperation(c81010048.activate)
	c:RegisterEffect(e1)
end
function c81010048.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>Duel.GetLP(1-tp) end
end
function c81010048.activate(e,tp,eg,ep,ev,re,r,rp)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	if lp1>lp2 then
		Duel.SetLP(1-tp,lp1)
	end
end
