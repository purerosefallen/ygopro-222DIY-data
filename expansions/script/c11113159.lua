--序列巫女 克洛克
function c11113159.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c11113159.splimit)
	c:RegisterEffect(e1)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c11113159.aclimit1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetOperation(c11113159.aclimit2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetOperation(c11113159.aclimit3)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_NEGATED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c11113159.aclimit4)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetOperation(c11113159.aclimit5)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(1,0)
	e7:SetCondition(c11113159.econ1)
	e7:SetValue(c11113159.elimit1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetTargetRange(0,1)
	e8:SetCondition(c11113159.econ2)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCondition(c11113159.econ3)
	e9:SetValue(c11113159.elimit2)
	c:RegisterEffect(e9)
	local e10=e7:Clone()
	e10:SetTargetRange(0,1)
	e10:SetCondition(c11113159.econ4)
	e10:SetValue(c11113159.elimit2)
	c:RegisterEffect(e10)
	local e11=e7:Clone()
	e11:SetCondition(c11113159.econ5)
	e11:SetValue(c11113159.elimit3)
	c:RegisterEffect(e11)
	local e12=e7:Clone()
	e12:SetTargetRange(0,1)
	e12:SetCondition(c11113159.econ6)
	e12:SetValue(c11113159.elimit3)
	c:RegisterEffect(e12)
end
function c11113159.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c11113159.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)) then return end
	if ep==tp then
	    e:GetHandler():RegisterFlagEffect(11113159,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	else
	    e:GetHandler():RegisterFlagEffect(11113160,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c11113159.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)) then return end
	if ep==tp then
	    e:GetHandler():RegisterFlagEffect(11113161,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	else
	    e:GetHandler():RegisterFlagEffect(11113162,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c11113159.aclimit3(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) then return end
	if ep==tp then
	    e:GetHandler():RegisterFlagEffect(11113163,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	else
	    e:GetHandler():RegisterFlagEffect(11113164,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c11113159.aclimit4(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)) then return end
	if ep==tp then
	    e:GetHandler():ResetFlagEffect(11113159)
	else
	    e:GetHandler():ResetFlagEffect(11113160)
    end	
end
function c11113159.aclimit5(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)) then return end
	if ep==tp then
	    e:GetHandler():ResetFlagEffect(11113161)
	else
	    e:GetHandler():ResetFlagEffect(11113162)
    end	
end
function c11113159.econ1(e)
	return e:GetHandler():GetFlagEffect(11113159)~=0 or e:GetHandler():GetFlagEffect(11113161)~=0
	    or e:GetHandler():GetFlagEffect(11113163)~=0
end
function c11113159.econ2(e)
	return e:GetHandler():GetFlagEffect(11113160)~=0 or e:GetHandler():GetFlagEffect(11113162)~=0
	    or e:GetHandler():GetFlagEffect(11113164)~=0
end
function c11113159.elimit1(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:IsActiveType(TYPE_SPELL)
end
function c11113159.econ3(e)
	return e:GetHandler():GetFlagEffect(11113159)==0 or e:GetHandler():GetFlagEffect(11113161)~=0
end
function c11113159.econ4(e)
	return e:GetHandler():GetFlagEffect(11113160)==0 or e:GetHandler():GetFlagEffect(11113162)~=0
end
function c11113159.elimit2(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:IsActiveType(TYPE_TRAP)
end
function c11113159.econ5(e)
	return e:GetHandler():GetFlagEffect(11113161)==0 or e:GetHandler():GetFlagEffect(11113163)~=0
end
function c11113159.econ6(e)
	return e:GetHandler():GetFlagEffect(11113162)==0 or e:GetHandler():GetFlagEffect(11113164)~=0
end
function c11113159.elimit3(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end