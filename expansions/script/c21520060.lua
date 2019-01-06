--灵子殖装，因果轮回
function c21520060.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetDescription(aux.Stringid(21520060,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,21520060+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c21520060.condition)
	e1:SetCost(c21520060.cost)
	e1:SetTarget(c21520060.target)
	e1:SetOperation(c21520060.activate)
--	e1:SetValue(c21520060.valcheck)
	c:RegisterEffect(e1)
end
function c21520060.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c21520060.cfilter(c)
	return c:IsSetCard(0x494) and c:IsReleasable() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c21520060.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520060.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c21520060.cfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c21520060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c21520060.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
--	if re:GetHandler():IsRelateToEffect(re) then -- and re:GetHandler():IsAbleToDeck()
		Duel.BreakEffect()
		re:GetHandler():CancelToGrave()
		Duel.SendtoDeck(re:GetHandler(),nil,2,REASON_EFFECT)
--	end
end
function c21520060.valcheck(e)
	Duel.SetChainLimit(aux.FALSE)
end
