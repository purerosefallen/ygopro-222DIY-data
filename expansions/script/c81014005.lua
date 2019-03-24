--OL程序员 小林
function c81014005.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_DRAGON),2,2)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81014005,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetCondition(c81014005.sumcon)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DRAGON))
	c:RegisterEffect(e1)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c81014005.efcon)
	e3:SetValue(c81014005.atkval)
	c:RegisterEffect(e3)
	--must be attacked
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetCondition(c81014005.efcon)
	e5:SetValue(c81014005.atklimit)
	c:RegisterEffect(e5)
end
function c81014005.sumcon(e)
	local tc=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	if tc and tc:IsFaceup() then return true end
	tc=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return tc and tc:IsFaceup()
end
function c81014005.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c81014005.efcon(e)
	return Duel.IsExistingMatchingCard(c81014005.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c81014005.atkval(e,c)
	return Duel.GetMatchingGroupCount(nil,c:GetControler(),LOCATION_FZONE,LOCATION_FZONE,nil)*1000
end
function c81014005.atklimit(e,c)
	return c:IsCode(81014005)
end
