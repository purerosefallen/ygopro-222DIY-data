--星之骑士协力牵手
function c65090058.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65090058)
	e1:SetTarget(c65090058.target)
	e1:SetOperation(c65090058.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65090058.sptg)
	e2:SetOperation(c65090058.spop)
	c:RegisterEffect(e2)
end
function c65090058.spfilter(c,e,tp)
	return c:IsCode(65090001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65090058.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c65090058.spfilter(chkc,e,tp) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c65090058.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c65090058.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c65090058.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c65090058.filter(c)
	return c:IsSetCard(0x6da6) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65090058.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65090058.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_MONSTER)>0 then
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_MONSTER)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),tp,0)
	end
end
function c65090058.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65090058.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_MONSTER)>0 then
				Duel.BreakEffect()
				local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_MONSTER)
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			end
		end
	end
end