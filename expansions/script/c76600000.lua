--死神 京乐春水
function c76600000.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c76600000.spcon)
	c:RegisterEffect(e1)
	--Atk update
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c76600000.atkval)
	c:RegisterEffect(e2)
end
function c76600000.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x766) and c:GetCode()~=76600000
end
function c76600000.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c76600000.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c76600000.atkval(e,c)
	local cont=c:GetControler()
	local atk=Duel.GetLP(cont)-Duel.GetLP(1-cont)
	if atk<0 then atk=0-atk end
	return atk
end