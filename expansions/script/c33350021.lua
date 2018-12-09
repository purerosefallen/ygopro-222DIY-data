--传说之魂 恐惧
function c33350021.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(33350021)
	aux.AddLinkProcedure(c,c33350021.lfilter,1) 
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33350021,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33350021)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c33350021.sptg)
	e1:SetOperation(c33350021.spop)
	c:RegisterEffect(e1)   
end
c33350021.setname="TaleSouls"
function c33350021.lfilter(c)
	return c.setname=="TaleSouls"
end
function c33350021.filter(c,tp)
	return c:IsFaceup() and c.setname=="TaleSouls" and c:IsAbleToRemove() and Duel.GetMZoneCount(tp,c,tp)>0
end
function c33350021.spfilter(c,e,tp)
	return (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup()) and c.setname=="TaleSouls" and c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33350021.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c33350021.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33350021.filter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsExistingMatchingCard(c33350021.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c33350021.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c33350021.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,tc:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetOperation(c33350021.retop)
		tc:RegisterEffect(e1)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c33350021.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
		if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then 
		   local e4=Effect.CreateEffect(c)
		   e4:SetType(EFFECT_TYPE_SINGLE)
		   e4:SetCode(EFFECT_IMMUNE_EFFECT)
		   e4:SetValue(c33350021.efilter)
		   e4:SetOwnerPlayer(tp)
		   e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		   sc:RegisterEffect(e4)
		   sc:RegisterFlagEffect(33350021,RESET_EVENT+RESETS_STANDARD,0,1)
		   local e2=Effect.CreateEffect(c)
		   e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		   e2:SetCode(EVENT_PHASE+PHASE_END)
		   e2:SetCountLimit(1)
		   e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		   e2:SetLabelObject(sc)
		   e2:SetCondition(c33350021.descon)
		   e2:SetOperation(c33350021.desop)
		   Duel.RegisterEffect(e2,tp)
		end
	end
end
function c33350021.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(33350021)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c33350021.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c33350021.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c33350021.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetHandler())
	e:Reset()
end
