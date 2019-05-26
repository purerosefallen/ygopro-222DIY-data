--神奈神威 康娜
function c81011202.initial_effect(c)
	c:EnableCounterPermit(0x810)
	--summon with s/t
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e0:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FIELD))
	e0:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e0)
	--cannot trigger
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e1:SetTarget(c81011202.distg)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c81011202.cttg)
	e2:SetOperation(c81011202.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c81011202.atkval)
	c:RegisterEffect(e4)
	--cannot attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetCondition(c81011202.atcon)
	c:RegisterEffect(e5)
	--counter
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(81011202,2))
	e6:SetCategory(CATEGORY_COUNTER)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c81011202.ctop2)
	c:RegisterEffect(e6)
	--counter
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(81011202,1))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c81011202.ctcon1)
	e7:SetOperation(c81011202.ctop1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
function c81011202.distg(e,c)
	return c:IsFacedown()
end
function c81011202.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x810)
end
function c81011202.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x810,2)
	end
end
function c81011202.atkval(e,c)
	return e:GetHandler():GetCounter(0x810)*200
end
function c81011202.atcon(e)
	return e:GetHandler():GetCounter(0x810)==0
end
function c81011202.ctfilter(c,tp)
	return c:IsFaceup() and (c:IsRace(RACE_DRAGON) or c:IsCode(81014005))
end
function c81011202.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81011202.ctfilter,1,nil,tp)
end
function c81011202.ctop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x810,1)
	end
end
function c81011202.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RemoveCounter(tp,0x810,1,REASON_EFFECT)
	end
end
