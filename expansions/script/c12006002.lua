--失落王国 基础的珈百璃
function c12006002.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c12006002.spcon)
	c:RegisterEffect(e1)


	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xfbd))
	e3:SetValue(c12006002.atkval)
	c:RegisterEffect(e3)
   
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c12006002.aclimit)
	e3:SetCondition(c12006002.actcon)
	c:RegisterEffect(e3)
end
function c12006002.actfilter(c,tp)
	return c and c:IsFaceup() and c:IsSetCard(0xfbd) and c:IsType(TYPE_MONSTER)
end
function c12006002.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c12006002.actcon(e)
	local tp=e:GetHandlerPlayer()
	return c12006002.actfilter(Duel.GetAttacker(),tp) or c12006002.actfilter(Duel.GetAttackTarget(),tp)
end
function c12006002.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xfbd) and c:GetCode()~=12006002
end
function c12006002.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c12006002.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c12006002.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfbd)
end
function c12006002.atkval(e,c)
	return Duel.GetMatchingGroupCount(c12006002.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*200
end