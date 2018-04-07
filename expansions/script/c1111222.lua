--灵曲·拂晓繁华之风
local m=1111222
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Soul=true
--
function c1111222.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1111222,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCost(c1111222.cost1)
	e1:SetTarget(c1111222.tg1)
	e1:SetOperation(c1111222.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1111222,1))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c1111222.tg2)
	e2:SetOperation(c1111222.op2)
	c:RegisterEffect(e2)
--
end
--
function c1111222.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
--
function c1111222.tfilter1(c)
	return c:GetCounter(0x1111)>0 and c:IsCanRemoveCounter(tp,0x1111,1,REASON_COST) and not c:IsCode(1111222)
end
function c1111222.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return end
		return Duel.IsExistingMatchingCard(c1111222.tfilter1,tp,LOCATION_ONFIELD,0,1,nil) and c:IsCanAddCounter(0x1111,1)
	end
	local tg=Duel.GetMatchingGroup(c1111222.tfilter1,tp,LOCATION_ONFIELD,0,1,nil)
	local num=0
	local tc=tg:GetFirst()
	while tc do
		local ct=tc:GetCounter(0x1111)
		if tc:RemoveCounter(tp,0x1111,ct,0) then num=num+ct end
		tc=tg:GetNext()
	end
	e:SetLabel(num)
end
--
function c1111222.ofilter1_1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPIRIT) and c:IsType(TYPE_MONSTER)
end
function c1111222.ofilter1_2(c)
	return c:IsSSetable() and muxu.check_set_Legend(c)
end
function c1111222.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=e:GetLabel()
	if not c:IsCanAddCounter(0x1111,num) then return end
	c:AddCounter(0x1111,num)
	if num>1 and Duel.GetFlagEffect(tp,1111221)<1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1111222.ofilter1_1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.RegisterFlagEffect(tp,1111221,RESET_PHASE+PHASE_END,0,1)
		end
	end
	if num>5 and Duel.GetFlagEffect(tp,1111222)<1 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c1111222.ofilter1_2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()<1 then return end
		local tc=g:GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local e1_3=tc:GetActivateEffect()
		e1_3:SetProperty(0,EFFECT_FLAG2_COF)
		e1_3:SetHintTiming(0,0x1e0+TIMING_CHAIN_END)
		e1_3:SetCondition(c1111222.con1_3)
		tc:RegisterFlagEffect(1111222,RESET_EVENT+0x1fe0000,0,1)
		local e1_4=Effect.CreateEffect(c)
		e1_4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_4:SetCode(EVENT_ADJUST)
		e1_4:SetOperation(c1111222.op1_4)
		e1_4:SetLabelObject(tc)
		Duel.RegisterEffect(e1_4,tp)
	end
end
--
function c1111222.con1_3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c1111222.op1_4(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(1111222)~=0 then return end
	local e1_4_1=tc:GetActivateEffect()
	e1_4_1:SetProperty(nil)
	e1_4_1:SetHintTiming(0)
	e1_4_1:SetCondition(aux.TRUE)
	e:Reset()   
end
--
function c1111222.tfilter2_1(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function c1111222.tfilter2_2(c)
	return c:IsCanAddCounter(0x1111,1)
end
function c1111222.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c1111222.tfilter2_1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1111222.tfilter2_1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) 
		and Duel.IsExistingMatchingCard(c1111222.tfilter2_2,tp,LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c1111222.tfilter2_1,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
--
function c1111222.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg then return end
	if tg:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
	if Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1111222,2))
	local g=Duel.SelectMatchingCard(tp,c1111222.tfilter2_2,tp,LOCATION_ONFIELD,0,1,c)
	if g:GetCount()<1 then return end
	local tc=g:GetFirst()
	tc:AddCounter(0x1111,1)
end
--
