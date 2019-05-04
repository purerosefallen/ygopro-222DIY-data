--罗生门研究艇
function c47594147.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)	
	--cos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47594147,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,47594147)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(c47594147.sptg)
	e1:SetOperation(c47594147.spop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47594147,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,47594148)
	e2:SetCondition(c47594147.atkcon)
	e2:SetTarget(c47594147.atktg)
	e2:SetOperation(c47594147.atkop)
	c:RegisterEffect(e2)
end
function c47594147.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE) and Duel.IsExistingMatchingCard(c47594147.filter2,tp,LOCATION_DECK,0,1,nil,c)
end
function c47594147.filter2(c,mc)
	return not c:IsRace(RACE_MACHINE) and aux.IsCodeListed(mc,c:GetCode())
end
function c47594147.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:IsLevel(7) and c:IsAttack(2400) and c:IsDefense(2400) and c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c47594147.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47594147.spfilter,tp,LOCATION_EXTRA,0,1,nil,tp) and Duel.IsExistingMatchingCard(c47594147.tgfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c47594147.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	local tc=g:GetFirst()
	Duel.SetTargetCard(tc)
	Duel.ConfirmCards(1-tp,g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND)
end
function c47594147.spfilter2(c,e,tp,mc)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsRace(RACE_MACHINE) and aux.IsCodeListed(mc,c:GetCode())
end
function c47594147.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c47594147.spfilter2),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,tc)
	local tc2=g:Select(tp,1,1,nil):GetFirst()
	if tc2 and Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c47594147.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c47594147.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c47594147.cfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ)
end
function c47594147.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c47594147.cfilter,1,nil,tp)
end
function c47594147.tgfilter1(c,tp,eg)
	return eg:IsContains(c)
end
function c47594147.eqfilter(c)
	return c:GetType()==TYPE_TRAP and not c:IsForbidden()
end
function c47594147.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c47594147.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c47594147.tgfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,eg)
end
function c47594147.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47594147.eqfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	local tc2=g:GetFirst()
	if tc2 then
		Duel.Equip(tp,tc2,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c47594147.eqlimit)
		tc2:RegisterEffect(e1,true)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c47594147.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c47594147.eqlimit(e,c)
	return c:GetControler()==e:GetOwnerPlayer() and c:IsType(TYPE_XYZ)
end
function c47594147.splimit(e,c)
	return not c:IsRace(RACE_MACHINE) and c:IsLocation(LOCATION_EXTRA)
end