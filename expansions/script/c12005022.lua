--小小的捉弄
function c12005022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_TOGRAVE+CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c12005022.condition)
	e1:SetTarget(c12005022.target)
	e1:SetOperation(c12005022.activate)
	c:RegisterEffect(e1)
	--asdasdasd
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12005022,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c12005022.tdtg)
	e2:SetOperation(c12005022.tdop)
	c:RegisterEffect(e2)
end
function c12005022.spfilter(c,e,tp)
	return c:IsSetCard(0xfbb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12005022.cfilter(c)
	return c:IsType(TYPE_COUNTER) and c:IsAbleToDeck()
end
function c12005022.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c12005022.cfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c12005022.cfilter,tp,LOCATION_GRAVE,0,2,c) and c:IsAbleToDeck() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c12005022.cfilter,tp,LOCATION_GRAVE,0,2,2,c)
	local rg=g:Clone()
	rg:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,rg,rg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c12005022.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsAbleToDeck() or not c:IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	sg:AddCard(c)
	 if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)>1 then
		local og=Duel.GetOperatedGroup()
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		   Duel.ShuffleDeck(tp)
		end
		Duel.Draw(tp,1,REASON_EFFECT)
	 end
end
function c12005022.condition(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasCategory(CATEGORY_DRAW+CATEGORY_TOHAND) then return Duel.IsPlayerCanDraw(tp,1) end
	if re:IsHasCategory(CATEGORY_DISABLE+CATEGORY_NEGATE+CATEGORY_DISABLE_SUMMON) then return Duel.IsChainNegatable(ev) end
	return true
end
function c12005022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
	local ex=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	if re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	end
	if re:IsHasCategory(CATEGORY_DRAW+CATEGORY_TOHAND) then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	if re:IsHasCategory(CATEGORY_DESTROY+CATEGORY_REMOVE) or ex then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD)
	end
	if re:IsHasCategory(CATEGORY_DISABLE+CATEGORY_NEGATE+CATEGORY_DISABLE_SUMMON) then
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	end
end
function c12005022.activate(e,tp,eg,ep,ev,re,r,rp)
	local c,rc=e:GetHandler(),re:GetHandler()
	if Duel.Damage(1-tp,100,REASON_EFFECT)<=0 then return end
	local b1=c:IsAbleToDeck() and Duel.IsExistingMatchingCard(c12005022.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
	local b2=re:IsHasCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	local b3=(re:IsHasCategory(CATEGORY_DESTROY+CATEGORY_REMOVE) or ex) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b4=re:IsHasCategory(CATEGORY_DISABLE+CATEGORY_NEGATE+CATEGORY_DISABLE_SUMMON)
	if not (b1 or b2 or b3 or b4) then return end
	Duel.BreakEffect()
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(12005022,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c12005022.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if Duel.SpecialSummon(sg,0,tp,tp,false,false)~=0 and c:IsRelateToEffect(e) then
			c:CancelToGrave(true)
			Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
		end
	end
	if b2 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if b3 and Duel.SelectYesNo(tp,aux.Stringid(12005022,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(tg)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
	if b4 then
		Duel.NegateActivation(ev) 
	end
end