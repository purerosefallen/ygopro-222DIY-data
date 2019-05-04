--快嘴人
function c65040034.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,65040034)
	e1:SetCondition(c65040034.con)
	e1:SetCost(c65040034.cost)
	e1:SetTarget(c65040034.tg)
	e1:SetOperation(c65040034.op)
	c:RegisterEffect(e1)
end
function c65040034.fil(c)
	return not c:IsReason(REASON_DRAW)
end
function c65040034.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65040034.fil,1,nil) and ep~=tp
end
function c65040034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable(REASON_COST) end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(65040034,0))
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c65040034.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local num=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp) and num>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,num,1-tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,1-tp,num)
end
function c65040034.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	local num=g:GetCount()
	if num>0 then
		local num2=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		if num2>0 then
			Duel.ShuffleDeck(p)
			if Duel.Draw(p,num2,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp) and Duel.SelectYesNo(tp,aux.Stringid(65040034,1)) then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
				local mmg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
				Duel.ConfirmCards(1-tp,mmg)
				if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(65040034,2)) then
					local ggg=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
					Duel.SendtoDeck(ggg,nil,2,REASON_EFFECT)			 
					Duel.ShuffleDeck(tp)
					Duel.Draw(tp,ggg:GetCount(),REASON_EFFECT)
				end
			end
		end
	end
end