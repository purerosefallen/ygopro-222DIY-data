--飞球之魔能弹
function c13254129.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13254129,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_DAMAGE+CATEGORY_RECOVER+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c13254129.target)
	e1:SetOperation(c13254129.operation)
	c:RegisterEffect(e1)
	
end
function c13254129.filter(c)
	return c:IsAbleToDeck() and c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254129.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c13254129.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13254129.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c13254129.filter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c13254129.rfilter(c)
	return c:IsAbleToRemove() and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end
function c13254129.cfilter(c)
	return c:IsCode(13254052) and c:IsFaceup()
end
function c13254129.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,POS_FACEUP,REASON_EFFECT)>0 then
		local t1=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsPlayerCanDraw(tp,1)
		local t2=Duel.IsExistingMatchingCard(c13254129.rfilter,tp,0,LOCATION_GRAVE+LOCATION_EXTRA,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil)
		local t=Duel.IsExistingMatchingCard(c13254129.cfilter,tp,LOCATION_ONFIELD,0,1,nil)

		local op=0
		if not t then
			local m={}
			local n={}
			local ct=1
			if t1 then m[ct]=aux.Stringid(13254129,0) n[ct]=1 ct=ct+1 end
			m[ct]=aux.Stringid(13254129,1) n[ct]=2 ct=ct+1
			if t2 then m[ct]=aux.Stringid(13254129,2) n[ct]=3 ct=ct+1 end
			local sp=Duel.SelectOption(tp,table.unpack(m))
			op=n[sp+1]
		end

		if op==1 or t then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
				Duel.Destroy(g,REASON_EFFECT)
			end
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		if op==2 or t then
			Duel.Damage(1-tp,1000,REASON_EFFECT)
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
		if op==3 or t then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,c13254129.rfilter,tp,0,LOCATION_GRAVE+LOCATION_EXTRA,1,1,nil)
			if g:GetCount()>0 then
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,1,nil)
			if g1:GetCount()>0 then
				Duel.SendtoGrave(g1,REASON_EFFECT)
			end
		end
	end
end
