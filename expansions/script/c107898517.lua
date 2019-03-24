--STSP·凌迟
function c107898517.initial_effect(c)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898517,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c107898517.cost)
	e1:SetTarget(c107898517.target)
	e1:SetOperation(c107898517.operation)
	c:RegisterEffect(e1)
end
function c107898517.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x575)
end
function c107898517.filter(c)
	return c:IsCode(107898102) and c:IsFaceup()
end
function c107898517.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()==1
	or Duel.IsCanRemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	and not e:GetHandler():IsPublic() end
	if e:GetHandler():GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	end
end
function c107898517.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c107898517.filter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToRemove(tp) and Duel.IsExistingTarget(c107898517.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c107898517.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c107898517.operation(e,tp,eg,ep,ev,re,r,rp)
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
		--atkdown/damage when sps summon
		local e21=Effect.CreateEffect(c)
		e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e21:SetCode(EVENT_SPSUMMON_SUCCESS)
		e21:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e21:SetRange(LOCATION_MZONE)
		e21:SetCondition(c107898517.adcon1)
		e21:SetTarget(c107898517.adtg)
		e21:SetOperation(c107898517.adop1)
		e21:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e21,true)
		--atkdown/damage when effect
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
		e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(c107898517.adcon2)
		e2:SetTarget(c107898517.adtg)
		e2:SetOperation(c107898517.adop2)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(107898517,0))
	end
end
function c107898517.adcon1(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c107898517.adcon2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetTurnPlayer()==tp
end
function c107898517.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
function c107898517.cfilter(c)
	return c:IsSetCard(0x575a) and c:GetPreviousLocation()==LOCATION_HAND
end
function c107898517.adop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if eg:IsExists(c107898517.cfilter,1,nil) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if Duel.Damage(p,d,REASON_EFFECT)==200 and g:GetCount()>0 then
			local sc=g:GetFirst()
			while sc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				e1:SetValue(-200)
				sc:RegisterEffect(e1)
				if sc:IsAttack(0) then
					Duel.Destroy(sc,REASON_EFFECT)
				end
				sc=g:GetNext()
			end
		end
	end
end
function c107898517.adop2(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if re:IsActiveType(TYPE_MONSTER) and (c:IsSetCard(0x575b) or c:IsSetCard(0x575c)) and c:GetPreviousLocation()==LOCATION_HAND and e:GetHandler():GetFlagEffect(1)>0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if Duel.Damage(p,d,REASON_EFFECT)==200 and g:GetCount()>0 then
			local sc=g:GetFirst()
			while sc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				e1:SetValue(-200)
				sc:RegisterEffect(e1)
				if sc:IsAttack(0) then
					Duel.Destroy(sc,REASON_EFFECT)
				end
				sc=g:GetNext()
			end
		end
	end
end