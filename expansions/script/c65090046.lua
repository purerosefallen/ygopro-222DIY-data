--星之骑士拟身 厨师
function c65090046.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090046)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,false,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE))
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c65090046.cost)
	e1:SetTarget(c65090046.tg)
	e1:SetOperation(c65090046.op)
	c:RegisterEffect(e1)
end
function c65090046.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c65090046.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,e:GetHandler())
	local ct=g:GetCount()
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,ct,1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,ct*2000)
end
function c65090046.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,e:GetHandler())
	if g:GetCount()>0 then
		local ct=Duel.SendtoGrave(g,REASON_EFFECT)
		if ct>0 then
			Duel.Recover(tp,ct*2000,REASON_EFFECT)
		end
	end
end