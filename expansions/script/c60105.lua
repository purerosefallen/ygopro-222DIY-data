--腊雪的洋伞-小寒
function c60105.initial_effect(c)
	--umb
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60105,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,60105)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c60105.condition)
	e1:SetCost(c60105.cost)
	e1:SetTarget(c60105.target)
	e1:SetOperation(c60105.negop)
	c:RegisterEffect(e1)
	--
end
c60105.DescSetName = 0x229
function c60105.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	local ex=Duel.GetOperationInfo(ev,CATEGORY_NEGATE)
	return ex
end
function c60105.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c60105.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c60105.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re)then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
