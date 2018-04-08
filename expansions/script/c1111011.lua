--秘谈·澄澈的空海
local m=1111011
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Legend=true
--
function c1111011.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1111011.tg1)
	e1:SetOperation(c1111011.op1)
	c:RegisterEffect(e1)
--
end
--
function c1111011.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
end
--
function c1111011.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	if sg:GetCount()<1 then return end
	Duel.ConfirmCards(tp,sg)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_1:SetCode(EVENT_CHAINING)
	e1_1:SetCondition(c1111011.con1_1)
	e1_1:SetOperation(c1111011.op1_1)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1_1)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_2:SetCode(EVENT_CHAIN_SOLVED)
	e1_2:SetCondition(c1111011.con1_2)
	e1_2:SetOperation(c1111011.op1_2)
	e1_2:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1_2)
end
--
function c1111011.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)==0 and rp~=tp and re:IsActiveType(TYPE_MONSTER)
end
--
function c1111011.op1_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,1111011,RESET_CHAIN,0,1)
end
--
function c1111011.con1_2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,1111011)>0
end
--
function c1111011.ofilter1_2_2(c,att)
	return c:IsDiscardable() and c:IsAttribute(att)
end
function c1111011.op1_2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=Duel.GetFlagEffect(tp,1111011)
	while num>0 do
		local b1=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and Duel.IsPlayerCanDraw(tp,1) and Duel.GetFlagEffect(tp,1111012)<1
		local b2=Duel.GetFlagEffect(tp,1111013)<1
		local b3=Duel.GetFlagEffect(tp,1111014)<1
		local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=aux.Stringid(1111011,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(1111011,1)
			opval[off-1]=2
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(1111011,2)
			opval[off-1]=3
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		local sel=opval[op]
		e:SetLabel(sel)
		if sel==1 then
			Duel.RegisterFlagEffect(tp,1111011,RESET_PHASE+PHASE_END,0,1)
			Duel.Draw(tp,1,REASON_EFFECT)
			local gn=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
			if gn:GetCount()>0 then
				Duel.SendtoDeck(gn,nil,2,REASON_EFFECT)
			end
		elseif sel==2 then
			Duel.RegisterFlagEffect(tp,1111012,RESET_PHASE+PHASE_END,0,1)
			local att=re:GetHandler():GetAttribute()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local gn=Duel.SelectMatchingCard(1-tp,c1111012.ofilter1_2_2,1-tp,LOCATION_HAND,0,nil,att)
			if gn:GetCount()>0 then
				Duel.SendtoGrave(gn,REASON_RULE+REASON_DISCARD)
			end
		else
			Duel.RegisterFlagEffect(tp,1111013,RESET_PHASE+PHASE_END,0,1)
			local att=re:GetHandler():GetAttribute()
			local e1_2_3=Effect.CreateEffect(c)
			e1_2_3:SetType(EFFECT_TYPE_FIELD)
			e1_2_3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1_2_3:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1_2_3:SetTargetRange(0,1)
			e1_2_3:SetLabelObject(att)
			e1_2_3:SetValue(c1111011.val1_2_3)
			e1_2_3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1_2_3,tp)
		end
		num=num-1
	end
end
--
function c1111011.val1_2_3(e,re,tp)
	local att=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and not (re:GetHandler():IsAttribute(att) and re:GetHandler():IsLocation(LOCATION_ONFIELD))
end
--
