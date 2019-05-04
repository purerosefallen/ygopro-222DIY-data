--EXEC_SUSPEND/.
function c98302030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c98302030.actcon)
	e1:SetTarget(c98302030.acttg)
	e1:SetOperation(c98302030.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c98302030.actcon2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c98302030.cost)
	e3:SetCondition(c98302030.actcon3)
	c:RegisterEffect(e3)
end
function c98302030.mzfilter(c,tp)
	return c:IsSetCard(0xad2) and c:IsFaceup() and c:IsControler(tp)
end
function c98302030.thfilter(c,tp)
	return c:IsControler(tp) and c:IsAbleToHand() and c:IsSetCard(0xad2)
end
function c98302030.tdfilter(c,tp)
	return c:IsControler(1-tp) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c98302030.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98302030.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and (e:GetHandler():IsLocation(LOCATION_SZONE) or not Duel.IsPlayerAffectedByEffect(tp,98300000))
end
function c98302030.actcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98302030.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,98300000)
end
function c98302030.actcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98302030.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,98300000) and Duel.GetTurnPlayer()~=tp
end
function c98302030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c98302030.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c98302030.tdfilter,tp,0,LOCATION_MZONE,1,nil,tp) and Duel.IsExistingMatchingCard(c98302030.thfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c98302030.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c98302030.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) then return false end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(98302030,2))
	if Duel.IsExistingMatchingCard(c98302030.tdfilter,tp,0,LOCATION_MZONE,1,nil,tp) and Duel.IsExistingMatchingCard(c98302030.thfilter,tp,LOCATION_MZONE,0,1,nil,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98302030,1))
		local thm=Duel.SelectMatchingCard(tp,c98302030.thfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tdm=Duel.SelectMatchingCard(tp,c98302030.tdfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
		if thm and tdm then
			Duel.SendtoHand(thm,nil,REASON_EFFECT)
			Duel.SendtoDeck(tdm,nil,2,REASON_EFFECT)
		end
	end
end
