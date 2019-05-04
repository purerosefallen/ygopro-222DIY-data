--杰钢（巴纳姆所属机）
function c47530040.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,47530040)
	e1:SetCondition(c47530040.rtcon)
	e1:SetTarget(c47530040.rttg)
	e1:SetOperation(c47530040.rtop)
	c:RegisterEffect(e1)   
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47530040,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,47530041)
	e2:SetCondition(c47530040.spcon)
	e2:SetTarget(c47530040.sptg)
	e2:SetOperation(c47530040.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(47530040,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCountLimit(1,47530041)
	e4:SetCondition(c47530040.tgcon)
	e4:SetTarget(c47530040.tgtg)
	e4:SetOperation(c47530040.tgop)
	c:RegisterEffect(e4)
end
function c47530040.cfilter(c)
	return c:IsRace(RACE_MACHINE)
end
function c47530040.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c47530040.cfilter,1,e:GetHandler(),tp)
end
function c47530040.lfilter(c)
	return c:IsType(TYPE_LINK) and c:IsRace(RACE_MACHINE)
end
function c47530040.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=Duel.GetLinkedZone(tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c47530040.lfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and zone~=0 end
	local g=Duel.SelectTarget(tp,c47530040.lfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,1,1,0,0)
end
function c47530040.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local zone=bit.band(tc:GetLinkedZone(tp),0x1f)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,zone)
	if not tc:IsRelateToEffect(e) then return end
	local g=eg:Filter(c47530040.cfilter,nil,e,tp)
	local sg=g:Select(tp,ct,ct,nil)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,zone)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c47530040.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp) 
end
function c47530040.splimit(e,c)
	return not c:IsRace(RACE_MACHINE)
end
function c47530040.cfilter2(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsLevel(10) and c:GetSummonPlayer()==tp
end
function c47530040.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c47530040.cfilter2,1,nil,tp)
end
function c47530040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47530040.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c47530040.cfilter3(c,zone)
	return c:IsRace(RACE_MACHINE) and c:IsLevel(10)
end
function c47530040.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(0)
	return eg:IsExists(c47530040.cfilter3,1,nil,zone)
end
function c47530040.tgfilter(c,e,sp)
	return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c47530040.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c47530040.tgfilter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_PZONE)
end
function c47530040.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c47530040.filter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end