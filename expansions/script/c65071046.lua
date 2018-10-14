--白夜失乐园
function c65071046.initial_effect(c)
	 c:EnableCounterPermit(0x10da)
	c:SetCounterLimit(0x10da,3)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65071046.addct)
	e1:SetOperation(c65071046.addc)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c65071046.ctop)
	c:RegisterEffect(e2)
	--unaffectable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(c65071046.imcon)
	e3:SetValue(c65071046.efilter)
	c:RegisterEffect(e3)
	--remove counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c65071046.rccon)
	e4:SetOperation(c65071046.rcop)
	c:RegisterEffect(e4)
	--activate cost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(0,1)
	e5:SetCondition(c65071046.costcon)
	e5:SetTarget(c65071046.actarget)
	e5:SetCost(c65071046.costchk)
	e5:SetOperation(c65071046.costop)
	c:RegisterEffect(e5)
	--summon cost
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SUMMON_COST)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(0,LOCATION_HAND)
	e6:SetCondition(c65071046.costcon)
	e6:SetCost(c65071046.costchk)
	e6:SetOperation(c65071046.costop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e7)
	--set cost
	local e8=e6:Clone()
	e8:SetCode(EFFECT_MSET_COST)
	c:RegisterEffect(e8)
	local e9=e6:Clone()
	e9:SetCode(EFFECT_SSET_COST)
	c:RegisterEffect(e9)
	--accumulate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(0x10000000+79323590)
	e0:SetRange(LOCATION_SZONE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(0,1)
	c:RegisterEffect(e0)
end
function c65071046.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x10da)
end
function c65071046.addc(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(1-tp)
	Duel.SetLP(1-tp,lp+8000)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x10da,3)
	end
end
function c65071046.ctfilter(c,tp)
	return c:IsControler(1-tp)
end
function c65071046.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c65071046.ctfilter,1,nil,tp) then
		e:GetHandler():AddCounter(0x10da,1)
	end
end

function c65071046.imcon(e,c)
	return e:GetHandler():GetCounter(0x10da)~=0
end
function c65071046.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function c65071046.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and e:GetHandler():GetCounter(0x10da)~=0
end
function c65071046.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RemoveCounter(tp,0x10da,1,REASON_EFFECT)
	end
end

function c65071046.costcon(e,c)
	return e:GetHandler():GetCounter(0x10da)==0
end
function c65071046.actarget(e,te,tp)
	return te:GetHandler():IsLocation(LOCATION_HAND)
end
function c65071046.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,65071046)
	return (Duel.GetLP(tp)>3000 and Duel.CheckLPCost(tp,ct*math.floor(Duel.GetLP(tp)/2))) or (Duel.GetLP(tp)<=3000 and Duel.CheckLPCost(tp,ct*1000))
end
function c65071046.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65071046)
	if Duel.GetLP(tp)>3000 then Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	else Duel.PayLPCost(tp,1000) end
end
