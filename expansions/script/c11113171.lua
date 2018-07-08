--小死神
function c11113171.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11113171,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11113171)
	e1:SetCost(c11113171.cost)
	e1:SetOperation(c11113171.operation)
	c:RegisterEffect(e1)
end
function c11113171.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c11113171.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--cannot to grave as cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_GRAVE_AS_COST)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0,LOCATION_DECK+LOCATION_ONFIELD)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--remove redirect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTargetRange(0,LOCATION_DECK+LOCATION_ONFIELD)
	e2:SetValue(c11113171.valcon)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c11113171.valcon(e)
    local tp=e:GetHandlerPlayer()
	if Duel.GetFlagEffect(tp,11113171)==0 then 
		Duel.RegisterFlagEffect(tp,11113171,RESET_PHASE+PHASE_END,0,1)
		return LOCATION_REMOVED
	end
	return 0
end