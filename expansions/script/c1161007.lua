--风雪与花·格尔达
function c1161007.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,1161007+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1161007.tg1)
	e1:SetOperation(c1161007.op1)
	c:RegisterEffect(e1)  
--  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c1161007.tg2)
	e2:SetOperation(c1161007.op2)
	c:RegisterEffect(e2)
--
end
--
function c1161007.tfilter1(c)
	return c:GetLevel()==1 and c:IsAbleToRemove() and c:GetAttack()>399
end
function c1161007.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c1161007.tfilter1,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.GetCustomActivityCount(1161007,tp,ACTIVITY_SPSUMMON)==0 and g:GetClassCount(Card.GetCode)>1 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
--
function c1161007.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c1161007.tfilter1,tp,LOCATION_DECK,0,nil)
	local gc=g:GetClassCount(Card.GetCode)
	if gc>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local g1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		local g2=g:Select(tp,1,1,nil)
		g1:Merge(g2)
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local tg=g1:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
--
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_FIELD)
		e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1_1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1_1:SetTargetRange(1,0)
		e1_1:SetLabel(tc:GetCode())
		e1_1:SetValue(c1161007.val1_1)
		e1_1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1_1,tp)
--
		local e1_2=Effect.CreateEffect(c)
		e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1_2:SetLabel(tc:GetCode())
		e1_2:SetCondition(c1161007.con1_2)
		e1_2:SetOperation(c1161007.op1_2)
		e1_2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1_2,tp)
--
		local e1_3=Effect.CreateEffect(c)
		e1_3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1_3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1_3:SetLabel(tc:GetCode())
		e1_3:SetCondition(c1161007.con1_3)
		e1_3:SetOperation(c1161007.op1_3)
		e1_3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1_3,tp)
		local e1_4=Effect.CreateEffect(c)
		e1_4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1_4:SetCode(EVENT_CHAIN_SOLVED)
		e1_4:SetLabel(tc:GetCode())
		e1_4:SetCondition(c1161007.con1_4)
		e1_4:SetOperation(c1161007.op1_4)
		e1_4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1_4,tp)
--
	end
end
--
function c1161007.val1_1(e,re)
	local code=e:GetLabel()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLocation(LOCATION_MZONE) and re:GetHandler():IsCode(code) and not rc:IsImmuneToEffect(e)
end
--
function c1161007.cfilter1_2(c,code)
	return c:IsCode(code)
end
function c1161007.con1_2(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	return eg:FilterCount(c1161007.cfilter1_2,nil,code)>0
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
--
function c1161007.ofilter1_2(c)
	return c:IsDestructable()
end
function c1161007.op1_2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1161007)
	local sel=0
	local cg=Duel.GetMatchingGroup(c1161007.ofilter1_2,tp,0,LOCATION_SZONE,nil)
	if cg:GetCount()>0 then
		sel=Duel.SelectOption(tp,aux.Stringid(1161007,0),aux.Stringid(1161007,1))
	else
		sel=1
	end
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=cg:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.Destroy(sg,REASON_EFFECT)
		end
	else
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--
function c1161007.con1_3(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(c1161007.cfilter1_2,nil,code)>0
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c1161007.op1_3(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,1161008,RESET_CHAIN,0,1)
end
function c1161007.con1_4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,1161008)>0
end
function c1161007.op1_4(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,1161008)
	Duel.ResetFlagEffect(tp,1161008)
	Duel.Hint(HINT_CARD,0,1161007)
	while n>0 do
		local sel=0
		local cg=Duel.GetMatchingGroup(c1161007.ofilter1_2,tp,0,LOCATION_SZONE,nil)
		if cg:GetCount()>0 then
			sel=Duel.SelectOption(tp,aux.Stringid(1161007,0),aux.Stringid(1161007,1))
		else
			sel=1
		end
		if sel==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=cg:Select(tp,1,1,nil)
			if sg:GetCount()>0 then
				Duel.Destroy(sg,REASON_EFFECT)
			end
		else
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		n=n-1
	end
end
--
function c1161007.tfilter2_1(c)
	return c:GetLevel()==1 and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c1161007.tfilter2_2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c1161007.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1161007.tfilter2_1,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(c1161007.tfilter2_2,tp,LOCATION_HAND,0,1,nil) end
end
--
function c1161007.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(1161007,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectMatchingCard(tp,c1161007.tfilter2_2,tp,LOCATION_HAND,0,1,1,nil)
		if g1:GetCount()>0 then
			local tc1=g1:GetFirst()
			if Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT)~=0 then
				local fid=tc1:GetFieldID()
				tc1:RegisterFlagEffect(1161007,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
				if Duel.GetFlagEffect(tp,1161007)==0 then
					Duel.RegisterFlagEffect(tp,1161007,RESET_PHASE+PHASE_END,0,1)
					local e2_3=Effect.CreateEffect(c)
					e2_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2_3:SetCode(EVENT_PHASE+PHASE_END)
					e2_3:SetRange(LOCATION_REMOVED)
					e2_3:SetCountLimit(1)
					e2_3:SetLabel(fid)
					e2_3:SetCondition(c1161007.con2_3)
					e2_3:SetOperation(c1161007.op2_3)
					e2_3:SetReset(RESET_PHASE+PHASE_END)
					tc1:RegisterEffect(e2_3)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g2=Duel.SelectMatchingCard(tp,c1161007.tfilter2_1,tp,LOCATION_REMOVED,0,1,1,nil)
				if g2:GetCount()>0 then
					Duel.SendtoHand(g2,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g2)
				end
			end
		end
	end
end
function c1161007.con2_3(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	return e:GetHandler():GetFlagEffectLabel(1161007)==fid
end
function c1161007.op2_3(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
--