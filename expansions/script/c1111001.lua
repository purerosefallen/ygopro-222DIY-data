--三叶草 or 四叶草
local m=1111001
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Butterfly=true
--
function c1111001.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_COIN+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1111001.tg1)
	e1:SetOperation(c1111001.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c1111001.cost2)
	e2:SetOperation(c1111001.op2)
	c:RegisterEffect(e2)
--
end
--
function c1111001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
--
function c1111001.ofilter1(c)
	return (c:IsAbleToHand() or c:IsAbleToRemove())
		and muxu.check_set_Urban(c) and c:IsType(TYPE_MONSTER)
end
function c1111001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local r1,r2,r3=Duel.TossCoin(tp,3)
	if r1+r2+r3>0 then
		Duel.Recover(tp,800,REASON_EFFECT)
	end
	if r1+r2+r3>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
		local sg=Duel.SelectMatchingCard(tp,c1111001.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			local sc=sg:GetFirst()
			local b1=sc:IsAbleToHand()
			local b2=sc:IsAbleToRemove()
			local off=1
			local ops={}
			local opval={}
			if b1 then
				ops[off]=aux.Stringid(1111001,0)
				opval[off-1]=1
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(1111001,1)
				opval[off-1]=2
				off=off+1
			end
			local op=Duel.SelectOption(tp,table.unpack(ops))
			local sel=opval[op]
			if sel==1 then
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
			else
				Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
	if r1+r2+r3>2 then
		Duel.Draw(tp,1,REASON_EFFECT)
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_1:SetCode(EVENT_TO_GRAVE)
		e1_1:SetCondition(c1111001.con1_1)
		e1_1:SetOperation(c1111001.op1_1)
		e1_1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1_1,tp)
	end
end
function c1111001.cfilter1_1(c)
	return muxu.check_set_Urban(c)
		and c:IsType(TYPE_MONSTER) and c:GetLevel()>0
end
function c1111001.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1111001.cfilter1_1,1,nil)
end
function c1111001.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=eg:Filter(c1111001.cfilter1_1,nil)
	if tg:GetCount()<1 then return end
	local tc=tg:GetFirst()
	while tc do
		local e1_1_1=Effect.CreateEffect(c)
		e1_1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1_1:SetCode(EFFECT_CHANGE_LEVEL)
		e1_1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_1_1:SetValue(5)
		e1_1_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_1_1)
		tc=g:GetNext()
	end
end
--
function c1111001.cfilter2(c)
	return c:IsCode(1111001) and c:IsAbleToDeckAsCost()
end
function c1111001.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c1111001.cfilter2,tp,LOCATION_GRAVE,0,1,99,c)
	sg:AddCard(c)
	e:SetLabel(sg:GetCount())
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
--
function c1111001.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rnum=e:GetLabel()
	if rnum>0 then
		Duel.Recover(tp,800,REASON_EFFECT)
	end
	if rnum>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
		local sg=Duel.SelectMatchingCard(tp,c1111001.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			local sc=sg:GetFirst()
			local b1=sc:IsAbleToHand()
			local b2=sc:IsAbleToRemove()
			local off=1
			local ops={}
			local opval={}
			if b1 then
				ops[off]=aux.Stringid(1110131,0)
				opval[off-1]=1
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(1110131,1)
				opval[off-1]=2
				off=off+1
			end
			local op=Duel.SelectOption(tp,table.unpack(ops))
			local sel=opval[op]
			if sel==1 then
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
			else
				Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
	if rnum>2 then
		Duel.Draw(tp,1,REASON_EFFECT)
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_1:SetCode(EVENT_TO_GRAVE)
		e1_1:SetCondition(c1111001.con1_1)
		e1_1:SetOperation(c1111001.op1_1)
		e1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1_1,tp)
	end
end
--
