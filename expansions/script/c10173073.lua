--小白白
function c10173073.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173073,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10173073)
	e1:SetHintTiming(0,0x1c0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c10173073.cost)
	e1:SetOperation(c10173073.operation)
	c:RegisterEffect(e1)	 
end
function c10173073.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c10173073.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetValue(c10173073.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetTarget(c10173073.reptg)
	e2:SetValue(c10173073.repval)
	Duel.RegisterEffect(e2,tp)
end
function c10173073.efilter(e,te,c)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c10173073.repfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp) and c:GetDestination()~=LOCATION_GRAVE 
end
function c10173073.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10173073.repfilter,1,nil,1-tp) end
	local g=eg:Filter(c10173073.repfilter,nil,1-tp)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_REDIRECT)
end
function c10173073.repval(e,c)
	return c10173073.repfilter(c,1-e:GetHandlerPlayer())
end
