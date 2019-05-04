--卡贝拉·迪特拉
function c47530045.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c47530045.psplimit)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,47530045+EFFECT_COUNT_CODE_OATH)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c47530045.condition)
	e1:SetTarget(c47530045.sptg)
	e1:SetOperation(c47530045.spop)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,47530046)
	e2:SetCondition(c47530045.pencon)
	e2:SetTarget(c47530045.pentg)
	e2:SetOperation(c47530045.penop)
	c:RegisterEffect(e2)  
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c47530045.effcon)
	e3:SetOperation(c47530045.effop)
	c:RegisterEffect(e3) 
end
function c47530045.psplimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_MACHINE)
end
function c47530045.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	return eg:GetCount()==1 and c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_LINK) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c47530045.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsRace(RACE_MACHINE)
end
function c47530045.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c47530045.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47530045.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local tc=eg:GetFirst()
		if c:IsRelateToEffect(e) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			if Duel.MoveSequence(tc,nseq)~=0 then
				local zone=tc:GetLinkedZone(tp)
				if zone==0 then return end
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
			end
		end
	end
end
function c47530045.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsPreviousLocation(LOCATION_DECK)
end
function c47530045.tpfilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function c47530045.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c47530045.tpfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.CheckLocation(tp,LOCATION_PZONE,0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c47530045.penop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c47530045.tpfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g) 
		end
	end
end
function c47530045.effcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetReasonCard()
	return r==REASON_XYZ and c:IsRace(RACE_MACHINE)
end
function c47530045.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(47530045,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c47530045.mdtg)
	e1:SetOperation(c47530045.mdop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c47530045.mdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,1,1,0,0)
end
function c47530045.desfilter(c,g)
	return g:IsContains(c) and c:GetSequence()<5
end
function c47530045.mdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=4-c:GetSequence()
	local cg=c:GetColumnGroup()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c47530045.desfilter,tp,0,LOCATION_MZONE,nil,cg)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end