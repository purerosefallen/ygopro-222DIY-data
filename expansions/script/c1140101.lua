--剧毒之身
function c1140101.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1140101.tg1)
	e1:SetOperation(c1140101.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c1140101.cost2)
	e2:SetTarget(c1140101.tg2)
	e2:SetOperation(c1140101.op2)
	c:RegisterEffect(e2)
--
end
--
function c1140101.tfilter1_1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and muxu.check_set_Medicine(c)
end
function c1140101.tfilter1_2(c)
	return c:IsSSetable() and c:IsType(TYPE_TRAP) and muxu.check_set_Poison(c) and not c:IsForbidden()
end
function c1140101.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c1140101.tfilter1_1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c1140101.tfilter1_2,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b3=Duel.IsPlayerCanSpecialSummonMonster(tp,1140901,nil,0x4011,400,600,1,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1140101,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1140101,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(1140101,2)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	if sel==3 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	end
end
--
function c1140101.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c1140101.tfilter1_1,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
	if sel==2 then 
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.SelectMatchingCard(tp,c1140101.tfilter1_2,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			local tc=sg:GetFirst()
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
	if sel==3 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,1140901,nil,0x4011,400,600,1,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP,tp) then return end
		local token=Duel.CreateToken(tp,1140901)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c1140101.cfilter2(c)
	return muxu.check_set_Medicine(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c1140101.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c1140101.cfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c1140101.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	sg:AddCard(c)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
--
function c1140101.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
--
function c1140101.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsType(TYPE_TRAP) and muxu.check_set_Poison(tc) then
			if Duel.Damage(1-tp,800,REASON_EFFECT)>0 then
				Duel.RegisterFlagEffect(tp,1140101,0,0,0)
				local c=e:GetHandler()
				local e2_1=Effect.CreateEffect(c)
				e2_1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
				e2_1:SetProperty(EFFECT_FLAG_DELAY)
				e2_1:SetCode(EVENT_SPSUMMON_SUCCESS)
				e2_1:SetCondition(c1140101.con2_1)
				e2_1:SetOperation(c1140101.op2_1)
				Duel.RegisterEffect(e2_1,tp)
				local e2_2=Effect.CreateEffect(c)
				e2_2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
				e2_2:SetCode(EVENT_SPSUMMON_SUCCESS)
				e2_2:SetCondition(c1140101.con2_2)
				e2_2:SetOperation(c1140101.op2_2)
				Duel.RegisterEffect(e2_2,tp)
				local e2_3=Effect.CreateEffect(c)
				e2_3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
				e2_3:SetCode(EVENT_CHAIN_SOLVED)
				e2_3:SetCondition(c1140101.con2_3)
				e2_3:SetOperation(c1140101.op2_3)
				Duel.RegisterEffect(e2_3,tp)
			end
		end
	end
end
--
function c1140101.cfilter2_1(c,sp)
	return c:GetSummonPlayer()==sp
end
function c1140101.con2_1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1140101.cfilter2_1,1,nil,1-tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
		and Duel.GetFlagEffect(tp,1140101)>0
end
function c1140101.op2_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,1140101)
	local sg=eg:Filter(c1140101.cfilter2_1,1,nil,1-tp)
	Duel.Destroy(sg,REASON_EFFECT)
	e:Reset()
end
--
function c1140101.con2_2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1140101.cfilter2_1,1,nil,1-tp)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
		and Duel.GetFlagEffect(tp,1140101)>0
end
function c1140101.op2_2(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c1140101.cfilter2_1,1,nil,1-tp)
	local sc=sg:GetFirst()
	while sc do
		sc:RegisterFlagEffect(1140101,RESET_EVENT+0x1fe0000,0,0)
		sc=sg:GetNext()
	end
	e:Reset()
end
--
function c1140101.ofilter2_3(c)
	return c:GetFlagEffect(1140101)>0
end
function c1140101.con2_3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,1140101)>0
end
function c1140101.op2_3(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,1140101)
	local sg=Duel.GetMatchingGroup(c1140101.ofilter2_3,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	e:Reset()
end
--