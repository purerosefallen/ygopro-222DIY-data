--战斗武器-法布提
function c76121032.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xea3),3,3)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c76121032.discon)
	e1:SetTarget(c76121032.distg)
	c:RegisterEffect(e1)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76121032,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c76121032.rettg)
	e2:SetOperation(c76121032.retop)
	c:RegisterEffect(e2)
end
function c76121032.lcheck(g,lc)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c76121032.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c76121032.discon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c76121032.disfilter,1,nil)
end
function c76121032.distg(e,c)
	return c~=e:GetHandler() and ((c:IsStatus(STATUS_SUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_NORMAL)) or (c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_SPECIAL))) and not e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c76121032.retfilter(c)
	return c:IsAbleToDeck()
end
function c76121032.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c76121032.retfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c76121032.retfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,nil,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g2,1,0,0)
end
function c76121032.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g1=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if Duel.SendtoDeck(g1,nil,0,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local g2=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		Duel.SendtoGrave(g2,REASON_EFFECT+REASON_RETURN)
	end
end