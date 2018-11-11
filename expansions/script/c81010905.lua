--Answer·间中美里
function c81010905.initial_effect(c)
	c:EnableReviveLimit()
	--link summon
	aux.AddLinkProcedure(c,nil,2,2)
	--damage conversion
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_REVERSE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(c81010905.rev)
	c:RegisterEffect(e2)
end
function c81010905.rev(e,re,r,rp,rc)
	return bit.band(r,REASON_EFFECT)>0
end