--魔术转换
function c33334568.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33334568)
	e1:SetTarget(c33334568.target)
	e1:SetOperation(c33334568.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,33334569)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c33334568.tg)
	e2:SetOperation(c33334568.op)
	c:RegisterEffect(e2)
end
function c33334568.thfil(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c33334568.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33334568.thfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c33334568.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c33334568.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end
function c33334568.filter(c,e,tp,mg)
	if bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or not c:IsSetCard(0x3552) then return false end
	return mg:GetCount()>=c:GetLevel()
end
function c33334568.matfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function c33334568.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(c33334568.matfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
		return Duel.IsExistingMatchingCard(c33334568.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c33334568.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c33334568.matfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c33334568.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		local num=tc:GetLevel()
		local tgg=mg:FilterSelect(tp,aux.TRUE,num,num,nil)
		local tgc=tgg:GetFirst()
		while tgc do
			Duel.SendtoGrave(tgc,REASON_EFFECT)
			tgc:RegisterFlagEffect(33334568,RESET_EVENT+RESETS_STANDARD,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCondition(c33334568.aclicon)
			e1:SetTarget(c33334568.sumlimit)
			e1:SetLabel(tgc:GetCode())
			e1:SetValue(c33334568.aclimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e2:SetCountLimit(1)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetLabelObject(tgc)
			e2:SetCondition(c33334568.descon)
			e2:SetOperation(c33334568.desop)
			Duel.RegisterEffect(e2,tp)
			tgc=tgg:GetNext()
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c33334568.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function c33334568.aclicon(c,e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c33334568.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) 
end
function c33334568.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(33334568)~=0 and Duel.GetTurnPlayer()~=tp then
		return true
	else
		e:Reset()
		return false
	end
end
function c33334568.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end