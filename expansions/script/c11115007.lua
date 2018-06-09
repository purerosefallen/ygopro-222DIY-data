--御龙的秘技
function c11115007.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11115007+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11115007.target)
	e1:SetOperation(c11115007.operation)
	c:RegisterEffect(e1)
end
function c11115007.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x15e)
end
function c11115007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11115007.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c11115007.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11115007.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
	    tc:RegisterFlagEffect(11115007,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
		tc:RegisterFlagEffect(0,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11115007,0)) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c11115007.efilter)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c11115007.discon)
		e2:SetOperation(c11115007.disop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetLabelObject(tc)
		Duel.RegisterEffect(e2,tp)
		tc=g:GetNext()
	end
end
function c11115007.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwner()~=e:GetOwner()
end
function c11115007.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(11115007)==0 or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(tc) and re:IsActiveType(TYPE_MONSTER)
end
function c11115007.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end