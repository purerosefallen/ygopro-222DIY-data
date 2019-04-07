--德川茉莉
function c26804000.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26804000)
	e1:SetCondition(c26804000.spcon)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c26804000.dircon)
	c:RegisterEffect(e2)
end
function c26804000.filter(c)
	return c:IsFaceup() and c:IsAttackAbove(2000)
end
function c26804000.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(c26804000.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c26804000.cfilter(c)
	return c:GetAttack()<2000 or c:IsFacedown()
end
function c26804000.dircon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(c26804000.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
