--迫真题海战术
function c81010046.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCountLimit(1,81010046+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81010046.condition1)
	e1:SetCost(c81010046.cost)
	e1:SetTarget(c81010046.target1)
	e1:SetOperation(c81010046.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
	--Activate(effect)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,81010046+EFFECT_COUNT_CODE_OATH)
	e4:SetCondition(c81010046.condition2)
	e4:SetCost(c81010046.cost)
	e4:SetTarget(c81010046.target2)
	e4:SetOperation(c81010046.activate2)
	c:RegisterEffect(e4)	
end
function c81010046.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c81010046.cfilter(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c81010046.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c81010046.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c81010046.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c81010046.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c81010046.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c81010046.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
		and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c81010046.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c81010046.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
