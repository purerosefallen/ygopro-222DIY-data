--镜外的白神 灵源依儿
function c12009101.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12009101,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,0x1e0+TIMING_TOHAND)
	e2:SetCondition(c12009101.spcon)
	e2:SetTarget(c12009101.sptg)
	e2:SetOperation(c12009101.spop)
	c:RegisterEffect(e2)
	--disable field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE_FIELD)
	e4:SetProperty(EFFECT_FLAG_REPEAT)
	e4:SetOperation(c12009101.disop)
	c:RegisterEffect(e4)
	 if c12009101.counter==nil then
		c12009101.counter=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetOperation(c12009101.addcount)
		Duel.RegisterEffect(e1,0)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetOperation(c12009101.addcount2)
		Duel.RegisterEffect(e2,0)
	end 
end
function c12009101.disop(e,tp)
	local c=e:GetHandler()
	return c:GetColumnZone(LOCATION_SZONE)
end
function c12009101.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c12009101.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(Duel.GetTurnPlayer(),12009001)>0 and Duel.GetFlagEffect(Duel.GetTurnPlayer(),12009101)>0
end
function c12009101.addcount2(e,tp,eg,ep,ev,re,r,rp)
	if rp==Duel.GetTurnPlayer() then
	   Duel.RegisterFlagEffect(rp,12009001,RESET_PHASE+PHASE_END,0,1)
	end
end
function c12009101.addcount(e,tp,eg,ep,ev,re,r,rp)
	if rp==Duel.GetTurnPlayer() and eg:IsExists(c12009101.cfilter,1,nil) then
	   Duel.RegisterFlagEffect(rp,12009101,RESET_PHASE+PHASE_END,0,1)
	end
end
function c12009101.cfilter(c)
	return not c:IsReason(REASON_DRAW) 
end
function c12009101.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12009101.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c12009101.efilter)
		c:RegisterEffect(e1)
	end
end
