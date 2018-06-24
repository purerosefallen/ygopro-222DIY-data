--幻之月
function c11200028.initial_effect(c)
--
	if not c11200028.global_check then
		c11200028.global_check=true
		local e0=Effect.GlobalEffect()
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAINING)
		e0:SetCondition(c11200028.con0)
		e0:SetOperation(c11200028.op0)
		Duel.RegisterEffect(e0,0)
	end
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11200028+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11200028.tg1)
	e1:SetOperation(c11200028.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c11200028.op2)
	c:RegisterEffect(e2)
--
end
--
function c11200028.con0(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsCode(11200019)
end
--
function c11200028.op0(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,11200025,0,0,0)
end
--
function c11200028.tfilter1(c)
	return (c:IsCode(24094653) 
		or (c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT)))
		and c:IsAbleToHand()
end
function c11200028.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x132,0x21,1100,1100,4,RACE_BEAST,ATTRIBUTE_LIGHT)
		and Duel.IsExistingMatchingCard(c11200028.tfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
--
function c11200028.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc==1 or dc==2 or dc==3 or dc==4 then
		if not c:IsRelateToEffect(e) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		if Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x132,0x21,1100,1100,4,RACE_BEAST,ATTRIBUTE_LIGHT) then
			c:AddMonsterAttribute(TYPE_EFFECT)
			Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
			c:AddMonsterAttributeComplete()
			Duel.SpecialSummonComplete()
		end
	elseif dc==5 or dc==6 then
		local b1=Duel.IsExistingMatchingCard(c11200028.tfilter1,tp,LOCATION_DECK,0,1,nil)
		local b2=Duel.GetFlagEffect(tp,11200025)<1 and Duel.IsPlayerCanDraw(tp,1)
		if not (b1 or b2) then return end
		local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=aux.Stringid(11200028,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(11200028,1)
			opval[off-1]=2
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		local sel=opval[op]
		if sel==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,c11200028.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
			if sg:GetCount()<1 then return end
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		else
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	else
	end
end
--
function c11200028.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_FIELD)
	e2_1:SetCode(EFFECT_UPDATE_ATTACK)
	e2_1:SetTargetRange(LOCATION_MZONE,0)
	e2_1:SetTarget(c11200028.tg2_1)
	e2_1:SetValue(700)
	e2_1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e2_1,tp)
	local e2_2=e2_1:Clone()
	e2_2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2_2,tp)
end
--
function c11200028.tg2_1(e,c)
	return c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
--
