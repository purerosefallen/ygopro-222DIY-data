--无可逃离的终焉
function c65030090.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c65030090.target)
	e1:SetOperation(c65030090.activate)
	c:RegisterEffect(e1)
end
c65030090.card_code_list={65030086}
function c65030090.costfil(c)
	return aux.IsCodeListed(c,65030086) and c:IsFaceup() and c:IsAbleToDeck()
end
function c65030090.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local num1=Duel.GetMatchingGroupCount(c65030090.costfil,tp,LOCATION_MZONE,0,nil)
	local num2=Duel.GetMatchingGroupCount(Card.IsCanBeEffectTarget,tp,0,LOCATION_ONFIELD,nil,e)
	if num2<num1 then num1=num2 end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c65030090.costfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c65030090.costfil,tp,LOCATION_MZONE,0,1,num1,nil)
	local numm=g1:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,numm,numm,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g2,g2:GetCount(),0,0)
end
function c65030090.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g1=g:Filter(Card.IsControler,nil,tp)
	local g2=g:Filter(Card.IsControler,nil,1-tp)
	if g2:GetCount()>0 then
		local tc=g2:GetFirst()
		while tc do
			if tc:IsFaceup() and not tc:IsDisabled() and not tc:IsImmuneToEffect(e) then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
			end
			tc=g2:GetNext()
		end
		if Duel.SendtoGrave(g2,REASON_EFFECT)~=0 then
			Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
		end
	end
end