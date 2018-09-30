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
	--remove redirect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTargetRange(0,LOCATION_DECK+LOCATION_ONFIELD)
	e1:SetCondition(c11113171.condition)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c11113171.regcon)
	e2:SetOperation(c11113171.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c11113171.condition(e)
    local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,11113171)==0
end
function c11113171.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c11113171.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11113171.cfilter,1,nil,1-tp)
end
function c11113171.regop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(tp,11113171)==0 then
	    Duel.RegisterFlagEffect(tp,11113171,RESET_PHASE+PHASE_END,0,1)
	end	
end