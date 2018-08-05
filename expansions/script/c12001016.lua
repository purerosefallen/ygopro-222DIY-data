--六曜的先导
function c12001016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12001016,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c12001016.sptg)
	e1:SetOperation(c12001016.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(12008016,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,12008016)
	e2:SetTarget(c12008016.tdtg)
	e2:SetOperation(c12008016.tdop)
	c:RegisterEffect(e2)
end
function c12001016.spfilter(c,e,tp)
	return c:IsSetCard(0xfb0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12001016.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c12001016.spfilter(chkc,e,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c12001016.spfilter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c12001016.spfilter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c12001016.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() or (g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)

end
function c12008016.tdfilter(c,e,tp)
	return c:IsSetCard(0xfb0) and c:IsAbleToDeck()
end
function c12008016.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck()  and Duel.IsExistingMatchingCard(c12008016.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,nil,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,nil)
end
function c12008016.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c12008016.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,e:GetHandler()) then return false end
	if Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1=Duel.SelectMatchingCard(tp,c12008016.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,e:GetHandler())
		local tg=Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
		if tg>1 then
		Duel.Draw(tp,1,REASON_EFFECT)
		end
		if tg>9 then
		Duel.Draw(tp,3,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,2,2,nil)
		Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
		else
		Duel.ShuffleDeck(tp)
		end
	end
end
