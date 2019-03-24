function c81010016.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c81010016.negcon)
	e1:SetTarget(c81010016.negtg)
	e1:SetOperation(c81010016.negop)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c81010016.handcon)
	c:RegisterEffect(e2)
end
function c81010016.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and aux.damcon1(e,tp,eg,ep,ev,re,r,rp)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c81010016.filter(c)
	return c:IsFaceup() or c:IsFacedown()
end
function c81010016.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rec=Duel.GetMatchingGroupCount(c81010016.filter,tp,0,LOCATION_SZONE,nil)*500
	if chk==0 then return rec>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c81010016.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		local rec=Duel.GetMatchingGroupCount(c81010016.filter,tp,0,LOCATION_SZONE,nil)*500
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Recover(p,rec,REASON_EFFECT)
	end
end
function c81010016.handcon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_FZONE,1,nil)
end
