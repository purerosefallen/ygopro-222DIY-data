--Rebirthday_Truth
local m=77707066
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0xb9c0)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local ct=5-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) and Duel.IsPlayerCanDraw(1-tp,ct) end
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,ct)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local ct=5-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,nil)
		if Duel.SendtoDeck(g,nil,0,REASON_EFFECT)>0 then
			Duel.ShuffleDeck(1-tp)
			Duel.Draw(1-tp,ct,REASON_EFFECT)
			Duel.SetLP(1-tp,8000)
			Duel.SwapDeckAndGrave(tp)
		end
	end)
	c:RegisterEffect(e1)
end
