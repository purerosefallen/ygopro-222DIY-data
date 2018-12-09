--Answer·相马夏美
function c81012056.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	--reflect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetTarget(c81012056.reftg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c81012056.reftg(e,c)
	return c:IsType(TYPE_MONSTER)
end