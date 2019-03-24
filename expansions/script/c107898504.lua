
function c107898504.initial_effect(c)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898504,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c107898504.condition)
	e1:SetCost(c107898504.cost)
	e1:SetTarget(c107898504.target)
	e1:SetOperation(c107898504.operation)
	c:RegisterEffect(e1)
end
function c107898504.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x575)
end
function c107898504.filter(c)
	return c:IsCode(107898101) and c:IsFaceup()
end
function c107898504.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetTurnPlayer()==tp
end
function c107898504.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()==1
	or Duel.IsCanRemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	and not e:GetHandler():IsPublic() end
	if e:GetHandler():GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	end
end
function c107898504.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c107898504.filter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToRemove(tp) and Duel.IsExistingTarget(c107898504.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c107898504.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c107898504.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then
		Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_EFFECT)
	end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		if not tc:IsType(TYPE_EFFECT) then
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_ADD_TYPE)
			e0:SetValue(TYPE_EFFECT)
			e0:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e0,true)
		end
		--remove
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(107898504)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		--lv change
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(LOCATION_HAND,0)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x575b))
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(107898504,0))
	end
end
function c107898504.rmtarget(e,c)
	return not c:IsLocation(0x80) and c:GetOwner()==e:GetHandlerPlayer() and c:IsSetCard(0x575b) and c:IsLocation(LOCATION_ONFIELD)
end