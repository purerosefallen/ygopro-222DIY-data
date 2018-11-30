--HappySky·高垣枫
function c81007010.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),8,2,c81007010.ovfilter,aux.Stringid(81007010,0))
	c:EnableReviveLimit()
	--battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetOperation(c81007010.baop)
	c:RegisterEffect(e1)
	--ret&draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81007010,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,8107010)
	e2:SetCost(c81007010.cost)
	e2:SetTarget(c81007010.target1)
	e2:SetOperation(c81007010.operation1)
	c:RegisterEffect(e2)
end
function c81007010.ovfilter(c)
	return c:IsFaceup() and c:IsLink(2) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_LINK)
end
function c81007010.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=c:GetBattleTarget()
	if d and c:IsFaceup() and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and d:IsStatus(STATUS_BATTLE_DESTROYED) and not d:IsType(TYPE_TOKEN) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_SEND_REPLACE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetTarget(c81007010.reptg)
		e1:SetOperation(c81007010.repop)
		e1:SetLabelObject(c)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		d:RegisterEffect(e1)
	end
end
function c81007010.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_BATTLE) and not c:IsImmuneToEffect(e) end
	return true
end
function c81007010.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
		 if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		 end
	Duel.Overlay(e:GetLabelObject(),Group.FromCards(c))
end
function c81007010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c81007010.filter1(c)
	return c:IsAbleToDeck()
end
function c81007010.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81007010.filter1(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c81007010.filter1,tp,LOCATION_GRAVE,0,10,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81007010.filter1,tp,LOCATION_GRAVE,0,10,10,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c81007010.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=10 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==10 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end