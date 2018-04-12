--蝶舞·返魂
local m=1111005
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Butterfly=true
--
function c1111005.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1111005+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1111005.tg1)
	e1:SetOperation(c1111005.op1)
	c:RegisterEffect(e1)
--
end
--
function c1111005.tfilter1(c)
	return muxu.check_set_Urban(c) and c:IsAbleToRemove() and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER)
end
function c1111005.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111005.tfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
--
function c1111005.ofilter1_3(c)
	return muxu.check_set_Legend(c) and c:IsAbleToHand()
end
function c1111005.ofilter1_4(c)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()<4 and c:IsAbleToHand()
end
function c1111005.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c1111005.tfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	if tg:GetCount()<1 then return end
	local tc=tg:GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)<1 then return end
	local b1=tc:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=tc:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	local b3=tc:IsType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(c1111005.ofilter1_3,tp,LOCATION_DECK,0,1,nil)
	local b4=tc:IsType(TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(c1111005.ofilter1_4,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	local b5=tc:IsType(TYPE_RITUAL) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsPlayerCanDraw(tp,1)
	if (b1 or b2 or b3 or b4 or b5) and Duel.SelectYesNo(tp,aux.Stringid(1111005,0)) then
		if b1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
		if b2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
			if g:GetCount()>0 then
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			end
		end
		if b3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c1111005.ofilter1_3,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
		if b4 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,c1111005.ofilter1_4,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
		if b5 then
			local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then Duel.Draw(tp,1,REASON_EFFECT) end
		end
	end
end
--
