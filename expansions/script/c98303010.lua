--METHOD IMPLANTA
function c98303010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c98303010.actcon)
	e1:SetTarget(c98303010.acttg)
	e1:SetOperation(c98303010.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c98303010.actcon2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c98303010.cost)
	e3:SetCondition(c98303010.actcon3)
	e3:SetOperation(c98303010.activate2)
	c:RegisterEffect(e3)

end
function c98303010.mzfilter(c,tp)
	return c:IsSetCard(0xad2) and c:IsFaceup() and c:IsControler(tp)
end
function c98303010.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98303010.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and (e:GetHandler():IsLocation(LOCATION_SZONE) or not Duel.IsPlayerAffectedByEffect(tp,98300000))
end
function c98303010.actcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98303010.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,98300000)
end
function c98303010.actcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98303010.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,98300000) and Duel.GetTurnPlayer()~=tp and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c98303010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c98303010.bhfilter(c)
	return (c:IsSetCard(0xad1) or c:IsSetCard(0xad2) or c:IsSetCard(0xad3) or c:IsSetCard(0xad4)) and c:IsFaceup() and not c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c98303010.bdfilter(c)
	return (c:IsSetCard(0xad1) or c:IsSetCard(0xad2) or c:IsSetCard(0xad3) or c:IsSetCard(0xad4)) and c:IsFaceup() and not c:IsType(TYPE_FIELD) and c:IsAbleToDeck()
end
function c98303010.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	if chk==0 then return Duel.IsExistingMatchingCard(c98303010.bhfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_TODECK,nil,nil,0,0)
end
function c98303010.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c98303010.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) then return false end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(98303010,1))
	e:GetHandler():CancelToGrave()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(c98303010.bthop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function c98303010.activate2(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c98303010.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp)) then return false end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(98303010,1))
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(c98303010.bthop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function c98303010.bthop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() or not Duel.IsExistingMatchingCard(c98303010.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) then
		Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
	else if Duel.IsExistingMatchingCard(c98303010.bhfilter,tp,LOCATION_REMOVED,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c98303010.bhfilter,tp,LOCATION_REMOVED,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
			end
			local tc=g:GetFirst()
			if tc:IsSetCard(0xad2) and Duel.IsExistingMatchingCard(c98303010.bdfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(98303010,2)) then
				local g2=Duel.SelectMatchingCard(tp,c98303010.bdfilter,tp,LOCATION_REMOVED,0,1,2,nil)
				Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
				Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
			else
				Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
			end
		end
	end
end