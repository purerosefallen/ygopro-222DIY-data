--快嘴人
function c65040029.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,65040029)
	e1:SetCondition(c65040029.con)
	e1:SetCost(c65040029.cost)
	e1:SetTarget(c65040029.tg)
	e1:SetOperation(c65040029.op)
	c:RegisterEffect(e1)
end
function c65040029.fil(c)
	return not c:IsReason(REASON_DRAW)
end
function c65040029.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65040029.fil,1,nil) and ep~=tp
end
function c65040029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable(REASON_COST) end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(65040029,0))
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c65040029.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local num=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp) and num>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,num,1-tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,1-tp,num-1)
end
function c65040029.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	local num=g:GetCount()
	if num>0 then
		local num2=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		if num2>0 then
			Duel.ShuffleDeck(p)
			Duel.Draw(p,num2-1,REASON_EFFECT)
		end
	end
end