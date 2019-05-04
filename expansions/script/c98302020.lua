--EXEC_PAJA/.
function c98302020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c98302020.actcon)
	e1:SetTarget(c98302020.acttg)
	e1:SetOperation(c98302020.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c98302020.actcon2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c98302020.cost)
	e3:SetCondition(c98302020.actcon3)
	c:RegisterEffect(e3)
end
function c98302020.mzfilter(c,tp)
	return c:IsSetCard(0xad2) and c:IsFaceup() and c:IsControler(tp)
end
function c98302020.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98302020.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and (e:GetHandler():IsLocation(LOCATION_SZONE) or not Duel.IsPlayerAffectedByEffect(tp,98300000))
end
function c98302020.actcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98302020.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,98300000)
end
function c98302020.actcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98302020.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,98300000) and Duel.GetTurnPlayer()~=tp
end
function c98302020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c98302020.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c98302020.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c98302020.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) then return false end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(98302020,1))
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or tc:IsDisabled() then
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
	else
		if tc:IsRelateToEffect(e) and ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) then
			Duel.NegateRelatedChain(tc,RESET_CHAIN)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
				tc:RegisterEffect(e3)
			end
			Duel.BreakEffect()
			Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
		end
	end
end
