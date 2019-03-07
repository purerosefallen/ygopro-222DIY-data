--陰義 背理的一射
function c62501016.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,62501016+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c62501016.condition)
	e1:SetTarget(c62501016.target)
	e1:SetOperation(c62501016.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
		e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND+LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c62501016.cost)
	e2:SetCondition(c62501016.condition2)
	e2:SetOperation(c62501016.activate2)
	c:RegisterEffect(e2)
end
function c62501016.cfilter(c)
	return c:IsFaceup() and  c:IsCode(62501007)
end
function c62501016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c62501016.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c62501016.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
	 --   and Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,0x4808)
end
function c62501016.condition2(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c62501016.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
	  --  and Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,0x4808)
end
function c62501016.filter(c)
	return c:IsFaceup() and not (c:IsAttack(0) and c:IsDefense(0) and c:IsDisabled())
end
function c62501016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_SZONE) and c62501016.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c62501016.filter,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c62501016.filter,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,1,1,nil)
end
function c62501016.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
function c62501016.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
end