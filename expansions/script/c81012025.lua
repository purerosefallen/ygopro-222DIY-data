--Answer·古贺小春
function c81012025.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
	e1:SetCost(c81012025.ccost)
	e1:SetOperation(c81012025.acop)
	c:RegisterEffect(e1)
end
function c81012025.ccost(e,c,tp)
	return Duel.CheckLPCost(tp,1000)
end
function c81012025.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,1000)
end
