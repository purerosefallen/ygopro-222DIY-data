--苏生的梦魇 阿尼拉
function c75646500.initial_effect(c)
	c:EnableCounterPermit(0x42)
	c:SetCounterLimit(0x42,4)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_DARK),3,4,c75646500.lcheck)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c75646500.efilter)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c75646500.indval)
	c:RegisterEffect(e2)
	--Add counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c75646500.ctcon)
	e3:SetTarget(c75646500.cttg)
	e3:SetOperation(c75646500.ctop)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c75646500.con1)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--cannot attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetCondition(c75646500.con2)
	c:RegisterEffect(e5)
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetCondition(c75646500.con3)
	e6:SetValue(c75646500.efilter1)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,1)
	e7:SetCondition(c75646500.con4)
	e7:SetValue(c75646500.actlimit)
	c:RegisterEffect(e7)
	--disable summon
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetCondition(c75646500.con4)
	e8:SetTargetRange(0,1)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e9)
end
function c75646500.lcheck(g,lc)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c75646500.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and not te:GetOwner():IsAttribute(ATTRIBUTE_DARK)
end
function c75646500.indval(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c75646500.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():GetCounter(0x42)~=4
end
function c75646500.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x42)
end
function c75646500.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		c:AddCounter(0x42,1)
	end
end
function c75646500.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x42)>=1
end
function c75646500.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x42)>=2
end
function c75646500.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x42)>=3
end
function c75646500.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x42)==4
end
function c75646500.efilter1(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c75646500.actlimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end