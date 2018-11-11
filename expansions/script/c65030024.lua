--束缚的二重阴影
function c65030024.initial_effect(c)
	aux.EnableDualAttribute(c)
	--SPSUMMON
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65030024,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c65030024.spcon)
	e1:SetTarget(c65030024.sptg)
	e1:SetOperation(c65030024.spop)
	c:RegisterEffect(e1)
	--effect!
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1)
	e5:SetCondition(aux.IsDualState)
	e5:SetTarget(c65030024.tg)
	e5:SetOperation(c65030024.op)
	c:RegisterEffect(e5)
end
function c65030024.tgfilter(c,tp)
	local cd=c:GetCode()
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and Duel.IsExistingMatchingCard(c65030024.tgfil2,tp,LOCATION_DECK,0,2,nil,cd) 
end
function c65030024.tgfil2(c,code)
	return not c:IsCode(code) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) 
end
function c65030024.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65030024.tgfilter(chkc,tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c65030024.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c65030024.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c65030024.thfilter(c)
	return c:IsSetCard(0xcda1) and c:IsAbleToHand()
end
function c65030024.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	if tc:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(c65030024.tgfil2,tp,LOCATION_DECK,0,2,nil,code) then
		local g=Duel.SelectMatchingCard(tp,c65030024.tgfil2,tp,LOCATION_DECK,0,2,2,nil,code)
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local mg=Duel.GetOperatedGroup()
			if mg:FilterCount(Card.IsType,nil,TYPE_NORMAL)==mg:GetCount() and Duel.IsExistingMatchingCard(c65030024.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(65030024,0)) then
			local sg=Duel.SelectMatchingCard(tp,c65030024.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			elseif mg:FilterCount(Card.IsType,nil,TYPE_NORMAL)~=mg:GetCount() then
				Duel.SendtoDeck(mg,nil,2,REASON_EFFECT)
			end
		end
	end
end
function c65030024.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_EFFECT)==0 
end
function c65030024.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c65030024.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end