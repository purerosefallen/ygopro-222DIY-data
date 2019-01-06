--tricoro·白马零儿
function c81006310.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCountLimit(1)
	e2:SetTarget(c81006310.indtg)
	e2:SetValue(c81006310.indval)
	c:RegisterEffect(e2)
end
function c81006310.indtg(e,c)
	return c:IsType(TYPE_RITUAL) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(TYPE_PENDULUM)
end
function c81006310.indval(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
