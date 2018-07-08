--小姆姆
function c10173071.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173071,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,10173071)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	   return eg:IsExists(aux.FilterEqualFunction(Card.GetSummonPlayer,1-tp),1,nil)
	end)
	e1:SetCost(c10173071.cost)
	e1:SetOperation(c10173071.operation)
	c:RegisterEffect(e1)	
end
function c10173071.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c10173071.filter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c10173071.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(aux.FilterEqualFunction(Card.GetSummonPlayer,1-tp),nil)
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTarget(c10173071.sumlimit)
	e1:SetLabelObject(g)
	Duel.RegisterEffect(e1,tp)
end 
function c10173071.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	local g=e:GetLabelObject()
	if not c:IsLocation(LOCATION_EXTRA) then return end
	for tc in aux.Next(g) do
		if c:GetOriginalRace()==tc:GetOriginalRace() then return true end
	end
	return false
end
