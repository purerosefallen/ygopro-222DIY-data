--anger of dragon palace
function c11451422.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451422,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c11451422.condition)
	e1:SetTarget(c11451422.target)
	e1:SetOperation(c11451422.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c11451422.hand)
	c:RegisterEffect(e2)
	--act from deck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c11451422.cost2)
	e3:SetTarget(c11451422.target2)
	e3:SetOperation(c11451422.operation2)
	c:RegisterEffect(e3)
end
function c11451422.filter(c)
	return c:IsSetCard(0x6978)
end
function c11451422.filter2(c)
	return c:IsSetCard(0x6978) and c:IsAbleToDeck()
end
function c11451422.filter3(c,tp)
	return c:IsCode(22702055) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c11451422.hand(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.IsExistingMatchingCard(c11451422.filter,tp,0,LOCATION_MZONE,1,nil) or Duel.IsExistingMatchingCard(c11451422.filter,tp,LOCATION_MZONE,0,1,nil))
end
function c11451422.condition(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetCurrentChain()
	if rp==tp then return false end
	return Duel.GetChainInfo(n-1,CHAININFO_TRIGGERING_PLAYER)==tp and Duel.IsChainDisablable(ev)
end
function c11451422.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c11451422.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
		if g:GetCount()>0 then
			if Duel.SelectYesNo(1-tp,aux.Stringid(11451422,1)) then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
				local g2=g:Select(1-tp,1,1,nil)
				Duel.HintSelection(g2)
				Duel.SendtoGrave(g2,REASON_RULE)
			else
				local c=e:GetHandler()
				if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
					Duel.BreakEffect()
					c:CancelToGrave()
					Duel.ChangePosition(c,POS_FACEDOWN)
					Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
				end
			end
		else
			local c=e:GetHandler()
			if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
				Duel.BreakEffect()
				c:CancelToGrave()
				Duel.ChangePosition(c,POS_FACEDOWN)
				Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			end
		end
	end
end
function c11451422.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c11451422.filter2,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=4 end
	local g2=Group.CreateGroup()
	g2:AddCard(e:GetHandler())
	g:Remove(Card.IsCode,nil,e:GetHandler():GetCode())
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g3=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g3:GetFirst():GetCode())
		g2:Merge(g3)
	end
	Duel.SendtoDeck(g2,nil,2,REASON_COST)
end
function c11451422.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11451422.filter3,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c11451422.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11451422.filter3,tp,LOCATION_DECK,0,nil,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451422,2))
		local tc=Duel.SelectMatchingCard(tp,c11451422.filter3,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end