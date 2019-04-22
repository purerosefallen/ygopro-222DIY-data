--惬意世界
function c26803007.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	c:SetUniqueOnField(1,0,26803007)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTargetRange(0xff,0xff)
	e2:SetValue(LOCATION_DECKSHF)
	c:RegisterEffect(e2)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_SELF_TOGRAVE)
	e4:SetCondition(c26803007.sdcon)
	c:RegisterEffect(e4)
end
function c26803007.sdfilter(c)
	return c:IsFacedown()
end
function c26803007.sdcon(e)
	return Duel.IsExistingMatchingCard(c26803007.sdfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
