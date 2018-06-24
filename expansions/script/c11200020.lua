--月上的逃兵 铃仙·优昙华院·因幡
function c11200020.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200020,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11200020)
	e1:SetCost(c11200020.cost1)
	e1:SetTarget(c11200020.tg1)
	e1:SetOperation(c11200020.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200020,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c11200020.con2)
	e2:SetTarget(c11200020.tg2)
	e2:SetOperation(c11200020.op2)
	c:RegisterEffect(e2)
--
end
--
function c11200020.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	Duel.ConfirmCards(1-tp,c)
end
--
function c11200020.tfilter1(c,e,tp)
	return c:IsSetCard(0x132) and c:IsType(TYPE_SPELL) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x132,0x21,1100,1100,4,RACE_BEAST,ATTRIBUTE_LIGHT)
end
function c11200020.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c11200020.tfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
--
function c11200020.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc==1 or dc==2 or dc==3 then
		if not c:IsRelateToEffect(e) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	elseif dc==4 or dc==5 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c11200020.tfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if sg:GetCount()<1 then return end
		local sc=sg:GetFirst()
		sc:AddMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_LIGHT,RACE_BEAST,4,1100,1100)
		Duel.SpecialSummonStep(sc,0,tp,tp,true,false,POS_FACEUP)
		sc:AddMonsterAttributeComplete()
		Duel.SpecialSummonComplete()
	elseif dc==6 then
		if c:IsRelateToEffect(e) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c11200020.tfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if sg:GetCount()<1 then return end
			local sc=sg:GetFirst()
			sc:AddMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_LIGHT,RACE_BEAST,4,1100,1100)
			Duel.SpecialSummonStep(sc,0,tp,tp,true,false,POS_FACEUP)
			sc:AddMonsterAttributeComplete()
			Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
			Duel.SpecialSummonComplete()
		else
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c11200020.tfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if sg:GetCount()<1 then return end
			local sc=sg:GetFirst()
			sc:AddMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_LIGHT,RACE_BEAST,4,1100,1100)
			Duel.SpecialSummonStep(sc,0,tp,tp,true,false,POS_FACEUP)
			sc:AddMonsterAttributeComplete()
			Duel.SpecialSummonComplete()
		end
	else
	end
end
--
function c11200020.con2(e,tp,eg,ep,ev,re,r,rp)
	return not re:GetHandler():IsSetCard(0x132)
end
--
function c11200020.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
--
function c11200020.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
end
--
