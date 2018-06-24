--铃仙·优昙华院·因幡
function c11200019.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200019,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11200019)
	e1:SetCost(c11200019.cost1)
	e1:SetTarget(c11200019.tg1)
	e1:SetOperation(c11200019.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200019,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11200019)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c11200019.cost2)
	e2:SetTarget(c11200019.tg2)
	e2:SetOperation(c11200019.op2)
	c:RegisterEffect(e2)
--
end
--
function c11200019.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	Duel.ConfirmCards(1-tp,c)
end
--
function c11200019.tfilter1(c)
	return (c:IsCode(24094653) 
		or (c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT)))
		and c:IsAbleToHand()
end
function c11200019.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11200019.tfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
--
function c11200019.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc==1 or dc==2 or dc==3 then
		if not c:IsRelateToEffect(e) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	elseif dc==4 or dc==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c11200019.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()<1 then return end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	elseif dc==6 then
		if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c11200019.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()<1 then return end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	else
	end
end
--
function c11200019.sfilter2(c,e,tp)
	return c:IsAbleToDeckAsCost() and c:IsSetCard(0x132) 
		and Duel.IsExistingMatchingCard(c11200019.sfilter2_1,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c11200019.sfilter2_1(c,e,tp)
	return c:IsCode(11200019) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11200019.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c11200019.sfilter2,tp,LOCATION_GRAVE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,c11200019.sfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
--
function c11200019.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11200019.sfilter2_1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
--
function c11200019.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c11200019.sfilter2_1,tp,LOCATION_GRAVE,0,nil,e,tp)
	if ft<=0 or tg:GetCount()<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=tg:Select(tp,ft,ft,nil)
	local tc=sg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e2_2=Effect.CreateEffect(c)
		e2_2:SetType(EFFECT_TYPE_SINGLE)
		e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2_2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e2_2:SetValue(1)
		e2_2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_2)
		local e2_3=Effect.CreateEffect(c)
		e2_3:SetType(EFFECT_TYPE_SINGLE)
		e2_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2_3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e2_3:SetValue(1)
		e2_3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_3)
		local e2_4=Effect.CreateEffect(c)
		e2_4:SetType(EFFECT_TYPE_SINGLE)
		e2_4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2_4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e2_4:SetValue(1)
		e2_4:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_4)
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
--
