--灵曲·彼岸盛开之花
local m=1111221
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Soul=true
--
function c1111221.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1111221,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c1111221.tg1)
	e1:SetOperation(c1111221.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c1111221.cost2)
	e2:SetTarget(c1111221.tg2)
	e2:SetOperation(c1111221.op2)
	c:RegisterEffect(e2)
--
end
--
function c1111221.tfilter1_1(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_SPIRIT) and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c1111221.tfilter1_2(c)
	return c:IsAbleToGrave() and not ((c:IsType(TYPE_MONSTER) and c:IsType(TYPE_NORMAL)) or c:IsDisabled())
end
function c1111221.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c1111221.tfilter1_1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c1111221.tfilter1_2,tp,0,LOCATION_ONFIELD,1,nil) and c:IsCanAddCounter(0x1111,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c1111221.tfilter1_1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,c1111221.tfilter1_2,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,g1:GetCount(),0,0)
end
--
function c1111221.ofilter1(c,e)
	return c:IsRelateToEffect(e) and not c:IsDisabled()
end
function c1111221.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local gn=sg:Filter(c1111221.ofilter1,nil,e)
	if gn:GetCount()<1 then return end
	local tc=gn:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_DISABLE)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_1)
		local e1_2=e1_1:Clone()
		e1_2:SetCode(EFFECT_DISABLE_EFFECT)
		e1_2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e1_2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e1_3=Effect.CreateEffect(c)
			e1_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1_3:SetType(EFFECT_TYPE_SINGLE)
			e1_3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e1_3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1_3)
		end
		tc=gn:GetNext()
	end
	Duel.AdjustInstantly()
	if Duel.SendtoGrave(gn,REASON_EFFECT)<1 then return end
	c:AddCounter(0x1111,1)
end
--
function c1111221.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x1111,1,REASON_COST) end
	c:RemoveCounter(tp,0x1111,1,REASON_COST)
end
--
function c1111221.tfilter2_2(c)
	return c:IsSSetable() and muxu.check_set_Legend(c)
end
function c1111221.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
	local b2=Duel.IsExistingMatchingCard(c1111221.tfilter2_2,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b3=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_REMOVED,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1111202,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1111202,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(1111202,3)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,LOCATION_GRAVE)
	elseif sel==2 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,0,LOCATION_GRAVE)
	end
end
--
function c1111221.op2(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
		local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
		local num1=g1:GetCount()
		local num2=g2:GetCount()
		if num1<1 or num2<1 then return end
		if num1>num2 then num1=num2 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,num1,nil)
		local num=g1:GetCount()
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,num,num,nil)
		g1:Merge(g2)
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	elseif sel==2 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c1111221.tfilter2_2,tp,LOCATION_GRAVE,0,1,nil)
		if g:GetCount()<1 then return end
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g)
	else
		if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_REMOVED,1,nil) then
			local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_REMOVED,0,1,1,nil)
			local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_REMOVED,1,1,nil)
			g1:Merge(g2)
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end
	end
end
