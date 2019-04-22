--终景视界
function c65030052.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c65030052.condition)
	c:RegisterEffect(e0)
	--remove!
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c65030052.apocon)
	e1:SetOperation(c65030052.apoop)
	c:RegisterEffect(e1)
	--zisu
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(c65030052.distg)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e3)
end
function c65030052.distg(e,c)
	return c:IsFaceup() and not c:IsSetCard(0x6da2)
end
function c65030052.cconfil(c)
	return c:IsFaceup() and not c:IsSetCard(0x6da2)
end
function c65030052.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity() and Duel.GetMatchingGroupCount(c65030052.cconfil,tp,LOCATION_ONFIELD,0,e:GetHandler())==0
end
function c65030052.apocon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_END 
end
function c65030052.apoop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0 then
		local rg=Duel.GetOperatedGroup()
		rg:KeepAlive()
		local tc,fid=rg:GetFirst(),e:GetHandler():GetFieldID()
		while tc do
			tc:RegisterFlagEffect(65030052,RESET_EVENT+RESETS_STANDARD,0,0,fid)
			--act limit
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local mp=tc:GetPreviousControler()
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetOperation(c65030052.endop)
			e2:SetLabelObject(tc)
			e2:SetLabel(fid)
			Duel.RegisterEffect(e2,mp)
			tc=rg:GetNext()
		end
	end
end
function c65030052.spfilter(c,e,tp)
	return c:GetFlagEffectLabel(65030052)==e:GetLabel() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65030052.endop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65030052)
	local mc=e:GetLabelObject()
	local mp=mc:GetPreviousControler()
	if c65030052.spfilter(mc,e,mp) and Duel.GetLocationCount(mp,LOCATION_MZONE)>0 and mc:IsLocation(LOCATION_REMOVED) then
		Duel.SpecialSummon(mc,0,mp,mp,false,false,POS_FACEUP)
	end
end