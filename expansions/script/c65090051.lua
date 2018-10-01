--星之骑士拟身 光
function c65090051.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090051)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65090001,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),1,true,true)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c65090051.cost)
	e1:SetTarget(c65090051.tg)
	e1:SetOperation(c65090051.op)
	c:RegisterEffect(e1)
end
function c65090051.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c65090051.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function c65090051.fil(c)
	return not c:IsType(TYPE_CONTINUOUS) and not c:IsType(TYPE_FIELD)
end
function c65090051.op(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.ChangePosition(g1,0x1,0x1,0x4,0x4,true)
	Duel.ChangePosition(g2,POS_FACEUP)
	local g3=g2:Filter(c65090051.fil,nil)
	if g3:GetCount()>0 then
		Duel.SendtoGrave(g3,REASON_EFFECT)
	end
end