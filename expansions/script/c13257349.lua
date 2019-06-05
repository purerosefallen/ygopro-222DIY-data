--姬超时空战斗机-Cirno
function c13257349.initial_effect(c)
	c:EnableCounterPermit(0x351)
	c:EnableReviveLimit()
	--cannot special summon
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e8)
	--special summon
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_SPSUMMON_PROC)
	e9:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_HAND)
	e9:SetCondition(c13257349.spcon)
	e9:SetOperation(c13257349.spop)
	c:RegisterEffect(e9)
	--add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c13257349.accon)
	e1:SetOperation(c13257349.acop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13257349,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c13257349.cost)
	e2:SetOperation(c13257349.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257349,1))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c13257349.cost1)
	e3:SetTarget(c13257349.target1)
	e3:SetOperation(c13257349.operation1)
	c:RegisterEffect(e3)
	--Power Capsule
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c13257349.pccon)
	e4:SetOperation(c13257349.pcop)
	c:RegisterEffect(e4)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetOperation(c13257349.bgmop)
	c:RegisterEffect(e11)
	eflist={"power_capsule",e4}
	c13257349[c]=eflist
	
end
function c13257349.spfilter(c,ft,tp)
	return c:IsSetCard(0x351)
		and c:IsControler(tp) and c:IsAbleToGraveAsCost() and (ft>0 or c:GetSequence()<5)
end
function c13257349.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c13257349.spfilter,tp,LOCATION_MZONE,0,1,nil,ft,tp)
end
function c13257349.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c13257349.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c13257349.accon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(1)>0
end
function c13257349.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,13257349)
	if e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1015,1)
	end
end
function c13257349.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x1015)>0 end
	local ct=e:GetHandler():GetCounter(0x1015)
	e:SetLabel(ct)
	e:GetHandler():RemoveCounter(tp,0x1015,ct,REASON_COST)
end
function c13257349.operation(e,tp,eg,ep,ev,re,r,rp)
	local val=e:GetLabel()
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():RegisterFlagEffect(13257349,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(val)
	e1:SetOperation(c13257349.disop)
	Duel.RegisterEffect(e1,tp)
end
function c13257349.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep~=tp and eg:GetCount()>0 then
		local tc=eg:GetFirst()
		while tc do
			if not tc:IsImmuneToEffect(e) then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local fid=e:GetOwner():GetFieldID()
				tc:RegisterFlagEffect(23257349,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e3)
				end
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e4:SetCode(EVENT_PHASE+PHASE_END)
				e4:SetCountLimit(1)
				e4:SetLabel(fid)
				e4:SetLabelObject(tc)
				e4:SetCondition(c13257349.descon)
				e4:SetOperation(c13257349.desop)
				e4:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e4,tp)
			end
			if e:GetOwner():GetFlagEffect(13257349) then
				local e5=Effect.CreateEffect(c)
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
				e5:SetRange(LOCATION_MZONE)
				e5:SetCode(EFFECT_IMMUNE_EFFECT)
				e5:SetValue(c13257349.efilter)
				e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e:GetOwner():RegisterEffect(e5)
				local e6=Effect.CreateEffect(c)
				e6:SetType(EFFECT_TYPE_SINGLE)
				e6:SetProperty(EFFECT_FLAG_COPY_INHERIT)
				e6:SetCode(EFFECT_UPDATE_ATTACK)
				e6:SetReset(RESET_EVENT+RESETS_STANDARD)
				e6:SetValue(100)
				e:GetOwner():RegisterEffect(e6)

				e:GetOwner():AddCounter(0x351,1)
			end
			tc=eg:GetNext()
		end
	end
end
function c13257349.efilter(e,te)
	return te:GetHandler():GetFlagEffect(23257349)>0
end
function c13257349.desfilter(c,fid)
	return c:GetFlagEffectLabel(23257349)==fid
end
function c13257349.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.GetTurnPlayer()==tp then return false end
	if not c13257349.desfilter(tc,e:GetLabel()) then
		e:Reset()
		return false
	else return true end
end
function c13257349.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	--local tg=g:Filter(c13257349.desfilter,nil,e:GetLabel())
	Duel.Destroy(g,REASON_EFFECT)
end
function c13257349.filter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function c13257349.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x351)>=10 end
	e:GetHandler():RemoveCounter(tp,0x351,10,REASON_COST)
end
function c13257349.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(filter2,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c13257349.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13257349.filter2,tp,0,LOCATION_ONFIELD,nil,e)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(13257349,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			if not tc:IsImmuneToEffect(e) then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local fid=c:GetFieldID()
				tc:RegisterFlagEffect(23257349,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e3)
				end
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e4:SetCode(EVENT_PHASE+PHASE_END)
				e4:SetCountLimit(1)
				e4:SetLabel(fid)
				e4:SetLabelObject(tc)
				e4:SetCondition(c13257349.descon)
				e4:SetOperation(c13257349.desop)
				e4:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e4,tp)
			end
			if e:GetOwner():GetFlagEffect(13257349) then
				local e5=Effect.CreateEffect(c)
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
				e5:SetRange(LOCATION_MZONE)
				e5:SetCode(EFFECT_IMMUNE_EFFECT)
				e5:SetValue(c13257349.efilter)
				e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e:GetOwner():RegisterEffect(e5)
				local e6=Effect.CreateEffect(c)
				e6:SetType(EFFECT_TYPE_SINGLE)
				e6:SetProperty(EFFECT_FLAG_COPY_INHERIT)
				e6:SetCode(EFFECT_UPDATE_ATTACK)
				e6:SetReset(RESET_EVENT+RESETS_STANDARD)
				e6:SetValue(100)
				e:GetOwner():RegisterEffect(e6)
			end
			tc=g:GetNext()
		end
	end
end
function c13257349.pccon(e,tp,eg,ep,ev,re,r,rp)
	return false
end
function c13257349.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x351,5)
	end
end
function c13257349.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257349,7))
end
