--辉光之针的利立浦特
function c1156008.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c1156008.lfilter),2,4)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1156008,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,1156008)
	e1:SetCost(c1156008.cost1)
	e1:SetTarget(c1156008.tg1)
	e1:SetOperation(c1156008.op1)
	c:RegisterEffect(e1)
--
end
--
function c1156008.lfilter(c)
	return c:IsType(TYPE_EFFECT) and c:GetAttack()<501
end
--
function c1156008.cfilter1(c,tc)
	return c:IsFaceup() and c:IsReleasable()
		and c:GetAttack()<tc:GetAttack()
end
function c1156008.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1156008.cfilter1,tp,LOCATION_MZONE,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,c1156008.cfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(rg,REASON_COST)
end
--
function c1156008.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsPlayerCanDraw(tp) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(c1156008.tfilter1_2,tp,LOCATION_MZONE,LOCATION_MZONE,1,lg)
	if chk==0 then return b1 or b2 or b3 end
end
--
function c1156008.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsPlayerCanDraw(tp) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(c1156008.tfilter1_2,tp,LOCATION_MZONE,LOCATION_MZONE,1,lg)
	if not (b1 or b2 or b3) then return end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1156008,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1156008,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(1156008,3)
		opval[off-1]=3
		off=off+1
	end
	if sel==1 then
		local rg1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
		local rg2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
		local sg=Group.CreateGroup()
		if rg1:GetCount()>0 and (rg2:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(1156008,4))) then
			local sg1=rg1:RandomSelect(tp,1)
			Duel.HintSelection(sg1)
			sg:Merge(sg1)
		end
		if rg2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(1156008,5))) then
			local sg2=rg2:RandomSelect(tp,1)
			Duel.HintSelection(sg2)
			sg:Merge(sg2)
		end
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
	if sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,63,nil)
		if Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)>0 then
			local num=Duel.GetOperatedGroup():GetCount()
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,num,REASON_EFFECT)
		end
	end
	if sel==3 then
		local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		ag:Sub(lg)
		local ac=ag:GetFirst()
		while ac do
			if ac:GetAttack()~=c:GetAttack() then
				local e1_1=Effect.CreateEffect(c)
				e1_1:SetType(EFFECT_TYPE_SINGLE)
				e1_1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1_1:SetValue(c:GetAttack())
				e1_1:SetReset(RESET_EVENT+0xfe0000)
				ac:RegisterEffect(e1_1)
			end
			ac=ag:GetNext()
		end
		Duel.BreakEffect()
		local pg=ag:Filter(Card.IsControler,nil,tp)
		local pc=pg:GetFirst()
		while pc do
			local e1_2=Effect.CreateEffect(c)
			e1_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1_2:SetType(EFFECT_TYPE_SINGLE)
			e1_2:SetCode(EFFECT_IMMUNE_EFFECT)
			e1_2:SetRange(LOCATION_MZONE)
			e1_2:SetTarget(c1156008.tg1_2)
			e1_2:SetValue(c1156008.efilter1_2)
			pc:RegisterEffect(e1_2)
			pc=pg:GetNext()
		end
	end
	local e1_3=Effect.CreateEffect(c)
	e1_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_3:SetCode(EVENT_PHASE+PHASE_END)
	e1_3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1_3:SetLabel(Duel.GetTurnCount()+1)
	e1_3:SetCountLimit(1)
	e1_3:SetCondition(c1156008.con1_3)
	e1_3:SetOperation(c1156008.op1_3)
	e1_3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1_3,tp)
end
--
function c1156008.tg1_3(e,c)
	local g,te=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TRIGGERING_EFFECT)
	return not (te and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET))
		or not (g and g:IsContains(c))
end
function c1156008.efilter1_2(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--
function c1156008.con1_3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()
end
function c1156008.op1_3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsPlayerCanDraw(tp) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(c1156008.tfilter1_2,tp,LOCATION_MZONE,LOCATION_MZONE,1,lg)
	if not (b1 or b2 or b3) then return end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1156008,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1156008,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(1156008,3)
		opval[off-1]=3
		off=off+1
	end
	if sel==1 then
		local rg1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
		local rg2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
		local sg=Group.CreateGroup()
		if rg1:GetCount()>0 and (rg2:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(1156008,4))) then
			local sg1=rg1:RandomSelect(tp,1)
			Duel.HintSelection(sg1)
			sg:Merge(sg1)
		end
		if rg2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(1156008,5))) then
			local sg2=rg2:RandomSelect(tp,1)
			Duel.HintSelection(sg2)
			sg:Merge(sg2)
		end
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
	if sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,63,nil)
		if Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)>0 then
			local num=Duel.GetOperatedGroup():GetCount()
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,num,REASON_EFFECT)
		end
	end
	if sel==3 then
		local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		ag:Sub(lg)
		local ac=ag:GetFirst()
		while ac do
			if ac:GetAttack()~=c:GetAttack() then
				local e1_3_1=Effect.CreateEffect(c)
				e1_3_1:SetType(EFFECT_TYPE_SINGLE)
				e1_3_1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1_3_1:SetValue(c:GetAttack())
				e1_3_1:SetReset(RESET_EVENT+0xfe0000)
				ac:RegisterEffect(e1_3_1)
			end
			ac=ag:GetNext()
		end
		Duel.BreakEffect()
		local pg=ag:Filter(Card.IsControler,nil,tp)
		local pc=pg:GetFirst()
		while pc do
			local e1_3_2=Effect.CreateEffect(c)
			e1_3_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1_3_2:SetType(EFFECT_TYPE_SINGLE)
			e1_3_2:SetCode(EFFECT_IMMUNE_EFFECT)
			e1_3_2:SetRange(LOCATION_MZONE)
			e1_3_2:SetTarget(c1156008.tg1_2)
			e1_3_2:SetValue(c1156008.efilter1_2)
			pc:RegisterEffect(e1_3_2)
			pc=pg:GetNext()
		end
	end
end
--