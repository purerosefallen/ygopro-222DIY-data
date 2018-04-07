--灵都·双生并蒂
local m=1110131
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1110131.initial_effect(c)
--
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_COST)
	e3:SetCost(c1110131.cost3)
	e3:SetOperation(c1110131.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c1110131.con4)
	e4:SetTarget(c1110131.tg4)
	e4:SetOperation(c1110131.op4)
	c:RegisterEffect(e4)
--
end
--
function c1110131.cfilter3(c,e)
	return c:IsAbleToGrave()
end
function c1110131.cost3(e,c,tp)
	return Duel.IsExistingMatchingCard(c1110131.cfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler())
end
--
function c1110131.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1110131.cfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_COST)
	end
end
--
function c1110131.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK) and c:GetPreviousControler()==tp and rp~=tp
end
--
function c1110131.tfilter4_1(c)
	return c:IsAbleToHand() and muxu.check_set_Butterfly(c)
end
function c1110131.tfilter4_2(c)
	return muxu.check_set_Soul(c) and not c:IsForbidden()
end
function c1110131.tfilter4_3(c)
	return c:IsSSetable() and muxu.check_set_Legend(c) 
end
function c1110131.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c1110131.tfilter4_1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c1110131.tfilter4_2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b3=Duel.IsExistingMatchingCard(c1110131.tfilter4_3,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	if chk==0 then return b1 or b2 or b3 end
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
	if b3 then
		ops[off]=aux.Stringid(1110131,2)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif sel==2 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
	else
	end
end
--
function c1110131.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1110131.tfilter4_1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif sel==2 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1110131,3))
		local g=Duel.SelectMatchingCard(tp,c1110131.tfilter4_2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	else
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c1110131.tfilter4_3,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
			if tc:IsCode(1111008) then return end
			local e4_4=tc:GetActivateEffect()
			e4_4:SetProperty(0,EFFECT_FLAG2_COF)
			e4_4:SetHintTiming(0,0x1e0+TIMING_CHAIN_END)
			e4_4:SetCondition(c1110131.con4_4)
			tc:RegisterFlagEffect(1110131,RESET_EVENT+0x1fe0000,0,1)
			local e4_5=Effect.CreateEffect(c)
			e4_5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4_5:SetCode(EVENT_ADJUST)
			e4_5:SetOperation(c1110131.op4_5)
			e4_5:SetLabelObject(tc)
			Duel.RegisterEffect(e4_5,tp)
		end
	end
end
--
function c1110131.con4_4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c1110131.op4_5(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(1110131)~=0 then return end
	local e4_5_1=tc:GetActivateEffect()
	e4_5_1:SetProperty(nil)
	e4_5_1:SetHintTiming(0)
	e4_5_1:SetCondition(aux.TRUE)
	e:Reset()   
end
--

