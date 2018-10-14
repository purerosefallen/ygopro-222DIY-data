--电灾机祸
function c76121053.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,76121053+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c76121053.tgtg)
	e1:SetOperation(c76121053.tgop)
	c:RegisterEffect(e1)
end
function c76121053.tgfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) and c:IsAbleToGrave()
end
function c76121053.thfilter(c)
	return c:IsSetCard(0xea5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c76121053.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(c76121053.thfilter,tp,LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(c76121053.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c76121053.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c76121053.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0
		and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		local sg=Duel.GetMatchingGroup(c76121053.thfilter,tp,LOCATION_DECK,0,nil)
		if sg:GetClassCount(Card.GetCode)>1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg1=sg:Select(tp,1,1,nil)
			sg:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg2=sg:Select(tp,1,1,nil)
			tg1:Merge(tg2)
			Duel.SendtoHand(tg1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg1)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c76121053.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c76121053.splimit(e,c)
	return not c:IsSetCard(0xea5)
end