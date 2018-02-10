--娑羯罗
function c1150012.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1150012,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,1150012)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c1150012.con2)
	e2:SetTarget(c1150012.tg2)
	e2:SetOperation(c1150012.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1150012,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c1150012.con3)
	e3:SetTarget(c1150012.tg3)
	e3:SetOperation(c1150012.op3)
	c:RegisterEffect(e3)
--
end
--
function c1150012.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<1
end
--
function c1150012.tfilter2(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()<4
end
function c1150012.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1150012.tfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
--
function c1150012.ofilter2(c,e,tp,m)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=nil
	if c.mat_filter then
		mg=m:Filter(c.mat_filter,c)
	else
		mg=m:Clone()
		mg:RemoveCard(c)
	end
	return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c1150012.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c1150012.tfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			local mg=Group.CreateGroup()
			mg:AddCard(tc)
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsLocation(LOCATION_MZONE) and Duel.GetRitualMaterial(tp):IsContains(tc) and Duel.IsExistingMatchingCard(c1150012.ofilter2,tp,LOCATION_DECK,0,1,nil,e,tp,mg) and Duel.SelectYesNo(tp,aux.Stringid(1150012,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=Duel.SelectMatchingCard(tp,c1150012.ofilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,mg)
				if sg:GetCount()>0 then
					local sc=sg:GetFirst()
					sg:RemoveCard(sc)
					if sc.mat_filter then
						sg=sg:Filter(sc.mat_filter,nil)
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,sc:GetLevel(),1,99,sc)
					sc:SetMaterial(mat)
					Duel.ReleaseRitualMaterial(mat)
					Duel.BreakEffect()
					Duel.SpecialSummonStep(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					local e1_1=Effect.CreateEffect(e:GetHandler())
					e1_1:SetType(EFFECT_TYPE_SINGLE)
					e1_1:SetCode(EFFECT_DISABLE)
					e1_1:SetReset(RESET_EVENT+0x1fe0000)
					sc:RegisterEffect(e1_1,true)
					local e1_2=Effect.CreateEffect(e:GetHandler())
					e1_2:SetType(EFFECT_TYPE_SINGLE)
					e1_2:SetCode(EFFECT_DISABLE_EFFECT)
					e1_2:SetReset(RESET_EVENT+0x1fe0000)
					sc:RegisterEffect(e1_2,true)
					Duel.SpecialSummonComplete()
					sc:CompleteProcedure()
				end
			end
		end
	end
end
--
function c1150012.con3(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsType(TYPE_RITUAL)
end
--
function c1150012.tfilter3(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c1150012.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1150012.tfilter3,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,1,nil) and c:IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_HAND+LOCATION_MZONE)
end
--
function c1150012.op3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1150012.tfilter3,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then 
			Duel.ConfirmCards(1-tp,tc) 
		end
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
			local p=tc:GetOwner()
			if Duel.IsPlayerCanDraw(p,1) and Duel.SelectYesNo(tp,aux.Stringid(1150012,3)) then
				Duel.Draw(p,1,REASON_EFFECT)
			end
		end
	end
end
--
