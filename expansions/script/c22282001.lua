--晶石术士的决意
Duel.LoadScript("c22280001.lua")
c22282001.named_with_Spar=true
function c22282001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22282001,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22282001.target)
	e1:SetOperation(c22282001.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22282001,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c22282001.setcon)
	e2:SetTarget(c22282001.settg)
	e2:SetOperation(c22282001.setop)
	c:RegisterEffect(e2)
end
function c22282001.cfilter(c,e,tp,m,ft)
	if (bit.band(c:GetType(),0x81)==0x81 or scorp.check_set_Zero(c)) and c:IsFaceup() and c:IsReleasableByEffect() then
		local sg=Group.CreateGroup()
		return m:IsExists(c22282001.spselect,1,nil,c,0,ft,m,sg)
	else
		return false
	end
end
function c22282001.spgoal(mc,ct,sg)
	return sg:CheckWithSumEqual(Card.GetLevel,mc:GetLevel(),ct,ct,mc) and sg:GetClassCount(Card.GetCode)==ct
end
function c22282001.spselect(c,mc,ct,ft,m,sg)
	sg:AddCard(c)
	ct=ct+1
	local res=(ft>=ct and c22282001.spgoal(mc,ct,sg)) or m:IsExists(c22282001.spselect,1,sg,mc,ct,ft,m,sg)
	sg:RemoveCard(c)
	return res
end
function c22282001.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and scorp.check_set_Spar(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c22282001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetMZoneCount(tp)
	if ft<=0 then return false end
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local mg=Duel.GetMatchingGroup(c22282001.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if chkc==0 then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c22282001.cfilter(chkc,e,tp,mg,ft) end
	if chk==0 then return Duel.IsExistingTarget(c22282001.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,mg,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c22282001.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,mg,ft)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,g:GetCount(),0,0)
end
function c22282001.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	if ft<=0 then return end
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local mg=Duel.GetMatchingGroup(c22282001.filter,tp,LOCATION_DECK,0,nil,e,tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local sg=Group.CreateGroup()
		for i=0,98 do
			local cg=mg:Filter(c22282001.spselect,sg,tc,i,ft,mg,sg)
			if cg:GetCount()==0 then break end
			local min=1
			if c22282001.spgoal(tc,i,sg) then
				if not Duel.SelectYesNo(tp,210) then break end
				min=0
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=cg:Select(tp,min,1,nil)
			if g:GetCount()==0 then break end
			sg:Merge(g)
		end
		if sg:GetCount()==0 then return end
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)==sg:GetCount() and tc:IsRelateToEffect(e) then
			Duel.Release(tc,REASON_EFFECT)
		end
	end
end
function c22282001.scfilter(c)
	return c:GetSummonType()==SUMMON_TYPE_RITUAL and scorp.check_set_Spar(c)
end
function c22282001.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22282001.scfilter,1,nil)
end
function c22282001.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c22282001.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end