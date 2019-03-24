--STSP·残影
function c107898515.initial_effect(c)
	c:EnableReviveLimit()
	--special summon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(c107898515.spcon)
	e1:SetOperation(c107898515.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(107898515,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c107898515.thtg)
	e2:SetOperation(c107898515.thop)
	c:RegisterEffect(e2)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(107898515,2))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c107898515.condition)
	e4:SetCost(c107898515.cost)
	e4:SetTarget(c107898515.target)
	e4:SetOperation(c107898515.operation)
	c:RegisterEffect(e4)
end
function c107898515.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(107898515,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c107898515.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x575)
end
function c107898515.spfilter1(c,tp)
	return c:IsFaceup() and c:IsCode(107898100) and Duel.IsExistingMatchingCard(c107898515.spfilter2,tp,LOCATION_HAND,0,1,c)
end
function c107898515.spfilter2(c)
	return c:IsAbleToDeckAsCost()
end
function c107898515.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c107898515.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c107898515.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c107898515.spfilter2,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,0,REASON_COST)
end
function c107898515.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c107898515.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c107898515.filter(c)
	return c:IsCode(107898102) and c:IsFaceup()
end
function c107898515.filter2(c)
	return c:IsSetCard(0x575) and c:IsFaceup() and c:IsType(TYPE_TOKEN)
end
function c107898515.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetTurnPlayer()==tp
end
function c107898515.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()==1
	or Duel.IsCanRemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	and not e:GetHandler():IsPublic() end
	if e:GetHandler():GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	end
end
function c107898515.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c107898515.filter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToRemove(tp) and Duel.IsExistingTarget(c107898515.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c107898515.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c107898515.cfilter(c)
	return c:IsSetCard(0x575a) and c:GetPreviousLocation()==LOCATION_HAND
end
function c107898515.counter(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c107898515.cfilter,1,nil) then
		e:GetHandler():AddCounter(0x1021,1)
	end
end
function c107898515.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and (c:IsSetCard(0x575b) or c:IsSetCard(0x575c)) and c:GetPreviousLocation()==LOCATION_HAND and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1021,1)
	end
end
function c107898515.councon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c107898515.operation(e,tp,eg,ep,ev,re,r,rp)
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
		tc:EnableCounterPermit(0x1021)
		--add counter
		local e21=Effect.CreateEffect(c)
		e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e21:SetCode(EVENT_SPSUMMON_SUCCESS)
		e21:SetRange(LOCATION_MZONE)
		e21:SetCondition(c107898515.councon)
		e21:SetOperation(c107898515.counter)
		e21:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e21,true)
		--Add counter when effect
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EVENT_CHAINING)
		e2:SetRange(LOCATION_MZONE)
		e2:SetOperation(aux.chainreg)
		tc:RegisterEffect(e2,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(c107898515.condition)
		e2:SetOperation(c107898515.ctop)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		--remove counter
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_PHASE+PHASE_END)
		e5:SetRange(LOCATION_MZONE)
		e5:SetDescription(aux.Stringid(107898515,4))
		e5:SetCondition(c107898515.rmcon)
		e5:SetOperation(c107898515.rmop)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e5,true)
		tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(107898515,0))
	end
end
function c107898515.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x1021)>0
end
function c107898515.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rcc=e:GetHandler():GetCounter(0x1021)
	e:GetHandler():RemoveCounter(tp,0x1021,rcc,REASON_EFFECT)
	local tdef=rcc*100
	local y1=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,107898150,0x575,0x4011,0,tdef,10,RACE_ROCK,ATTRIBUTE_LIGHT))
	local y2=Duel.IsExistingTarget(c107898515.filter2,tp,LOCATION_MZONE,0,1,nil)
	if not y1 and not y2 then return end
	Duel.BreakEffect()
	if y2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c107898515.filter2,tp,   LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			local rc=g:GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			e1:SetValue(tdef)
			rc:RegisterEffect(e1)
		end
	else
		local token=Duel.CreateToken(tp,107898150)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_DEFENSE)
		e1:SetValue(tdef)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end