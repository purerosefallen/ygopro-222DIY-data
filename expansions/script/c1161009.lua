--仙境·时钟兔
function c1161009.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c1161009.tg1)
	e1:SetOperation(c1161009.op1)
	c:RegisterEffect(e1)  
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c1161009.cost2)
	e2:SetTarget(c1161009.tg2)
	e2:SetOperation(c1161009.op2)
	c:RegisterEffect(e2)  
--
	Duel.AddCustomActivityCounter(1161009,ACTIVITY_SPSUMMON,c1161009.counterfilter) 
--
end
--
function c1161009.counterfilter(c)
	return c:GetLevel()==1 or c:IsLocation(LOCATION_EXTRA)
end
--
function c1161009.tfilter1(c)
	return c:GetLevel()==1 and c:IsAbleToGrave() and c:IsAbleToRemove() and c:GetAttack()>399
end
function c1161009.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c1161009.tfilter1,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.GetCustomActivityCount(1161009,tp,ACTIVITY_SPSUMMON)==0 and g:GetClassCount(Card.GetCode)>1 end
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	e1_1:SetTargetRange(1,0)
	e1_1:SetTarget(c1161009.tg1_1)
	Duel.RegisterEffect(e1_1,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c1161009.tg1_1(e,c)
	return not (c:GetLevel()==1 or c:IsLocation(LOCATION_EXTRA))
end
--
function c1161009.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1161009.tfilter1,tp,LOCATION_DECK,0,nil)
	local gc=g:GetClassCount(Card.GetCode)
	if gc>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local g1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		local g2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		g1:Merge(g2)
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local tg=g1:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.SendtoGrave(tc,REASON_EFFECT)
		g1:RemoveCard(tc)
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	end
end
--
function c1161009.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
--
function c1161009.tfilter2(c)
	return c:IsAbleToDeck() and not c:IsCode(1161009)
end
function c1161009.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(1161009,tp,ACTIVITY_SPSUMMON)==0 and Duel.IsExistingMatchingCard(c1161009.tfilter2,tp,LOCATION_REMOVED,0,1,nil) end
	local e2_1=Effect.CreateEffect(e:GetHandler())
	e2_1:SetType(EFFECT_TYPE_FIELD)
	e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2_1:SetReset(RESET_PHASE+PHASE_END)
	e2_1:SetTargetRange(1,0)
	e2_1:SetTarget(c1161009.tg2_1)
	Duel.RegisterEffect(e2_1,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0)
end
function c1161009.tg2_1(e,c)
	return not (c:GetLevel()==1 or c:IsLocation(LOCATION_EXTRA))
end
--
function c1161009.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1161009.tfilter2,tp,LOCATION_REMOVED,0,1,3,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.ConfirmDecktop(tp,1)
		local sg=Duel.GetDecktopGroup(tp,1)  
		local tc=sg:GetFirst()
		if tc and tc:GetLevel()==1 and tc:IsType(TYPE_MONSTER) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.ShuffleDeck(tp)
		end
	end
end
--