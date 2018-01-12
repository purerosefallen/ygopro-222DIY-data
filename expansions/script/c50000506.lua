--暮光的星宿
function c50000506.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCondition(c50000506.condition)
	e1:SetTarget(c50000506.target)
	e1:SetOperation(c50000506.activate)
	c:RegisterEffect(e1)   
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,50000506)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c50000506.drtg)
	e2:SetOperation(c50000506.drop)
	c:RegisterEffect(e2)
end
function c50000506.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x50e)
end
function c50000506.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c50000506.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c50000506.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c50000506.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c50000506.cfilter,tp,LOCATION_ONFIELD,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,e:GetHandler())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c50000506.filter(c)
	return c:IsSetCard(0x50e) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c50000506.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c50000506.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(c50000506.filter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c50000506.filter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c50000506.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end


