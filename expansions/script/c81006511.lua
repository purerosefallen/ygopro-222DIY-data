--Answer·佐藤心·S
function c81006511.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81006511+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(c81006511.cost)
	e1:SetOperation(c81006511.operation)
	c:RegisterEffect(e1)
end
function c81006511.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c81006511.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.SelectOption(tp,81006511*16,81006511*16+1)
	if op==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetCode(EFFECT_CANNOT_DISCARD_HAND)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END,1)
		Duel.RegisterEffect(e1,tp)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetValue(c81006511.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c81006511.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
