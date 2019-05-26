--纯净魔力召唤术
function c13254130.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13254130,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c13254130.target)
	e1:SetOperation(c13254130.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13254130,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c13254130.condition1)
	e2:SetTarget(c13254130.target1)
	e2:SetOperation(c13254130.activate1)
	c:RegisterEffect(e2)
	
end
function c13254130.spfilter(c,code,e,tp)
	return c:IsSetCard(0x356) and c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13254130.tdfilter(c,e,tp)
	return c:IsAbleToDeck() and Duel.IsExistingMatchingCard(c13254130.spfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode(),e,tp) and c:IsCanBeEffectTarget(e)
end
function c13254130.tdfilter2(c,g)
	return g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function c13254130.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	if chk==0 then
		local g=Duel.GetMatchingGroup(c13254130.tdfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	return g:IsExists(c13254130.tdfilter2,1,nil,g) end
	local g=Duel.GetMatchingGroup(c13254130.tdfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local dg=g:Filter(c13254130.tdfilter2,nil,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg1=dg:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg2=dg:FilterSelect(tp,Card.IsCode,1,1,sg1:GetFirst(),sg1:GetFirst():GetCode())
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c13254130.filter2(c,e)
	return c:IsRelateToEffect(e)
end
function c13254130.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c13254130.filter2,nil,e)
	if g:GetCount()<2 then return end
	local code=g:GetFirst():GetCode()
	if Duel.SendtoDeck(g,tp,2,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c13254130.spfilter,tp,LOCATION_DECK,0,1,1,nil,code,e,tp)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c13254130.cfilter1(c)
	return c:IsCode(13254052) and c:IsFaceup()
end
function c13254130.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c13254130.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c13254130.spfilter1(c,e,tp)
	return c:IsSetCard(0x356) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13254130.filter1(c,e,tp)
	return c:IsAbleToDeck() and c:IsType(TYPE_SPELL)
end
function c13254130.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c13254130.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13254130.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c13254130.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c13254130.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c13254130.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(tc,tp,2,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c13254130.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
