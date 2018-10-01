--星之骑士拟身 涂鸦
function c65090028.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090028)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,false,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c65090028.cost)
	e1:SetOperation(c65090028.op)
	c:RegisterEffect(e1)
end
function c65090028.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c65090028.op(e,tp,eg,ep,ev,re,r,rp)
	--disable
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(c65090028.disable)
	e2:SetCode(EFFECT_DISABLE)
	Duel.RegisterEffect(e2,tp)
end
function c65090028.disable(e,c)
	return c:IsFaceup()
end