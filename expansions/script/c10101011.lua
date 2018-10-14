--苍翼之证
function c10101011.initial_effect(c)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10101011.drtg)
	e1:SetOperation(c10101011.drop)
	c:RegisterEffect(e1)	
end
c10101011.card_code_list={10101001}
function c10101011.cfilter1(c)
	return (c:IsAbleToRemove() or c:IsAbleToGrave()) and c:IsSetCard(0x6330) and c:IsType(TYPE_MONSTER)
end
function c10101011.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x6330) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c10101011.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local sel=0
		if not Duel.IsPlayerCanDraw(tp,2) then return false end
		if Duel.IsExistingMatchingCard(c10101011.cfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(c10101011.cfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		sel=Duel.SelectOption(tp,aux.Stringid(10101011,0),aux.Stringid(10101011,1))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(10101011,0))
	else
		Duel.SelectOption(tp,aux.Stringid(10101011,1))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
		e:SetProperty(0)
	else
		e:SetCategory(CATEGORY_TODECK)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c10101011.cfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	end
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c10101011.drop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local tc=Duel.SelectMatchingCard(tp,c10101011.cfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
		if tc then
			 local op1,op2=false,false
			 if tc:IsAbleToRemove() then op2=true end
			 if tc:IsAbleToGrave() then op1=true end
			 if op1 and op2 then
				if Duel.SelectYesNo(tp,aux.Stringid(10101011,2)) then
					Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
				else
					Duel.SendtoGrave(tc,REASON_EFFECT)
				end
			 elseif op1 then
					Duel.SendtoGrave(tc,REASON_EFFECT)
			 else
					Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			 end
		   Duel.BreakEffect()
		   Duel.Draw(tp,2,REASON_EFFECT)
		end
	else
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
end