--不存于世的能量
function c13254128.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c13254128.thcost)
	e1:SetTarget(c13254128.thtg)
	e1:SetOperation(c13254128.thop)
	c:RegisterEffect(e1)
	--Arcane Copy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c13254128.condition)
	e2:SetTarget(c13254128.target)
	e2:SetOperation(c13254128.activate)
	c:RegisterEffect(e2)
	--Arcane Fusion
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetTarget(c13254128.sptg)
	e3:SetOperation(c13254128.spop)
	c:RegisterEffect(e3)
	
end
function c13254128.thfilter(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c13254128.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254128.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c13254128.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c13254128.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c13254128.cfilter(c)
	return c:IsCode(13254049) or c:IsCode(13254050) or c:IsCode(13254052)
end
function c13254128.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsType(TYPE_SPELL) and Duel.IsExistingMatchingCard(c13254128.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c13254128.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ftg=re:GetTarget()
	if chkc then return ftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk) end
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c13254128.activate(e,tp,eg,ep,ev,re,r,rp)
	local fop=re:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
function c13254128.tgfilter(c)
	return c:IsFaceup() and c:IsCode(13254049) or c:IsCode(13254050) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c13254128.tgfilter1,tp,LOCATION_EXTRA,0,1,nil,c)
end
function c13254128.tgfilter1(c,tc)
	return c:IsCode(13254049) or c:IsCode(13254050) and not c:IsCode(tc:GetCode()) and c:IsAbleToGrave()
end
function c13254128.spfilter(c,e,tp)
	return c:IsRace(13254052) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c13254128.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c13254128.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13254128.tgfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c13254128.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c13254128.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c13254128.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c13254128.tgfilter1,tp,LOCATION_EXTRA,0,nil,tc)
	if tc:IsRelateToEffect(e) and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		sg:AddCard(tc)
		local g1=Duel.GetMatchingGroup(c13254128.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if Duel.SendtoGrave(sg,REASON_EFFECT)>1 and g1:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg1=g1:Select(tp,1,1,nil):GetFirst()
			Duel.BreakEffect()
			Duel.SpecialSummon(sg1,0,tp,tp,true,true,POS_FACEUP)
			sg1:CompleteProcedure()
		end
	end
end
