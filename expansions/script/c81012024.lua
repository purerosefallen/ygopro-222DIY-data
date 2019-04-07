--Stardust et finis
function c81012024.initial_effect(c)
	local e1=aux.AddRitualProcGreater2(c,c81012024.filter,LOCATION_HAND+LOCATION_GRAVE,c81012024.mfilter)
	e1:SetCountLimit(1,81012024+EFFECT_COUNT_CODE_OATH)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81012924)
	e2:SetCondition(c81012024.discon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81012024.distg)
	e2:SetOperation(c81012024.disop)
	c:RegisterEffect(e2)
end
function c81012024.filter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c81012024.mfilter(c)
	return c:IsRace(RACE_PYRO)
end
function c81012024.tgfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_RITUAL)
end
function c81012024.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c81012024.tgfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c81012024.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c81012024.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
