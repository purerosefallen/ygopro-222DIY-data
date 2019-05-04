--METHOD REPLEKIA
function c98303020.initial_effect(c)
	c:EnableCounterPermit(0xad1)
	c:SetCounterLimit(0xad1,10)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c98303020.actcon)
	e1:SetTarget(c98303020.acttg)
	e1:SetOperation(c98303020.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c98303020.actcon2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c98303020.cost)
	e3:SetCondition(c98303020.actcon3)
	e3:SetOperation(c98303020.activate2)
	c:RegisterEffect(e3)

end
function c98303020.mzfilter(c,tp)
	return c:IsSetCard(0xad2) and c:IsFaceup() and c:IsControler(tp)
end
function c98303020.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98303020.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and (e:GetHandler():IsLocation(LOCATION_SZONE) or not Duel.IsPlayerAffectedByEffect(tp,98300000))
end
function c98303020.actcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98303020.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,98300000)
end
function c98303020.actcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98303020.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,98300000) and Duel.GetTurnPlayer()~=tp and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c98303020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

function c98303020.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c98303020.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c98303020.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) then return false end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(98303020,1))
	e:GetHandler():CancelToGrave()
	--add counter
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(aux.chainreg)
	e:GetHandler():RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c98303020.acop)
	e:GetHandler():RegisterEffect(e2)

	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c98303020.bthop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e3)
end
function c98303020.activate2(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c98303020.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp)) then return false end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(98303020,1))
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	--add counter
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(aux.chainreg)
	e:GetHandler():RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c98303020.acop)
	e:GetHandler():RegisterEffect(e2)

	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c98303020.bthop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e3)
end
function c98303020.acop(e,tp,eg,ep,ev,re,r,rp)
	if (re:GetHandler():IsSetCard(0xad2) or re:GetHandler():IsSetCard(0xad3)) and not re:GetHandler():IsCode(98303020) then
		e:GetHandler():AddCounter(0xad1,1)
	end
end
function c98303020.bthop(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetHandler():GetCounter(0xad1)
	if e:GetHandler():IsDisabled() or ac==0 or not Duel.IsExistingMatchingCard(c98303020.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) then
		Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
	else
		Duel.Damage(1-tp,ac*300,REASON_EFFECT)
		Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
	end
end