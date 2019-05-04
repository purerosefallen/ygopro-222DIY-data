--EXEC_CHRONICLE_KEY/.
function c98302010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c98302010.actcon)
	e1:SetOperation(c98302010.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER)
	e2:SetCondition(c98302010.actcon2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER)
	e3:SetCost(c98302010.cost)
	e3:SetCondition(c98302010.actcon3)
	c:RegisterEffect(e3)
end
function c98302010.mzfilter(c,tp)
	return c:IsSetCard(0xad2) and c:IsFaceup() and c:IsControler(tp)
end
function c98302010.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98302010.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and (e:GetHandler():IsLocation(LOCATION_SZONE) or not Duel.IsPlayerAffectedByEffect(tp,98300000))
end
function c98302010.actcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98302010.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,98300000)
end
function c98302010.actcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98302010.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,98300000) and Duel.GetTurnPlayer()~=tp
end
function c98302010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c98302010.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c98302010.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) then return false end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(98302010,1))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c98302010.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c98302010.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_HAND)
end
