--献祭禁区
function c33351003.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--cannot
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c33351003.limcon)
	e1:SetTarget(c33351003.splimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e2)
end
function c33351003.limfil(c)
	return not c:IsLevelBelow(2) or c:IsFacedown()
end
function c33351003.limcon(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(c33351003.limfil,tp,LOCATION_MZONE,0,nil)==0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
end
function c33351003.splimit(e,c)
	return c:IsLevelAbove(4) and c:IsLocation(LOCATION_HAND+LOCATION_DECK)
end