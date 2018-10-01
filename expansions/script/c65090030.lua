--星之骑士拟身 毁灭
function c65090030.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090030)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,false,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_PYRO),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK))
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c65090030.cost)
	e1:SetTarget(c65090030.tg)
	e1:SetOperation(c65090030.op)
	c:RegisterEffect(e1)
end
function c65090030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c65090030.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local ct=g:GetCount()
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,ct,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,ct*300)
end
function c65090030.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if g:GetCount()>0 then
		local ct=Duel.SendtoGrave(g,REASON_EFFECT)
		if ct>0 then
			Duel.Damage(1-tp,ct*300,REASON_EFFECT)
		end
	end
end