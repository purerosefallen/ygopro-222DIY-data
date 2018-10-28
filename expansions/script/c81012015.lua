--Answer·鹰富士茄子
function c81012015.initial_effect(c)
	c:SetUniqueOnField(1,0,81012015)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,1,2,nil,nil,99)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81012015,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,81012015)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c81012015.condition)
	e1:SetCost(c81012015.cost)
	e1:SetTarget(c81012015.target)
	e1:SetOperation(c81012015.operation)
	c:RegisterEffect(e1)
end
function c81012015.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()<PHASE_MAIN2
end
function c81012015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c81012015.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:IsLevel(1)
end
function c81012015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81012015.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81012015.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c81012015.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c81012015.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLE_DESTROYING)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetOperation(c81012015.desop)
		tc:RegisterEffect(e1)
	end
end
function c81012015.filter2(c)
	return c:IsFaceup() and ((c:IsRace(RACE_FAIRY) and c:IsLevel(1)) or c:IsCode(81012015))
end
function c81012015.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81012015.filter2,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
