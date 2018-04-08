--灵都·雾雨綿都
local m=1111203
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1111203.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c1111203.tg2)
	e2:SetOperation(c1111203.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c1111203.tg3)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
--
end
--
function c1111203.tfilter2_2(c)
	return c:IsCanAddCounter(0x1111,1) and c:IsFaceup()
end
function c1111203.tfilter2_3(c)
	return c:GetCounter(0x1111)>0 and c:IsAbleToChangeControler()
end
function c1111203.tfilter2_4(c)
	return c:IsAbleToGrave() and muxu.check_set_Soul(c)
end
function c1111203.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,1111215)<1
	local b2=Duel.IsExistingMatchingCard(c1111203.tfilter2_2,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetFlagEffect(tp,1111216)<1
	local num=Duel.GetMatchingGroupCount(c1111203.tfilter2_3,tp,0,LOCATION_MZONE,1,nil)
	local b3=Duel.IsExistingMatchingCard(c1111203.tfilter2_4,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(c1111203.tfilter2_3,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=num and Duel.GetFlagEffect(tp,1111217)<1
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1111203,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1111203,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(1111203,2)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		Duel.SetTargetCard(eg)
		Duel.RegisterFlagEffect(tp,1111215,RESET_PHASE+PHASE_END,0,1)
	elseif sel==2 then
		e:SetCategory(CATEGORY_COUNTER)
		Duel.RegisterFlagEffect(tp,1111216,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.RegisterFlagEffect(tp,1111217,RESET_PHASE+PHASE_END,0,1)
	end
end
--
function c1111203.op2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		local sg=eg:Filter(Card.IsRelateToEffect,nil,e)
		if sg:GetCount()<1 then return end
		local sc=sg:GetFirst()
		while sc do
			local e2_1=Effect.CreateEffect(c)
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
			e2_1:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e2_1)
			sc=sg:GetNext()
		end
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1111203,3))
		local sg=Duel.SelectMatchingCard(tp,c1111203.tfilter2_2,tp,LOCATION_ONFIELD,0,1,1,nil)
		if sg:GetCount()<1 then return end
		local sc=sg:GetFirst()
		sc:AddCounter(0x1111,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,c1111203.tfilter2_4,tp,LOCATION_SZONE,0,1,1,nil)
		if sg:GetCount()<1 then return end
		if Duel.SendtoGrave(sg,REASON_EFFECT)<1 then return end
		local num=Duel.GetMatchingGroupCount(c1111203.tfilter2_3,tp,0,LOCATION_MZONE,1,nil)
		if num>Duel.GetLocationCount(tp,LOCATION_MZONE) then return end
		local gn=Duel.GetMatchingGroup(c1111203.tfilter2_3,tp,0,LOCATION_MZONE,1,nil)
		if gn:GetCount()<1 then return end
		local tc=gn:GetFirst()
		while tc do
			Duel.GetControl(tc,tp,PHASE_END,1)
			tc=gn:GetNext()
		end
	end
end
--
function c1111203.tg3(e,c)
	return muxu.check_set_Urban(c) and c:IsType(TYPE_MONSTER)
end
--
