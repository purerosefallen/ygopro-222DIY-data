--真理的看破
function c12009034.initial_effect(c)
	--bbb shi bbb
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12009034,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12009034)
	e1:SetCost(c12009034.cost)
	e1:SetOperation(c12009034.operation)
	c:RegisterEffect(e1)   
end
function c12009034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c12009034.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c12009034.disop)
	Duel.RegisterEffect(e1,tp)
end
function c12009034.filter(c,rc)
	return c:IsAbleToGrave() and c:IsCode(rc:GetCode())
end
function c12009034.disop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsActiveType(TYPE_MONSTER) or not Duel.IsChainDisablable(ev) then return end
	local rc=re:GetHandler()
	if Duel.IsExistingMatchingCard(c12009034.filter,tp,LOCATION_DECK,0,2,nil,rc) and Duel.SelectYesNo(tp,aux.Stringid(12009034,0)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	   local tg=Duel.SelectMatchingCard(tp,c12009034.filter,tp,0x1,0,2,2,nil,rc)
	   Duel.SendtoGrave(tg,REASON_EFFECT)
	   Duel.NegateEffect(ev)
	end
end
