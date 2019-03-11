--冥界归航
function c81010007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c81010007.condition)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c81010007.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
end
function c81010007.disable(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c81010007.cfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function c81010007.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c81010007.cfilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
end