--镜外的白神 灵源依儿
function c12009100.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12009100,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,0x1e0+TIMING_TOHAND)
	e2:SetCondition(c12009100.spcon)
	e2:SetTarget(c12009100.sptg)
	e2:SetOperation(c12009100.spop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c12009100.rmop)
	c:RegisterEffect(e3)
	if c12009100.counter==nil then
		c12009100.counter=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetOperation(c12009100.addcount)
		Duel.RegisterEffect(e1,0)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetOperation(c12009100.addcount2)
		Duel.RegisterEffect(e2,0)
	end 
end
function c12009100.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--local g1=Duel.GetMatchingGroup(Card.IsFacedown,Duel.GetTurnPlayer(),LOCATION_ONFIELD,0,nil)
	local g1=Duel.GetMatchingGroup(nil,Duel.GetTurnPlayer(),LOCATION_HAND,0,nil)
	--g1:Merge(g2)
	if Duel.Remove(g1,POS_FACEDOWN,REASON_EFFECT)<=0 then return end
	local og=Duel.GetOperatedGroup()
	local oc=og:GetFirst()
	while oc do
		  oc:RegisterFlagEffect(12009100,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
		oc=og:GetNext()
	end
	og:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetCountLimit(1)
	e1:SetLabelObject(og)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c12009100.retcon)
	e1:SetOperation(c12009100.retop)
	Duel.RegisterEffect(e1,tp)
end
function c12009100.retfilter(c)
	return c:GetFlagEffect(12009100)~=0
end
function c12009100.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c12009100.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c12009100.retfilter,nil)
	if sg:GetCount()<=0 then return end
	local thg=sg:Filter(Card.IsPreviousLocation,nil,LOCATION_HAND)
	if thg:GetCount()>0 then
	   Duel.SendtoHand(thg,nil,REASON_EFFECT)
	   sg:Sub(thg)
	end
	local tc=sg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=sg:GetNext()
	end
end
function c12009100.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12009100.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c12009100.efilter)
		c:RegisterEffect(e1)
	end
end
function c12009100.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c12009100.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(Duel.GetTurnPlayer(),12009101)>0 and Duel.GetFlagEffect(Duel.GetTurnPlayer(),12009100)>0
end
function c12009100.addcount2(e,tp,eg,ep,ev,re,r,rp)
	if rp==Duel.GetTurnPlayer() then
	   Duel.RegisterFlagEffect(rp,12009101,RESET_PHASE+PHASE_END,0,1)
	end
end
function c12009100.addcount(e,tp,eg,ep,ev,re,r,rp)
	if rp==Duel.GetTurnPlayer() and eg:IsExists(c12009100.cfilter,1,nil) then
	   Duel.RegisterFlagEffect(rp,12009100,RESET_PHASE+PHASE_END,0,1)
	end
end
function c12009100.cfilter(c)
	return not c:IsReason(REASON_DRAW) 
end

