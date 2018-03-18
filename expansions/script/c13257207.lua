--巨舰护罩充能
function c13257207.initial_effect(c)
	c:SetUniqueOnField(1,0,13257207)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13257207,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c13257207.ctcon)
	e2:SetTarget(c13257207.cttg)
	e2:SetOperation(c13257207.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_REMOVE_COUNTER+0x353)
	e4:SetOperation(c13257207.ctop1)
	c:RegisterEffect(e4)
	
end
function c13257207.ctfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x353) and c:IsControler(tp)
end
function c13257207.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13257207.ctfilter,1,nil,tp)
end
function c13257207.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ec=eg:FilterCount(c13257207.ctfilter,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ec,0,0x353)
	--immune effect
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c13257207.etarget)
	e4:SetValue(c13257207.efilter)
	e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
	Duel.RegisterEffect(e4,tp)
end
function c13257207.etarget(e,c)
	return c:IsSetCard(0x353)
end
function c13257207.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c13257207.ctop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c13257207.ctfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:EnableCounterPermit(0x353)
		tc:AddCounter(0x353,2)
		--Destroy replace
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DESTROY_REPLACE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTarget(c13257207.desreptg)
		e1:SetOperation(c13257207.desrepop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c13257207.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE)
		and e:GetHandler():GetCounter(0x353)>0 end
	return true
end
function c13257207.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x353,1,REASON_EFFECT)
end
function c13257207.ctop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(COUNTER_NEED_ENABLE+0x100e,1)
end
function c13257207.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c13257207.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(13257207,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
