--御龙骑 风龙
function c11115013.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11115013)
	e1:SetCondition(c11115013.spcon)
	c:RegisterEffect(e1)
	--material limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetValue(c11115013.linklimit)
	c:RegisterEffect(e2)
end
function c11115013.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x115e) and c:IsType(TYPE_TUNER)
end
function c11115013.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x215e) and not c:IsType(TYPE_SYNCHRO)
end
function c11115013.spcon(e,c)
	if c==nil then return true end
	local ct1=Duel.GetMatchingGroupCount(c11115013.filter,c:GetControler(),LOCATION_MZONE,0,nil)
	local ct2=Duel.GetMatchingGroupCount(c11115013.cfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and ct1>0 and (ct2==0 or ct1>ct2)
end
function c11115013.linklimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x15e)
end