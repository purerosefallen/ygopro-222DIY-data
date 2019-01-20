--Ⅷ集团军 秘渊守护者
function c16001006.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x5c1),2,2)
	--todeck and draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16001006,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,16001006)
	e1:SetCondition(c16001006.tdcon)
	e1:SetTarget(c16001006.tdtg)
	e1:SetOperation(c16001006.tdop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c16001006.discon)
	e2:SetOperation(c16001006.disop)
	c:RegisterEffect(e2)
end
function c16001006.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c16001006.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),PLAYER_ALL,LOCATION_REMOVED)
end
function c16001006.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local ct1=g:GetCount()
	if ct1>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if not g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then return end
		if g:IsExists(Card.IsControler,1,nil,tp) then Duel.ShuffleDeck(tp) end
		if g:IsExists(Card.IsControler,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
		local ct2=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct1==ct2 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(16001006,1)) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c16001006.xyzfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c16001006.discon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return lg:IsExists(c16001006.xyzfilter,1,nil) and loc==LOCATION_GRAVE
end
function c16001006.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end