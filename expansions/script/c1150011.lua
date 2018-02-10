--早安！
function c1150011.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c1150011.con1)
	e1:SetCost(c1150011.cost1)
	e1:SetTarget(c1150011.tg1)
	e1:SetOperation(c1150011.op1)
	c:RegisterEffect(e1)
--  
end
--
function c1150011.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
--
function c1150011.cfilter1(c)
	return c:IsType(TYPE_MONSTER)
end
function c1150011.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetMatchingGroupCount(c1150011.cfilter1,tp,LOCATION_HAND,0,nil)<1 end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c1150011.tfilter1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:GetLevel()<5
end
function c1150011.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>7 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
--
function c1150011.ofilter1_1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1150011.ofilter1_2(c)
	return c:GetType()==TYPE_SPELL and c:IsAbleToHand()
end
function c1150011.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>7 then
		Duel.ConfirmDecktop(tp,8)
		local g=Duel.GetDecktopGroup(tp,8)
		if g:GetCount()>0 and g:Filter(c1150011.ofilter1_1,nil):GetCount()>0 and g:Filter(c1150011.ofilter1_2,nil):GetCount()>0 then
			local sg1=g:Filter(c1150011.ofilter1_1,nil):RandomSelect(tp,1)
			local sg2=g:Filter(c1150011.ofilter1_2,nil):RandomSelect(tp,1)
			sg1:Merge(sg2)
			Duel.SendtoHand(sg1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg1)
		else
			Duel.ShuffleDeck(tp)
			Duel.ShuffleHand(tp)
		end
	else
		Duel.ShuffleHand(tp)
	end
end
--