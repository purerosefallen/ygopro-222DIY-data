--飞球之天界
function c13254066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13254066,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c13254066.tdcon)
	e2:SetTarget(c13254066.tdtg)
	e2:SetOperation(c13254066.tdop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13254066,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_FZONE)
	e3:SetCondition(c13254066.tdcon)
	e3:SetTarget(c13254066.tdtg)
	e3:SetOperation(c13254066.tdop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13254066,2))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_DECK)
	e2:SetRange(LOCATION_FZONE)
	e4:SetCondition(c13254066.tdcon1)
	e4:SetTarget(c13254066.tdtg1)
	e4:SetOperation(c13254066.tdop1)
	c:RegisterEffect(e4)
	
end
function c13254066.tdfilter(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsAbleToDeck()
end
function c13254066.tdfilter1(c,e)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsRelateToEffect(e)
end
function c13254066.tgfilter(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c13254066.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetReasonCard()~=e:GetHandler() and eg:IsExists(c13254066.tdfilter,1,nil)
end
function c13254066.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c13254066.tdfilter,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254066.tgfilter,tp,LOCATION_DECK,0,g:GetCount(),nil) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c13254066.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=0
	local ct2=0
	local rg=eg:Filter(c13254066.tdfilter1,nil,e)
	local ct=Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
	rg=Duel.GetOperatedGroup()
	local tc=rg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_DECK) and tc:IsType(TYPE_MONSTER) then
			if tc:GetControler()==tp then ct1=ct1+1
			else ct2=ct2+1 end
		end
		tc=rg:GetNext()
	end
	if ct1>0 then Duel.ShuffleDeck(tp) end
	if ct2>0 then Duel.ShuffleDeck(1-tp) end
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c13254066.tgfilter,tp,LOCATION_DECK,0,ct,ct,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end

function c13254066.cfilter(c)
	return bit.band(c:GetPreviousLocation(),LOCATION_GRAVE+LOCATION_DECK)>0
end
function c13254066.tdfilter11(c,e)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsRelateToEffect(e)
end
function c13254066.tgfilter(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c13254066.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetReasonCard()~=e:GetHandler() and eg:IsExists(c13254066.cfilter,1,nil)
end
function c13254066.tdtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=eg:FilterCount(c13254066.cfilter,nil)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c13254066.tdfilter11,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,ct,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c13254066.tdfilter11,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function c13254066.tdop1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<=0 then return end
	local ct=Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	if ct>0 then
		Duel.BreakEffect()
		Duel.DiscardDeck(tp,ct,REASON_EFFECT)
	end
end
